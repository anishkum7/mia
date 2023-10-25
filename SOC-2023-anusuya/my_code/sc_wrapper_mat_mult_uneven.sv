`timescale 1ps / 1ps
module wrapper_mat_mult_uneven
    #(parameter out_row=2, parameter out_col=3, parameter common_factor=2)(
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

    reg [63:0] a[0 : 2 * out_row * common_factor - 1 ];
    reg [63:0] b[0 : 2 * common_factor * out_col - 1];
    reg [63:0] c[0 : 2 * out_row * out_col - 1];

    // reg [10:0] cntxa;


    reg start;
    reg [2 * 64 * out_row * common_factor - 1 : 0] inpa;
    reg [2 * 64 * common_factor * out_col - 1 : 0] inpb;
    wire [2 * 64 * out_row * out_col - 1 : 0] outc;
    reg valid;
    wire done;
    integer j;

    mat_mult_uneven#(.out_row(out_row), .out_col(out_col), .common_factor(common_factor)) u0 (
        .clk(clk),
        .rst(reset),
        .start(start),
        .valid(valid),
        .mat_a(inpa),
        .mat_b(inpb),
        .mat_out(outc),
        .done(done));

    
    integer mat_a_address = (2*out_row*common_factor);
    integer mat_b_address = (2*out_col*common_factor);
    integer final_address = mat_a_address+mat_b_address;
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
            
        end
        else
        begin
            case(state)
                0:
                    begin 
                        if(address != final_address) 
                        begin 
                            if(write == 1 && address < mat_a_address)
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
                            else if(write == 1 && address >= mat_a_address)
                            begin 
                                if(byteenable == 8'h0F)
                                begin 
                                    b[address - mat_a_address][31:0] <= writedata[31:0];
                                end
                                else if (byteenable == 8'hF0)
                                begin 
                                    b[address - mat_a_address][63:32] <= writedata[63:32];
                                end
                                state <= 0;
                            end
                        end
                        else if (address == final_address)
                            begin 
                                state <= 1;
                                waitrequest <= 1;
                            end
                    end
                1:
                    begin

                        for(j = 0; j < mat_a_address; j++) begin
                            inpa [64 * j +: 64] <= a[j];
                        end

                        for(j=0;j<mat_b_address;j++) begin
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
                    for(j = 0; j < 2*out_row*out_col; j++) begin 
                        c[j] <= outc[64 * j +: 64];
                    end
                    state <= 0;
                    waitrequest <= 0;
                end
            endcase
        end
    end



endmodule
