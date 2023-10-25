// Code your design here
module matlu2 #(parameter mat_num_row = 2) 
(input[(2*64*mat_num_row*mat_num_row-1):0] inp, 
input clk, input rst, input start, 
output reg [(2*64*mat_num_row*mat_num_row-1):0] L_mat,
output reg [(2*64*mat_num_row*mat_num_row-1):0] U_mat,
output reg done);

  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] X_mat_real; 
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] X_mat_complex;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] X_mat_real_stb; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] X_mat_complex_stb;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] X_mat_real_ack;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] X_mat_complex_ack;

  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] F_mat_real; 
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] F_mat_complex;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] F_mat_real_stb; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] F_mat_complex_stb;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] F_mat_real_ack;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] F_mat_complex_ack;

  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] T_mat_real; 
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] T_mat_complex;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] T_mat_real_stb; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] T_mat_complex_stb;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] T_mat_real_ack; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] T_mat_complex_ack;

  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] L_mat_real; 
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] L_mat_complex;
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] U_mat_real; 
  reg [0:(64*mat_num_row-1)] [0:mat_num_row-1] U_mat_complex;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] L_mat_real_stb; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] L_mat_complex_stb;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] U_mat_real_stb; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] U_mat_complex_stb;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] L_mat_real_ack; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] L_mat_complex_ack;
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] U_mat_real_ack; 
  reg [0:(mat_num_row-1)] [0:mat_num_row-1] U_mat_complex_ack;
  reg [64*mat_num_row*mat_num_row-1:0] a_real;
  reg [64*mat_num_row*mat_num_row-1:0] a_imag;

integer i,j,n_bar,m;
for (i=0;i<mat_num_row;i=i+1) 
begin
	for (j=0;j<mat_num_row;j=j+1) 
	begin
		assign X_mat_real[64*i-1+:64][j] = inp[64*i*j-1+:64];
		assign X_mat_complex [64*i-1+:64][j] = inp[64*(i+mat_num_row)-1*j+:64];
	end
end

assign n_bar=mat_num_row;

for (m=0;m<mat_num_row-1;m=m+1) begin

	genvar k,l;

	// generate
		for (k = 0 ; k < n_bar; k++) 
		begin
			sc_complex_num_divider div1(X_mat_real[k*64-1 +: 64][0],
			X_mat_imag[k*64-1 +: 64][0],
			X_mat_real[0:63][0],
			X_mat_complex[0:63][0],
			X_mat_real_stb[k][0],
			X_mat_imag_stb[k][0],
			X_mat_real_stb[0][0],
			X_mat_imag_stb[0][0],
			L_mat_real_ack[k][0],
			L_mat_imag_ack[k][0],
			clk,
			rst,
			L_mat_real[k*64-1 +: 64][0],
			L_mat_imag[k*64-1 +: 64][0],
			L_mat_real_stb[k][0],
			L_mat_imag_stb[k][0],
			X_mat_real_ack[k][0],
			X_mat_imag_ack[k][0],
			X_mat_real_ack[0][0],
			X_mat_imag_ack[0][0]);

		end

	// for (l=0;l<n_bar;l=l+1) begin
	// 	assign U_mat_real[0][l] = X_mat_real[0][l];
	// 	assign U_mat_imag[0][l] = X_mat_imag[0][l];

	// end
			
	// for (k=0;k<n_bar;k=k+1) begin
	// 	for (l=0;l<n_bar;l=l+1) begin
	// 		double_complex_mult mul1(
	//     	L_mat_real[k*64-1 +: 64][0],
	//     	L_mat_imag[k*64-1 +: 64][0],
	//     	U_mat_real[0:63][l],
	//     	U_mat_imag[0:63][l],
	//     	L_mat_real_stb[k][0],
	//     	L_mat_imag_stb[k][0],
	//     	U_mat_real_stb[0][l],
	//     	U_mat_imag_stb[0][l],
	// 		T_mat_real_ack[k][l],
	// 		T_mat_imag_ack[k][l],
	//         clk,
	//         rst,
	//         T_mat_real[k*64-1 +: 64][l],
	//         T_mat_imag[k*64-1 +: 64][l],
	// 		T_mat_real_stb[k][l],
	// 		T_mat_imag_stb[k][l],
	//     	L_mat_real_ack[k][0],
	//     	L_mat_imag_ack[k][0],
	//     	U_mat_real_ack[0][l],
	//     	U_mat_imag_ack[0][l] );

	// 		double_complexnumber_sub sub1(
	//     	X_mat_real[k*64-1 +:64][l],
	//     	X_mat_imag[k*64-1 +:64][l],
	//     	X_mat_real_stb[k][l],
	//     	X_mat_imag_stb[k][l],
	//     	X_mat_real_ack[k][l],
	//     	X_mat_imag_ack[k][l],
	//         T_mat_real[k*64-1 +: 64][l],
	//         T_mat_imag[k*64-1 +: 64][l],
	// 		T_mat_real_stb[k][l],
	// 		T_mat_imag_stb[k][l],
	// 		T_mat_real_ack[k][l],
	// 		T_mat_imag_ack[k][l],
	//         F_mat_real[k*64-1 +: 64][l],
	//         F_mat_imag[k*64-1 +: 64][l],
	// 		F_mat_real_stb[k][l],
	// 		F_mat_imag_stb[k][l],
	// 		F_mat_real_ack[k][l],
	// 		F_mat_imag_ack[k][l],
	//     	clk,rst);

	// 	end

	// end

	// endgenerate

		for (i=0;i<n_bar-1;i=i+1) begin
			for (j=0;j<n_bar-1;j=j+1) begin
			assign X[i][j]= F[i+1][j+1];
			end
		end

	assign n_bar=n_bar-1;	
