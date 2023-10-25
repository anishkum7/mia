/*


Matrix 4x4 addition


*/
`timescale 1ns / 1ps
module mat4add(
    input clk,
    input rst,
    input [255:0] a,
    input [255:0] b,
    input start,
    output reg [255:0] c,
    output reg done
);


    reg [63:0] add_in1[0:3];
	reg [63:0] add_in2[0:3];
	reg a_stb_add[0:3]; reg b_stb_add[0:3]; reg c_ack_add[0:3];
	wire [63:0] add_out[0:3];
	wire c_stb_add[0:3]; wire a_ack_add[0:3]; wire b_ack_add[0:3];


    double_adder add0(
	                      .input_a(add_in1[0]),
								 .input_b(add_in2[0]),
								 .input_a_stb(a_stb_add[0]),
								 .input_b_stb(b_stb_add[0]),
								 .output_z_ack(c_ack_add[0]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(add_out[0]),
								 .output_z_stb(c_stb_add[0]),
								 .input_a_ack(a_ack_add[0]),
								 .input_b_ack(b_ack_add[0]));
								 
	double_adder add1(
	                      .input_a(add_in1[1]),
								 .input_b(add_in2[1]),
								 .input_a_stb(a_stb_add[1]),
								 .input_b_stb(b_stb_add[1]),
								 .output_z_ack(c_ack_add[1]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(add_out[1]),
								 .output_z_stb(c_stb_add[1]),
								 .input_a_ack(a_ack_add[1]),
								 .input_b_ack(b_ack_add[1]));
								 
	double_adder add2(
	                      .input_a(add_in1[2]),
								 .input_b(add_in2[2]),
								 .input_a_stb(a_stb_add[2]),
								 .input_b_stb(b_stb_add[2]),
								 .output_z_ack(c_ack_add[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(add_out[2]),
								 .output_z_stb(c_stb_add[2]),
								 .input_a_ack(a_ack_add[2]),
								 .input_b_ack(b_ack_add[2]));
    
    double_adder add3(
	                      .input_a(add_in1[3]),
								 .input_b(add_in2[3]),
								 .input_a_stb(a_stb_add[3]),
								 .input_b_stb(b_stb_add[3]),
								 .output_z_ack(c_ack_add[3]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(add_out[3]),
								 .output_z_stb(c_stb_add[3]),
								 .input_a_ack(a_ack_add[3]),
								 .input_b_ack(b_ack_add[3]));


    reg [2:0] state;
    
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            state <= 0;
            done <= 0;
            {add_in1[0], add_in1[1], add_in1[2], add_in1[3]} <= 'd0;
            {add_in2[0], add_in2[1], add_in2[2], add_in2[3]} <= 'd0;
            {a_stb_add[0], a_stb_add[1], a_stb_add[2], a_stb_add[3]} <= 'd0;
            {b_stb_add[0], b_stb_add[1], b_stb_add[2], b_stb_add[3]} <= 'd0;
            {c_ack_add[0], c_ack_add[1], c_ack_add[2], c_ack_add[3]} <= 'd0;
        end
        else
        begin
            case(state)
                0:
                begin
                    {c_ack_add[0], c_ack_add[1], c_ack_add[2], c_ack_add[3]} <= 'd0; 
                    done <= 0;
                    if(ready == 1)
                    begin
                        add_in1[0] <= a[127:64];
                        add_in2[0] <= b[127:64];

                        add_in1[1] <= a[63:0];
                        add_in2[1] <= b[63:0];

                        add_in1[2] <= a[255:192];
                        add_in2[2] <= b[255:192];

                        add_in1[3] <= a[191:128];
                        add_in2[3] <= b[191:128];
                        
                        {a_stb_add[0], a_stb_add[1], a_stb_add[2], a_stb_add[3]} <= 4'hF;
                        {b_stb_add[0], b_stb_add[1], b_stb_add[2], b_stb_add[3]} <= 4'hF;
                        
                        state <= 1;
                    end
                end
                1:
                begin
                    if({c_stb_add[0], c_stb_add[1], c_stb_add[2], c_stb_add[3]} == 4'hF)
                    begin
                        {c_ack_add[0], c_ack_add[1], c_ack_add[2], c_ack_add[3]} <= 'dF; 
                        {a_stb_add[0], a_stb_add[1], a_stb_add[2], a_stb_add[3]} <= 4'h0;
                        {b_stb_add[0], b_stb_add[1], b_stb_add[2], b_stb_add[3]} <= 4'h0;

                        c[63:0] <= add_out[0];
                        c[127:64] <= add_out[1];
                        c[191:128] <= add_out[2];
                        c[255:192] <= add_out[3];
                        state <= 0;
                        done <= 1;
                    end
                end

            endcase
        end
    end


endmodule
