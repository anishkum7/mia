module matrix_add_16(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31, a32, out);
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
 input [15:0] a17;
 input [15:0] a18;
 input [15:0] a19; 
 input [15:0] a20;
 input [15:0] a21;
 input [15:0] a22;
 input [15:0] a23;
 input [15:0] a24;
 input [15:0] a25;
 input [15:0] a26;
 input [15:0] a27;
 input [15:0] a28;
 input [15:0] a29;
 input [15:0] a30;
 input [15:0] a31;
 input [15:0] a32;

 output [255:0] out;

 assign out[255:240]  = a1 - a2;
 assign out[239:224]  = a3 - a4;
 assign out[223:208]  = a5 - a6;
 assign out[207:192]  = a7 - a8; 
 assign out[191:176]  = a9 - a10;
 assign out[175:160]  = a11 - a12;
 assign out[159:144]  = a13 - a14;
 assign out[143:128]  = a15 - a16; 
 assign out[127:112]  = a17 - a18;
 assign out[111:96]   = a19 - a20;
 assign out[95:80]    = a21 - a22;
 assign out[79:64]    = a23 - a24; 
 assign out[63:48]    = a25 - a26;
 assign out[47:32]    = a27 - a28;
 assign out[31:16]    = a29 - a30;
 assign out[15:0]     = a31 - a32;

 
endmodule
