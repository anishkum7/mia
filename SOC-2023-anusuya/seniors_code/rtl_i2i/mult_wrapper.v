`timescale 1ns / 1ps
module mult_wrapper(
    clk,
    reset,
    address,
    writedata,
    write,
    read,
    byteenable,
    readdata,
    waitrequest);
    
    input              clk;
    input              reset;
    
    input        [2:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input       [63:0] writedata; // 32-bit write data line
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output      reg [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted
    
    //Memory mapped registers
    //TODO Sarang - Make this memory bank bigger?
    reg         [63:0] input_a;
    reg         [63:0] input_b;
    reg                reset_2;
    wire        [63:0] mult_output_z;
    
    reg                input_a_stb;
    reg                input_b_stb;
    
    wire               input_a_ack;
    wire               input_b_ack;
    wire               output_z_stb;
    reg output_z_ack;
    
    
//    assign output_z_ack = 1'b1;
    
    always @ (posedge clk)
    begin
        if (reset == 1'b1 || reset_2 == 1'b1)
        begin 
            input_a                                <= 0;
            input_b                                <= 0;
            input_a_stb                            <= 0;
            input_b_stb                            <= 0;
            waitrequest                            <= 0;
            //Making readdata 0 on reset
            reset_2                                <= 0;
        end
        else
        begin 
            if(write == 1'b1 && !waitrequest)
            begin
                case(address) 
                    3'h0: begin 
                            if (byteenable == 8'h0F) begin
                                input_a[31:0]     <= writedata[31:0]; 
                            end
                            if (byteenable == 8'hF0) begin
                                input_a[63:32] <= writedata[63:32];
                                input_a_stb <= 1; 
                            end
                          end
                    3'h1: begin 
                            if (byteenable == 8'h0F) begin
                                input_b[31:0]     <= writedata[31:0]; 
//                                input_b_stb <= 1; 
                            end
                            if (byteenable == 8'hF0) begin
                                input_b[63:32] <= writedata[63:32];
                                input_b_stb <= 1;
                            end
                          end
                    3'h2: begin
                            if (writedata == 64'h1) begin
                                reset_2     <= 1;
                            end
                          end
                endcase
            end
    
            if (input_a_stb && input_a_ack) begin
                input_a_stb <= 0;
            end
            
            if (output_z_ack && output_z_stb) begin
                output_z_ack <= 0;
                waitrequest <= 0;
            end
   
            if (input_b_stb && input_b_ack) begin
                input_b_stb <= 0;
                waitrequest <= 1;
                output_z_ack <= 1;
            end
            
            if(read == 1'b1) 
            begin
                readdata = mult_output_z;
            end
        
            
            
//            mult_output_z_q        <= mult_output_z;
//            mult_output_z_stb_q    <= mult_output_z_stb;
            end
     
    end
    double_multiplier mult_obj(input_a, input_b, input_a_stb, input_b_stb, output_z_ack, clk, reset||reset_2, mult_output_z, output_z_stb, input_a_ack, input_b_ack);

endmodule
