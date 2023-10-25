`timescale 1ps / 1ps
module sc_wrapper_mat_add
    #(parameter mat_num_row = 2)(
    clk,
    reset,
    address,
    writedata,
    write,
    read,
    byteenable,
    readdata,
    waitrequest
);

    input              clk;
    input              reset;
    
    input        [22:0] address;    //The address of the regfiles (a and b)
    input       [63:0] writedata; // 64-bit represents the whole word, while the write line is actually 32-bits each time
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted

 
    reg [1:0] state;

    reg [63:0] a[0 : 2 * mat_num_row * mat_num_row - 1 ];
    reg [63:0] b[0 : 2 * mat_num_row * mat_num_row - 1];
    reg [63:0] c[0 : 2 * mat_num_row * mat_num_row - 1];

    // reg [10:0] cntxa;


    reg start;
    reg [2 * 64 *mat_num_row * mat_num_row - 1 : 0] inpa;
    reg [2 * 64 *mat_num_row * mat_num_row - 1 : 0] inpb;
    wire [2 * 64 *mat_num_row * mat_num_row - 1 : 0] outc;
    reg valid;
    wire done;
    reg output_read;
    integer j;

    sc_complex_mat4add #(.mat_num_row(mat_num_row)) u0 (
        .clk(clk),
        .rst(reset),
        .start(start),
        .valid(valid),
        .mat_a(inpa),
        .mat_b(inpb),
        .mat_out(outc),
        .done(done),
        .output_read(output_read));


    assign readdata = read ? c[address]:0; 
    always@(posedge clk)
    begin
        if(reset == 1)
        begin
            state <= 0;
            waitrequest <= 0;
            // cntxa <= 0;
            start <= 0;
            inpa <= 0;
            inpb <= 0;
            valid <= 0;
            output_read<=0;
            
        end
        else
        begin
            case(state)
                0:
                    begin
                        output_read<=0; 
                        if(address != 2* 2*mat_num_row*mat_num_row) 
                        begin 
                            if(write == 1 && address < 2*mat_num_row*mat_num_row)
                            begin 
                                if(byteenable == 8'h0F)
                                begin 
                                    a[address][31:0] <= writedata[31:0];
                                end
                                else if(byteenable == 8'hF0)
                                begin 
                                    a[address][63:32] <= writedata[63:32];
                                end
                                state <= 0;
                            end
                        //Writing to b matrix
                        else if(write == 1 && address >= 2*mat_num_row*mat_num_row)
                        begin 
                            if(byteenable == 8'h0F)
                            begin 
                                b[address - 2*mat_num_row*mat_num_row][31:0] <= writedata[31:0];
                            end
                            else if (byteenable == 8'hF0)
                            begin 
                                 b[address - 2*mat_num_row*mat_num_row][63:32] <= writedata[63:32];
                            end
                            state <= 0;
                        end
                        end
                        else if (address == 2 * 2*mat_num_row*mat_num_row)
                            begin 
                                state <= 1;
                                waitrequest <= 1;
                            end
                    end
                1:
                    begin

                        for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin
                            inpa [64 * j +: 64] <= a[j];
                            inpb [64 * j +: 64] <= b[j];
                        end

                        valid <= 1;
                        start <= 1;
                        if(done == 1) begin 
                            state <= 2;
                            start<=0;
                            valid<=0;
                        end
                    end
                2:
                begin
                    for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin 
                        c[j] <= outc[64 * j +: 64];
                    end
                    state <= 0;
                    output_read<=1;
                    waitrequest <= 0;
                 end


            endcase
        end
    end



endmodule