end

endmodule

/*
for 

	//localparam n=2;
	reg [63:0] a[0:15];
	reg [2:0] state;
	reg [1:0] cnt;
	// count=2'b00;
	
	reg [63:0] div_in[0:2];
	reg [63:0] pivot;
	reg a_stb_div[0:2]; reg b_stb_div[0:2]; reg c_ack_div[0:2];
	wire [63:0] div_out[0:2];
	wire c_stb_div[0:2]; wire a_ack_div[0:2]; wire b_ack_div[0:2];
	
	reg [63:0] mul_in1[0:2];
	reg [63:0] mul_in2[0:2];
	reg a_stb_mul[0:2]; reg b_stb_mul[0:2]; reg c_ack_mul[0:2];
	wire [63:0] mul_out[0:2];
	wire c_stb_mul[0:2]; wire a_ack_mul[0:2]; wire b_ack_mul[0:2];
	
	reg [63:0] sub_in1[0:2];
	reg [63:0] sub_in2[0:2];
	reg a_stb_sub[0:2]; reg b_stb_sub[0:2]; reg c_ack_sub[0:2];
	wire [63:0] sub_out[0:2];
	wire c_stb_sub[0:2]; wire a_ack_sub[0:2]; wire b_ack_sub[0:2];
	
	// assign ll[0][0] = 1;
	// assign ll[1][1] = 1;
	// assign ll[2][2] = 1;
	
	// reg[63:0] temp_a,temp_b,temp_c,temp_d,temp_e,temp_f,temp_g,temp_h,temp_i;
	
	
	
	/*reg [63:0] div1_in; div2_in; div3_in;
	reg pivot_1,pivot_2,pivot_3;
	reg a_stb_div1,a_stb_div2,a_stb_div3,b_stb_div1,b_stb_div2,b_stb_div3;
	reg c_ack_div1, c_ack_div2, c_ack_div3;
	reg [63:0] div1_out, div2_out, div3_out;
	reg c_stb_div1, c_stb_div2, c_stb_div3, a_ack_div1, a_ack_div2, a_ack_div3, b_ack_div1, b_ack_div2, b_ack_div3;
	
	double_divider div0(
	                      .input_a(div_in[0]),
								 .input_b(pivot),
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
	                      .input_a(div_in[1]),
								 .input_b(pivot),
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
	                      .input_a(div_in[2]),
								 .input_b(pivot),
								 .input_a_stb(a_stb_div[2]),
								 .input_b_stb(b_stb_div[2]),
								 .output_z_ack(c_ack_div[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(div_out[2]),
								 .output_z_stb(c_stb_div[2]),
								 .input_a_ack(a_ack_div[2]),
								 .input_b_ack(b_ack_div[2]));
	
	
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
								 
	
	double_adder sub0(
	                      .input_a(sub_in1[0]),
								 .input_b(sub_in2[0]),
								 .input_a_stb(a_stb_sub[0]),
								 .input_b_stb(b_stb_sub[0]),
								 .output_z_ack(c_ack_sub[0]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[0]),
								 .output_z_stb(c_stb_sub[0]),
								 .input_a_ack(a_ack_sub[0]),
								 .input_b_ack(b_ack_sub[0]));
								 
	double_adder sub1(
	                      .input_a(sub_in1[1]),
								 .input_b(sub_in2[1]),
								 .input_a_stb(a_stb_sub[1]),
								 .input_b_stb(b_stb_sub[1]),
								 .output_z_ack(c_ack_sub[1]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[1]),
								 .output_z_stb(c_stb_sub[1]),
								 .input_a_ack(a_ack_sub[1]),
								 .input_b_ack(b_ack_sub[1]));
								 
	double_adder sub2(
	                      .input_a(sub_in1[2]),
								 .input_b(sub_in2[2]),
								 .input_a_stb(a_stb_sub[2]),
								 .input_b_stb(b_stb_sub[2]),
								 .output_z_ack(c_ack_sub[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[2]),
								 .output_z_stb(c_stb_sub[2]),
								 .input_a_ack(a_ack_sub[2]),
								 .input_b_ack(b_ack_sub[2]));
	
	double_divider div2(
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
								 .input_b_ack(b_ack_div3));
								 
	
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
			done <= 0;
		end
		else
		begin
		case(state)
		
		0: 
		begin
			c_ack_div[0] <= 0;
			c_ack_div[1] <= 0;
			c_ack_div[2] <= 0;
			c_ack_mul[0] <= 0;
			c_ack_mul[1] <= 0;
			c_ack_mul[2] <= 0;
			c_ack_sub[0] <= 0;
			c_ack_sub[1] <= 0;
			c_ack_sub[2] <= 0;
			// if(count==2'b00)
			// 	begin
					// reg [63:0] a[0:15]
			pivot <= a[cnt*4 + cnt];
			div_in[0] <= a[(4*cnt + cnt +4)%16];
			div_in[1] <= a[(4*cnt + cnt +8)%16];
			div_in[2] <= a[(4*cnt + cnt +12)%16];
			a_stb_div[0] <= 1;
			a_stb_div[1] <= 1;
			a_stb_div[2] <= 1;
			b_stb_div[0] <= 1;
			b_stb_div[1] <= 1;
			b_stb_div[2] <= 1;
			
			if({c_stb_div[2],c_stb_div[1],c_stb_div[0]} == 3'b111)
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
				a[(4*cnt + cnt +4)%16] <= div_out[0];
				a[(4*cnt + cnt +8)%16] <= div_out[1];
				a[(4*cnt + cnt +12)%16] <= div_out[2];
			end
			else if(cnt == 1)
			begin
				a[(4*cnt + cnt +4)%16] <= div_out[0];
				a[(4*cnt + cnt +8)%16] <= div_out[1];
			end
			else
			begin
				a[(4*cnt + cnt +4)%16] <= div_out[0];
			end
			a_stb_div[0] <= 0;
			a_stb_div[1] <= 0;
			a_stb_div[2] <= 0;
			b_stb_div[0] <= 0;
			b_stb_div[1] <= 0;
			b_stb_div[2] <= 0;
			c_ack_div[0] <= 1;
			c_ack_div[1] <= 1;
			c_ack_div[2] <= 1;
			state <= 2;
		end

		2: //mult1
		begin
			c_ack_mul[0] <= 0;
			c_ack_mul[1] <= 0;
			c_ack_mul[2] <= 0;
			c_ack_div[0] <= 0;
			c_ack_div[1] <= 0;
			c_ack_div[2] <= 0;
			mul_in1[0] <= a[(4*cnt + cnt +4)%16];
			mul_in1[1] <= a[(4*cnt + cnt +8)%16];
			mul_in1[2] <= a[(4*cnt + cnt +12)%16];
			
			mul_in2[0] <= a[(4*cnt + cnt + mult_cnt + 1)%16];
			mul_in2[1] <= a[(4*cnt + cnt + mult_cnt + 1)%16];
			mul_in2[2] <= a[(4*cnt + cnt + mult_cnt + 1)%16];
			a_stb_mul[0] <= 1;
			a_stb_mul[1] <= 1;
			a_stb_mul[2] <= 1;
			b_stb_mul[0] <= 1;
			b_stb_mul[1] <= 1;
			b_stb_mul[2] <= 1;
			if({c_stb_mul[2],c_stb_mul[1],c_stb_mul[0]} == 3'b111)
			begin
				c_ack_mul[2] <= 1;
				c_ack_mul[1] <= 1;
				c_ack_mul[0] <= 1;
				tmp[mult_cnt] <= {!mul_out[0][63], mul_out[0][62:0]};
				tmp[mult_cnt+3] <= {!mul_out[1][63], mul_out[1][62:0]};
				tmp[mult_cnt+6] <= {!mul_out[2][63], mul_out[2][62:0]};
				state <= 3;
			end		
			else
			begin
				state <= 2;
			end
		end
		
		3: //mult2
		begin
			
			c_ack_mul[2] <= 0;
			c_ack_mul[1] <= 0;
			c_ack_mul[0] <= 0;
			a_stb_mul[0] <= 0;
			a_stb_mul[1] <= 0;
			a_stb_mul[2] <= 0;
			b_stb_mul[0] <= 0;
			b_stb_mul[1] <= 0;
			b_stb_mul[2] <= 0;
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
			c_ack_mul[2] <= 0;
			c_ack_mul[1] <= 0;
			c_ack_mul[0] <= 0;
			c_ack_sub[0] <= 0;
			c_ack_sub[1] <= 0;
			c_ack_sub[2] <= 0;
			sub_in1[0] <= a[(4*cnt + cnt + 5 + sub_cnt)%16];
			sub_in1[1] <= a[(4*cnt + cnt + 9 + sub_cnt)%16];
			sub_in1[2] <= a[(4*cnt + cnt + 13 + sub_cnt)%16];
			
			sub_in2[0] <= tmp[sub_cnt];
			sub_in2[1] <= tmp[sub_cnt+3];
			sub_in2[2] <= tmp[sub_cnt+6];
			a_stb_sub[0] <= 1;
			a_stb_sub[1] <= 1;
			a_stb_sub[2] <= 1;
			b_stb_sub[0] <= 1;
			b_stb_sub[1] <= 1;
			b_stb_sub[2] <= 1;
			if({c_stb_sub[2],c_stb_sub[1],c_stb_sub[0]} == 3'b111)
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
					a[sub_cnt+15] <= sub_out[0];
				end
				c_ack_sub[2] <= 1;
				c_ack_sub[1] <= 1;
				c_ack_sub[0] <= 1;
				state <= 5;
			end		
			else
			begin
				state <= 4;
			end
		end

		5: //sub2
		begin
			a_stb_sub[0] <= 0;
			a_stb_sub[1] <= 0;
			a_stb_sub[2] <= 0;
			b_stb_sub[0] <= 0;
			b_stb_sub[1] <= 0;
			b_stb_sub[2] <= 0;

			c_ack_sub[2] <= 0;
			c_ack_sub[1] <= 0;
			c_ack_sub[0] <= 0;
			// if(cnt == 0)
			// begin
			// 	a[sub_cnt+5] <= sub_out[0];
			// 	a[sub_cnt+9] <= sub_out[1];
			// 	a[sub_cnt+13] <= sub_out[2];
			// end
			// else if(cnt == 1)
			// begin
			// 	if(sub_cnt <= 1)
			// 	begin
			// 		a[sub_cnt+10] <= sub_out[0];
			// 		a[sub_cnt+14] <= sub_out[1];
			// 	end
			// end
			// else if(cnt == 2)
			// begin
			// 	if(sub_cnt <= 0)
			// 	a[sub_cnt+15] <= sub_out[0];
			// end
			// c_ack_sub[2] <= 1;
			// c_ack_sub[1] <= 1;
			// c_ack_sub[0] <= 1;
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
				done <= 1;
				ans <= {a[15],a[14],a[13],a[12],a[11],a[10],a[9],a[8],a[7],a[6],a[5],a[4],a[3],a[2],a[1],a[0]};
			end
			else
			begin
				cnt <= cnt + 1;
				state <= 0;
			end
		end

		7:
		begin
			done <= 0;
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

*/
