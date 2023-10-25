// Code your design here
/*


Matrix 4x4 complex addition


*/

`include "adder.sv"

`timescale 1ns / 1ps
module mat4add_complex
#(parameter mat_num_row = 2)(
    input clk,
    input rst,
    input [(2*64*mat_num_row*mat_num_row-1):0] a,
    input [(2*64*mat_num_row*mat_num_row-1):0] b,
    input start,
    output reg [(2*64*mat_num_row*mat_num_row-1):0] c,
    output reg done
);

//generate x instances

reg ready = 1'b1;
reg [63:0] add_in1[0:2*mat_num_row*mat_num_row-1];
reg [63:0] add_in2[0:2*mat_num_row*mat_num_row-1];
reg a_stb_add[0:2*mat_num_row*mat_num_row-1]; reg b_stb_add[0:2*mat_num_row*mat_num_row-1]; reg c_ack_add[0:2*mat_num_row*mat_num_row-1];
wire [63:0] add_out[0:2*mat_num_row*mat_num_row-1];
wire c_stb_add[0:2*mat_num_row*mat_num_row-1]; wire a_ack_add[0:2*mat_num_row*mat_num_row-1]; wire b_ack_add[0:2*mat_num_row*mat_num_row-1];

// logic lsb_value;
logic c_stb_flag;

genvar i;

generate
  for(i = 0; i < 2*mat_num_row*mat_num_row; i = i + 1) begin
    double_adder u0 (.input_a(add_in1[i]),
                        .input_b(add_in2[i]),
                        .input_a_stb(a_stb_add[i]),
                        .input_b_stb(b_stb_add[i]),
                        .output_z_ack(c_ack_add[i]),
                        .clk(clk),
                        .rst(rst),
                        .output_z(add_out[i]),
                        .output_z_stb(c_stb_add[i]),
                        .input_a_ack(a_ack_add[i]),
                        .input_b_ack(b_ack_add[i])
                        );
  end
  
endgenerate

    integer j;

    reg [2:0] state;
    
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            state <= 0;
            done <= 0;
            // {add_in1[0], add_in1[1], add_in1[2], add_in1[3]} <= 'd0;
            // {add_in2[0], add_in2[1], add_in2[2], add_in2[3]} <= 'd0;
            // {a_stb_add[0], a_stb_add[1], a_stb_add[2], a_stb_add[3]} <= 'd0;
            // {b_stb_add[0], b_stb_add[1], b_stb_add[2], b_stb_add[3]} <= 'd0;
            // {c_ack_add[0], c_ack_add[1], c_ack_add[2], c_ack_add[3]} <= 'd0;

            for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin
                add_in1[j] <= 'd0;
                add_in2[j] <= 'd0;
                a_stb_add[j] <= 'd0;
                b_stb_add[j] <= 'd0;
                c_ack_add[j] <= 'd0;
            end
        end
        else
        begin
            case(state)
                0:
                begin
                    // {c_ack_add[0], c_ack_add[1], c_ack_add[2], c_ack_add[3]} <= 'd0; 
                    for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin
                        c_ack_add[j] <= 'd0;
                    end

                    done <= 0; //Set done to zero.
                    if(start == 1) //if it's ready..? oh. data from the previous module
                    begin

                        for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin 
                            a_stb_add[j] <= 4'hF;
                            b_stb_add[j] <= 4'hF;                            
                            add_in1[j] <= a[j*64 +: 64];
                            add_in2[j] <= b[j*64 +: 64];
                        end
                
                        state <= 1;
                    end
                end
                1:
                begin
                    // if({c_stb_add[0], c_stb_add[1], c_stb_add[2], c_stb_add[3]} == 4'hF)

                    for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin 
                        if(c_stb_add[j] == 1'b1) begin 
                            c_stb_flag <= 1'b1;
                        end
                        else begin 
                            c_stb_flag <= 1'b0;
                        end
                    end
                    
                    if(c_stb_flag == 1'b1)
                    begin

                        for(j = 0; j < 2*mat_num_row*mat_num_row; j++) begin 
                            c_ack_add[j] <= 4'hF;
                            a_stb_add[j] <= 4'h0;
                            b_stb_add[j] <= 4'h0;
                            // else begin 
                                c[j*64+: 64] <= add_out[j];
                            // end
                        end

                        state <= 0;
                        done <= 1;
                    end
                end

            endcase
        end
    end


endmodule
