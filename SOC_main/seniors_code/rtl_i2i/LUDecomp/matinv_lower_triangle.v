`timescale 1ns/1ps
module matinv_lower_triangle(input reg [1023:0] inp, input clk, input rst, input start, output reg[1023:0] ainv);

reg [63:0] amat[0:15];
reg [3:0] state;
reg [63:0] outmat[0:15];

reg [63:0] div_in1[0:3],mul_in1[0:3],add_in1[0:3]; 
wire [63:0] div_out[0:3],mul_out[0:3],add_out[0:3];
reg [63:0] div_in2[0:3],mul_in2[0:3],add_in2[0:3];
wire a_ack_add[0:3],b_ack_add[0:3],a_ack_mul[0:3],b_ack_mul[0:3],a_ack_div[0:3],b_ack_div[0:3];
reg c_ack_add[0:3],c_ack_mul[0:3],c_ack_div[0:3];

reg a_stb_add[0:3],b_stb_add[0:3],a_stb_mul[0:3],b_stb_mul[0:3],a_stb_div[0:3],b_stb_div[0:3];
wire c_stb_div[0:3],c_stb_mul[0:3],c_stb_add[0:3];

reg[63:0] temp0[0:3],temp1[0:3],temp2[0:3],temp3[0:3],temp4[0:3],temp5[0:3],temp6[0:3],temp7[0:3],temp8[0:3];

double_divider div0(
	                      .input_a(div_in1[0]),
								 .input_b(div_in2[0]),
								 .input_a_stb(a_stb_div[0]),
								 .input_b_stb(b_stb_div[0]),
								 .output_z_ack(c_ack_div[0]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out[0]),
								 .output_z_stb(c_stb_div[0]),
								 .input_a_ack(a_ack_div[0]),
								 .input_b_ack(b_ack_div[0]));
								 
		double_divider div1(
	                      .input_a(div_in1[1]),
								 .input_b(div_in2[1]),
								 .input_a_stb(a_stb_div[1]),
								 .input_b_stb(b_stb_div[1]),
								 .output_z_ack(c_ack_div[1]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out[1]),
								 .output_z_stb(c_stb_div[1]),
								 .input_a_ack(a_ack_div[1]),
								 .input_b_ack(b_ack_div[1]));
								 
			double_divider div2(
	                      .input_a(div_in1[2]),
								 .input_b(div_in2[2]),
								 .input_a_stb(a_stb_div[2]),
								 .input_b_stb(b_stb_div[2]),
								 .output_z_ack(c_ack_div[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out[2]),
								 .output_z_stb(c_stb_div[2]),
								 .input_a_ack(a_ack_div[2]),
								 .input_b_ack(b_ack_div[2]));
								 
					double_divider div3(
	                      .input_a(div_in1[3]),
								 .input_b(div_in2[3]),
								 .input_a_stb(a_stb_div[3]),
								 .input_b_stb(b_stb_div[3]),
								 .output_z_ack(c_ack_div[3]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out[3]),
								 .output_z_stb(c_stb_div[3]),
								 .input_a_ack(a_ack_div[3]),
								 .input_b_ack(b_ack_div[3]));
	
	
	double_multiplier mul0(
	                      .input_a(mul_in1[0]),
								 .input_b(mul_in2[0]),
								 .input_a_stb(a_stb_mul[0]),
								 .input_b_stb(b_stb_mul[0]),
								 .output_z_ack(c_ack_mul[0]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(mul_out[0]),
								 .output_z_stb(c_stb_mul[0]),
								 .input_a_ack(a_ack_mul[0]),
								 .input_b_ack(b_ack_mul[0]));
								 
		double_multiplier mul1(
	                      .input_a(mul_in1[1]),
								 .input_b(mul_in2[1]),
								 .input_a_stb(a_stb_mul[1]),
								 .input_b_stb(b_stb_mul[1]),
								 .output_z_ack(c_ack_mul[1]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(mul_out[1]),
								 .output_z_stb(c_stb_mul[1]),
								 .input_a_ack(a_ack_mul[1]),
								 .input_b_ack(b_ack_mul[1]));
								 
		double_multiplier mul2(
	                      .input_a(mul_in1[2]),
								 .input_b(mul_in2[2]),
								 .input_a_stb(a_stb_mul[2]),
								 .input_b_stb(b_stb_mul[2]),
								 .output_z_ack(c_ack_mul[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(mul_out[2]),
								 .output_z_stb(c_stb_mul[2]),
								 .input_a_ack(a_ack_mul[2]),
								 .input_b_ack(b_ack_mul[2]));
								 
		double_multiplier mul3(
	                      .input_a(mul_in1[3]),
								 .input_b(mul_in2[3]),
								 .input_a_stb(a_stb_mul[3]),
								 .input_b_stb(b_stb_mul[3]),
								 .output_z_ack(c_ack_mul[3]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(mul_out[3]),
								 .output_z_stb(c_stb_mul[3]),
								 .input_a_ack(a_ack_mul[3]),
								 .input_b_ack(b_ack_mul[3]));
								 
	
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

//INSTANTIATE THE MODULES!!!

always@(posedge clk)
	begin
	if(rst==1)
		begin
			state <= 11;
			{c_ack_div[3],c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;
			{c_ack_mul[3],c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 4'b0000;
			// {c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b000;
			{c_ack_add[3], c_ack_add[2], c_ack_add[1],c_ack_add[0]} <= 4'd0;
			{a_stb_add[3], a_stb_add[2], a_stb_add[1], a_stb_add[0]} <= 4'd0;
			{b_stb_add[3], b_stb_add[2], b_stb_add[1], b_stb_add[0]} <= 4'd0;
			{a_stb_mul[3], a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 4'b0000;
			{a_stb_mul[3], b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 4'b0000;
			{c_ack_div[3], c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;
			{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'b0000;
			{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'b0000;
			outmat[1] <= 1'b0;
			outmat[2] <= 1'b0;
			outmat[3] <= 1'b0;
			outmat[6] <= 1'b0;
			outmat[7] <= 1'b0;
			outmat[11] <= 1'b0;

		end
	else
		begin
		case(state)
		
		0:
		begin
			// {c_ack_div[3], c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;
			//{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'b0000;
			//{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'b0000;
			div_in1[0] <= 64'h3FF0000000000000;
			div_in1[1] <= 64'h3FF0000000000000;
			div_in1[2] <= 64'h3FF0000000000000;
			div_in1[3] <= 64'h3FF0000000000000;
			
			div_in2[0] <= amat[0];
			div_in2[1] <= amat[5];
			div_in2[2] <= amat[10];
			div_in2[3] <= amat[15];

			{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'b1111;
			{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'b1111;
			
			if({c_stb_div[3],c_stb_div[2],c_stb_div[1],c_stb_div[0]}== 4'b1111)
				begin
					outmat[0] <= div_out[0];
					outmat[5] <= div_out[1];
					outmat[10] <= div_out[2];
					outmat[15] <= div_out[3];
					{c_ack_div[3],c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b1111;
					state <= 1;
				end
		end
		
		1:
		begin
			{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'd0;
			{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'd0;
			{c_ack_div[3],c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;

			// {c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b000;
			//{a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 3'b000;
			//{b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 3'b000;
			mul_in1[0] <= amat[4];
			mul_in2[0] <= outmat[0];
			
			mul_in1[1] <= amat[9];
			mul_in2[1] <= outmat[5];
			
			mul_in1[2] <= amat[14];
			mul_in2[2] <= outmat[10];

			{a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 3'b111;
			{b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 3'b111;
			
			if({c_stb_mul[2],c_stb_mul[1],c_stb_mul[0]}== 3'b111)
				begin
					temp2[0] <= {~mul_out[0][63],mul_out[0][62:0]};
					temp2[1] <= {~mul_out[1][63],mul_out[1][62:0]};
					temp2[2] <= {~mul_out[2][63],mul_out[2][62:0]};
					{c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b111;
					state <= 2;
				end
		end
		
		2:
		begin
			{a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 3'b000;
			{b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 3'b000;
			{c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b000;

			{a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 3'b111;
			{b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 3'b111;
			div_in1[0] <= temp2[0];
			div_in1[1] <= temp2[1];
			div_in1[2] <= temp2[2];
			
			div_in2[0] <= amat[5];
			div_in2[1] <= amat[10];
			div_in2[2] <= amat[15];
			
			if({c_stb_div[2],c_stb_div[1],c_stb_div[0]}== 3'b111)
				begin
					outmat[4] <= div_out[0];
					outmat[9] <= div_out[1];
					outmat[14] <= div_out[2];
					{c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 3'b111;
					state <= 3;
				end
				
		end
		
		3:
		begin
			{c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 3'd0;
			{a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 3'd0;
			{b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 3'd0;

			// {c_ack_mul[3],c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 4'b0000;
			{a_stb_mul[3],a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 4'b1111;
			{b_stb_mul[3],b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 4'b1111;
			
			mul_in1[0] <= amat[8];
			mul_in2[0] <= outmat[0];
			
			mul_in1[1] <= amat[9];
			mul_in2[1] <= outmat[4];
			
			mul_in1[2] <= amat[13];
			mul_in2[2] <= outmat[5];
			
			mul_in1[3] <= amat[14];
			mul_in2[3] <= outmat[9];
			
			if({c_stb_mul[3],c_stb_mul[2],c_stb_mul[1],c_stb_mul[0]}== 4'b1111)
				begin
					temp3[0] <= {~mul_out[0][63],mul_out[0][62:0]};
					temp3[1] <= {~mul_out[1][63],mul_out[1][62:0]};
					temp3[2] <= {~mul_out[2][63],mul_out[2][62:0]};
					temp3[3] <= {~mul_out[3][63],mul_out[3][62:0]};
					{c_ack_mul[3],c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 4'b1111;
					state <= 4;
				end
		end
		
		4:
		begin
			{c_ack_mul[3],c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 4'b1111;
			{a_stb_mul[3],a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 4'd0;
			{b_stb_mul[3],b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 4'd0;

			// {c_ack_div[3], c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;
			{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'b1111;
			{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'b1111;
			div_in1[0] <= temp3[0];
			div_in1[1] <= temp3[1];
			div_in1[2] <= temp3[2];
			div_in1[3] <= temp3[3];
			
			div_in2[0] <= amat[10];
			div_in2[1] <= amat[10];
			div_in2[2] <= amat[15];
			div_in2[3] <= amat[15];
			
			if({c_stb_div[3],c_stb_div[2],c_stb_div[1],c_stb_div[0]}== 4'b1111)
				begin
					temp4[0] <= div_out[0];
					temp4[1] <= div_out[1];
					temp4[2] <= div_out[2];
					temp4[3] <= div_out[3];
					{c_ack_div[3],c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b1111;
					state <= 5;
				end
		end
		
		5:
		begin
			{c_ack_div[3],c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 4'b0000;
			{a_stb_div[3], a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 4'b0000;
			{b_stb_div[3], b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 4'b0000;

			// {c_ack_add[1],c_ack_add[0]} <= 2'b00;
			{a_stb_add[1],a_stb_add[0]} <= 2'b11;
			{b_stb_add[1],b_stb_add[0]} <= 2'b11;
			add_in1[0] <= temp4[0];
			add_in2[0] <= temp4[1];
			
			add_in1[1] <= temp4[2];
			add_in2[1] <= temp4[3];
			
			if({c_stb_add[1],c_stb_add[0]}== 2'b11)
				begin
					outmat[8] <= add_out[0];
					outmat[13] <= add_out[1];
					{c_ack_add[1],c_ack_add[0]} <= 2'b11;
					state <= 6;
				end
		end
		
		6:
		begin
			// {c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b000;
			{a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 3'b111;
			{b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 3'b111;
			
			{c_ack_add[1],c_ack_add[0]} <= 2'b00;
			{a_stb_add[1],a_stb_add[0]} <= 2'b00;
			{b_stb_add[1],b_stb_add[0]} <= 2'b00;


			mul_in1[0] <= amat[12];
			mul_in2[0] <= outmat[0];
			
			mul_in1[1] <= amat[13];
			mul_in2[1] <= outmat[4];
			
			mul_in1[2] <= amat[14];
			mul_in2[2] <= outmat[8];
			
			
			if({c_stb_mul[2],c_stb_mul[1],c_stb_mul[0]}== 3'b111)
				begin
					temp6[0] <= {~mul_out[0][63],mul_out[0][62:0]};
					temp6[1] <= {~mul_out[1][63],mul_out[1][62:0]};
					temp6[2] <= {~mul_out[2][63],mul_out[2][62:0]};
					{c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b111;
					state <= 7;
				end
		end
		
		7:
		begin
			{c_ack_mul[2],c_ack_mul[1],c_ack_mul[0]} <= 3'b000;
			{a_stb_mul[2],a_stb_mul[1],a_stb_mul[0]} <= 3'b000;
			{b_stb_mul[2],b_stb_mul[1],b_stb_mul[0]} <= 3'b000;

			// {c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 3'b000;
			{b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 3'b111;
			{a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 3'b111;
			div_in1[0] <= temp6[0];
			div_in2[0] <= amat[15];
			
			div_in1[1] <= temp6[1];
			div_in2[1] <= amat[15];
			
			div_in1[2] <= temp6[2];
			div_in2[2] <= amat[15];
			
			if({c_stb_div[2],c_stb_div[1],c_stb_div[0]}== 3'b111)
				begin
					temp7[0] <= div_out[0];
					temp7[1]	<= div_out[1];
					temp7[2] <= div_out[2];
					
					{c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 3'b111;
					state <= 8;
				end
		end
		
		8:
		begin
			{c_ack_div[2],c_ack_div[1],c_ack_div[0]} <= 3'b000;
			{b_stb_div[2],b_stb_div[1],b_stb_div[0]} <= 3'b111;
			{a_stb_div[2],a_stb_div[1],a_stb_div[0]} <= 3'b111;


			// c_ack_add[0] <= 1'b0;
			b_stb_add[0] <= 1'b1;
			a_stb_add[0] <= 1'b1;
			
			add_in1[0] <= temp7[0];
			add_in2[0] <= temp7[1];
			
			if(c_stb_add[0]== 1'b1)
				begin
					temp8[0] <= add_out[0];
					c_ack_add[0] <= 1'b1;
					state <= 12;
				end
		end
		
		12:
		begin
			b_stb_add[0] <= 1'b0;
			a_stb_add[0] <= 1'b0;
			c_ack_add[0] <= 1'b0;
			state <= 9;
		end

		9:
		begin
			// c_ack_add[0] <= 1'b0;
			b_stb_add[0] <= 1'b1;
			a_stb_add[0] <= 1'b1;
			
			add_in1[0] <= temp8[0];
			add_in2[0] <= temp7[2];
			
			if(c_stb_add[0]== 1'b1)
				begin
					outmat[12] <= add_out[0];
					c_ack_add[0] <= 1'b1;
					state <= 10;
				end
		end
		
		10:
		begin
			c_ack_add[0] <= 1'b0;
			b_stb_add[0] <= 1'b0;
			a_stb_add[0] <= 1'b0;
			// outmat[1] <= 1'b0;
			// outmat[2] <= 1'b0;
			// outmat[3] <= 1'b0;
			// outmat[6] <= 1'b0;
			// outmat[7] <= 1'b0;
			// outmat[11] <= 1'b0;
			state <= 11;
			//ainv <= outmat;
			ainv[63:0] <= outmat[0];
			ainv[127:64] <= outmat[1];
			ainv[191:128] <= outmat[2];
			ainv[255:192] <= outmat[3];
			ainv[319:256] <= outmat[4];
			ainv[383:320] <= outmat[5];
			ainv[447:384] <= outmat[6];
			ainv[511:448] <= outmat[7];
			ainv[575:512] <= outmat[8];
			ainv[639:576] <= outmat[9];
			ainv[703:640] <= outmat[10];
			ainv[767:704] <= outmat[11];
			ainv[831:768] <= outmat[12];
			ainv[895:832] <= outmat[13];
			ainv[959:896] <= outmat[14];
			ainv[1023:960] <= outmat[15];
				
		end
		
		11:
		begin
			if(start==0)
				state <= 11;
			else if(start==1)
				begin
					state <= 0;
					amat[0] <= inp[63:0];
					amat[1] <= inp[127:64];
					amat[2] <= inp[191:128];
					amat[3] <= inp[255:192];
					amat[4] <= inp[319:256];
					amat[5] <= inp[383:320];
					amat[6] <= inp[447:384];
					amat[7] <= inp[511:448];
					amat[8] <= inp[575:512];
					amat[9] <= inp[639:576];
					amat[10] <= inp[703:640];
					amat[11] <= inp[767:704];
					amat[12] <= inp[831:768];
					amat[13] <= inp[895:832];
					amat[14] <= inp[959:896];
					amat[15] <= inp[1023:960];
				end
		end
	endcase
	end
	end

endmodule
		
