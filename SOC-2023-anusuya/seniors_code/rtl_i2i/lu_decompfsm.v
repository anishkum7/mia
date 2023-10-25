/*

Matrix LU Decomposition


*/

module matlu2 (input[1023:0] inp, input clk, input rst, input start, output reg [1023:0] ans);
	
	//localparam n=2;
	reg [63:0] a[0:15];
	reg [2:0] state;
	reg [1:0] cnt;
	// count=2'b00;
	
	reg [63:0] div_in[0:2];
	reg [63:0] pivot;
	reg a_stb_div[0:2]; reg b_stb_div[0:2]; reg c_ack_div[0:2];
	reg [63:0] div_out[0:2];
	reg c_stb_div[0:2]; reg a_ack_div[0:2]; reg b_ack_div[0:2];
	
	reg [63:0] mul_in1[0:2];
	reg [63:0] mul_in2[0:2];
	reg a_stb_mul[0:2]; reg b_stb_mul[0:2]; reg c_ack_mul[0:2];
	reg [63:0] mul_out[0:2];
	reg c_stb_mul[0:2]; reg a_ack_mul[0:2]; reg b_ack_mul[0:2];
	
	reg [63:0] sub_in1[0:2];
	reg [63:0] sub_in2[0:2];
	reg a_stb_sub[0:2]; reg b_stb_sub[0:2]; reg c_ack_sub[0:2];
	reg [63:0] sub_out[0:2];
	reg c_stb_sub[0:2]; reg a_ack_sub[0:2]; reg b_ack_sub[0:2];
	
	// assign ll[0][0] = 1;
	// assign ll[1][1] = 1;
	// assign ll[2][2] = 1;
	
	// reg[63:0] temp_a,temp_b,temp_c,temp_d,temp_e,temp_f,temp_g,temp_h,temp_i;
	
	
	
	/*reg [63:0] div1_in; div2_in; div3_in;
	reg pivot_1,pivot_2,pivot_3;
	reg a_stb_div1,a_stb_div2,a_stb_div3,b_stb_div1,b_stb_div2,b_stb_div3;
	reg c_ack_div1, c_ack_div2, c_ack_div3;
	reg [63:0] div1_out, div2_out, div3_out;
	reg c_stb_div1, c_stb_div2, c_stb_div3, a_ack_div1, a_ack_div2, a_ack_div3, b_ack_div1, b_ack_div2, b_ack_div3;*/
	
	double_divider [0:2] div1(
	                      .input_a(div_in),
								 .input_b(pivot),
								 .input_a_stb(a_stb_div),
								 .input_b_stb(b_stb_div),
								 .output_z_ack(c_ack_div),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out),
								 .output_z_stb(c_stb_div),
								 .input_a_ack(a_ack_div),
								 .input_b_ack(b_ack_div));
	
	
	double_multiplier [0:2] mul1(
	                      .input_a(mul_in1),
								 .input_b(mul_in2),
								 .input_a_stb(a_stb_mul),
								 .input_b_stb(b_stb_,mul),
								 .output_z_ack(c_ack_mul),
								 .clk(clk),
								 .rst(rst),
								 .output_z(mul_out),
								 .output_z_stb(c_stb_mul),
								 .input_a_ack(a_ack_mul),
								 .input_b_ack(b_ack_mul));
								 
	
	double_adder [0:2] sub1(
	                      .input_a(sub_in1),
								 .input_b(sub_in2),
								 .input_a_stb(a_stb_sub),
								 .input_b_stb(b_stb_sub),
								 .output_z_ack(c_ack_sub),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out),
								 .output_z_stb(c_stb_sub),
								 .input_a_ack(a_ack_sub),
								 .input_b_ack(b_ack_sub));
	/*double_divider div2(
	                      .input_a(div2_in),
								 .input_b(pivot_2),
								 .input_a_stb(a_stb_div2),
								 .input_b_stb(b_stb_div2),
								 .output_z_ack(c_ack_div2),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div2_out),
								 .output_z_stb(c_stb_div2),
								 .input_a_ack(a_ack_div2),
								 .input_b_ack(b_ack_div2));
								 
	double_divider div3(
	                      .input_a(div3_in),
								 .input_b(pivot_3),
								 .input_a_stb(a_stb_div3),
								 .input_b_stb(b_stb_div3),
								 .output_z_ack(c_ack_div3),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div3_out),
								 .output_z_stb(c_stb_div3),
								 .input_a_ack(a_ack_div3),
								 .input_b_ack(b_ack_div3));*/
								 
	
	reg [1:0] mult_cnt;
	reg [1:0] sub_cnt;
	reg [63:0] tmp[0:8];
								 
	always@(posedge clk)
		begin
		
		if(rst == 1)
		begin
			mult_cnt <= 0;
			sub_cnt <= 0;
			state <= 7;
			cnt <= 0;
		end
		else
		begin
		case(state):
		
		0: 
		begin
			c_ack_div[0:2] <= 3'd0;
			c_ack_mul[0:2] <= 3'd0;
			c_ack_sub[0:2] <= 3'd0;
			// if(count==2'b00)
			// 	begin
					// reg [63:0] a[0:15]
			pivot <= a[cnt*4 + cnt];
			div_in[0] <= a[(4*cnt + cnt +4)%16];
			div_in[1] <= a[(4*cnt + cnt +8)%16];
			div_in[2] <= a[(4*cnt + cnt +12)%16];
			a_stb_div[2:0] <=3'b111;
			b_stb_div[2:0] <=3'b111;
			if(c_stb_div == 3'b111)
			begin
				state <= 1;
			end
			else
			begin
				state <= 0;
			end
		end
			
			//if(count==2'b11)
			//Need to do assignment to ll and uu
			
		1:
		begin
			if(cnt == 0)
			begin
				a[(4*cnt + cnt +4)%16] <= div[0];
				a[(4*cnt + cnt +8)%16] <= div[1];
				a[(4*cnt + cnt +12)%16] <= div[2];
			end
			else
			begin
				a[(4*cnt + cnt +4)%16] <= div[0];
				a[(4*cnt + cnt +8)%16] <= div[1];
			end
			else
			begin
				a[(4*cnt + cnt +12)%16] <= div[2];
			end
			a_stb_div[2:0] <=3'd0;
			b_stb_div[2:0] <=3'd0;
			c_ack_div <= 3'b111;
			state <= 2;
		end

		2: //mult1
		begin
			c_ack_mul <= 0;
			c_ack_div <= 3'd0;
			mul_in1[0] <= a[(4*cnt + cnt +4)%16];
			mul_in1[1] <= a[(4*cnt + cnt +8)%16];
			mul_in1[2] <= a[(4*cnt + cnt +12)%16];
			
			mul_in2[0] <= a[(4*cnt + cnt + mult_cnt)%16];
			mul_in2[1] <= a[(4*cnt + cnt + mult_cnt)%16];
			mul_in2[2] <= a[(4*cnt + cnt + mult_cnt)%16];
			a_stb_mul <= 3'b111;
			b_stb_mul <= 3'b111;
			if(c_stb_mul == 3'b111)
			begin
				state <= 3;
			end		
			else
			begin
				state <= 2;
			end
		end
		
		3: //mult2
		begin
			tmp[mult_cnt] <= {1, mul_out[0][62:0]};
			tmp[mult_cnt+3] <= {1, mul_out[0][62:0]};
			tmp[mult_cnt+6] <= {1, mul_out[0][62:0]};
			c_ack_mul <= 1;
			if(mult_cnt == 2)
			begin
				mult_cnt <= 0;
				state <= 4;
			end
			else
			begin
				mult_cnt <= mult_cnt + 1;
				state <= 2;
			end
		end

		4: //sub1
		begin
			c_ack_mul <= 0;
			c_ack_sub <= 3'd0;
			sub_in1[0] <= a[(4*cnt + cnt + 5)%16];
			sub_in1[1] <= a[(4*cnt + cnt + 9)%16];
			sub_in1[2] <= a[(4*cnt + cnt + 13)%16];
			
			sub_in2[0] <= tmp[sub_cnt];
			sub_in2[1] <= tmp[sub_cnt+3];
			sub_in2[2] <= tmp[sub_cnt+6];
			a_stb_sub <= 3'b111;
			b_stb_sub <= 3'b111;
			if(c_stb_sub == 3'b111)
			begin
				state <= 5;
			end		
			else
			begin
				state <= 4;
			end
		end

		5: //sub2
		begin
			if(cnt == 0)
			begin
				a[sub_cnt+5] <= sub_out[0];
				a[sub_cnt+9] <= sub_out[1];
				a[sub_cnt+13] <= sub_out[2];
			end
			else if(cnt == 1)
			begin
				if(sub_cnt <= 1)
				begin
					a[sub_cnt+10] <= sub_out[0];
					a[sub_cnt+14] <= sub_out[1];
				end
			end
			else if(cnt == 2)
			begin
				if(sub_cnt <= 0)
				a[sub_cnt+15] <= sub_out[0]
			end
			c_ack_sub <= 1;
			if(sub_cnt == 2)
			begin
				sub_cnt <= 0;
				state <= 6;
			end
			else
			begin
				sub_cnt <= sub_cnt + 1;
				state <= 4;
			end
		end

		6:
		begin
			if(cnt == 2)
			begin
				cnt <= 0;
				state <= 7;
				ans <= a;
			end
			else
			begin
				cnt <= cnt + 1;
				state <= 0;
			end
		end

		7:
		begin
			if(start == 1)
			begin
				state <= 0;
				a[0] <= inp[63:0];
				a[1] <= inp[127:64];
				a[2] <= inp[191:128];
				a[3] <= inp[255:192];
				a[4] <= inp[319:256];
				a[5] <= inp[383:320];
				a[6] <= inp[447:384];
				a[7] <= inp[511:448];
				a[8] <= inp[575:512];
				a[9] <= inp[639:576];
				a[10] <= inp[703:640];
				a[11] <= inp[767:704];
				a[12] <= inp[831:768];
				a[13] <= inp[895:832];
				a[14] <= inp[959:896];
				a[15] <= inp[1023:960];
			end
			else
			begin
				state <= 7;
			end
		end	
		endcase
		end
		end
endmodule
