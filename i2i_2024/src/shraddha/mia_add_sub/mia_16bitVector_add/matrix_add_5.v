module matrix_add_5(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, out);
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
 output [79:0] out;

 assign out[79:64] = a1 + a2;
 assign out[63:48] = a3 + a4;
 assign out[47:32] = a5 + a6;
 assign out[31:16] = a7 + a8; 
 assign out[15:0] =  a9 + a10;
endmodule
