module matrix_add_8(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, out);
 input [15:0] a1;
 input [15:0] a2;
 input [15:0] a3;
 input [15:0] a4;
 input [15:0] a5;
 input [15:0] a6;
 input [15:0] a7;
 input [15:0] a8;
 input [15:0] a9;
 input [15:0] a10;
 input [15:0] a11;
 input [15:0] a12;
 input [15:0] a13;
 input [15:0] a14;
 input [15:0] a15;
 input [15:0] a16;
 output [63:0] out;

 assign out[63:48] = a1 + a2;
 assign out[47:32] = a3 + a4;
 assign out[31:16] = a5 + a6;
 assign out[15:0] = a7 + a8; 
endmodule
