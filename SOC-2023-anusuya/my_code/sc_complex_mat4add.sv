// Code your design here
/*


Matrix 4x4 addition


*/
module sc_complex_mat4add
#(parameter mat_num_row = 2)(
    input clk,
    input rst,
    input [(2*64*mat_num_row*mat_num_row-1):0] mat_a,
    input [(2*64*mat_num_row*mat_num_row-1):0] mat_b,
    input start,
    input valid,
    output reg [(2*64*mat_num_row*mat_num_row-1):0] mat_out,
    output reg done,
    input reg output_read
);


reg [64*mat_num_row*mat_num_row-1:0] c_real;
reg [64*mat_num_row*mat_num_row-1:0] c_imag;
reg [64*mat_num_row*mat_num_row-1:0] a_real;
reg [64*mat_num_row*mat_num_row-1:0] a_imag;
reg [64*mat_num_row*mat_num_row-1:0] b_real;
reg [64*mat_num_row*mat_num_row-1:0] b_imag;


reg done_real;
reg done_imag;

reg done_sync1;
reg done_sync2;

mat4add #(.mat_add_gen(mat_num_row*mat_num_row)) real_adder(clk,rst, a_real, b_real, start,valid,c_real, done_real,output_read);
mat4add #(.mat_add_gen(mat_num_row*mat_num_row)) imag_adder(clk,rst, a_imag, b_imag, start,valid,c_imag, done_imag,output_read);


assign mat_out[2*64*mat_num_row*mat_num_row-1:64*mat_num_row*mat_num_row] = c_imag;
assign mat_out[64*mat_num_row*mat_num_row-1:0] = c_real;

assign done = {done_real & done_imag};

assign a_imag = mat_a[2*64*mat_num_row*mat_num_row-1:64*mat_num_row*mat_num_row];
assign a_real = mat_a[64*mat_num_row*mat_num_row-1:0];
assign b_imag = mat_b[2*64*mat_num_row*mat_num_row-1:64*mat_num_row*mat_num_row];
assign b_real = mat_b[64*mat_num_row*mat_num_row-1:0];


endmodule