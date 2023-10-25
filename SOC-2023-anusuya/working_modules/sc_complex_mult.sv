`timescale 1ps/1ps
module double_complex_mult(
        input_a_real,
        input_a_imag,
        input_b_real,
        input_b_imag,
        input_a_real_stb,
        input_a_imag_stb,
        input_b_real_stb,
        input_b_imag_stb,
        output_z_real_ack,
        output_z_imag_ack,
        clk,
        rst,
        output_z_real,
        output_z_imag,
        output_z_real_stb,
        output_z_imag_stb,
        input_a_real_ack,
        input_a_imag_ack,
        input_b_real_ack,
        input_b_imag_ack,    
);
// real_product_1_stb,        real_product_2_stb, imag_product_1_stb,
        // imag_product_2_stb,
    input clk, rst;
    input [63:0]  input_a_real;
    input         input_a_real_stb;
    
    input [63:0]  input_a_imag;
    input         input_a_imag_stb;
    
    input [63:0]  input_b_real;
    input        input_b_real_stb;
    
    input [63:0]  input_b_imag;
    input         input_b_imag_stb;

    input         output_z_real_ack;
    output [63:0] output_z_real;
    output       output_z_real_stb;
    
    input        output_z_imag_ack;
    output [63:0] output_z_imag;
    output        output_z_imag_stb;
    
    output        input_a_real_ack;
    output        input_a_imag_ack;
    
    output       input_b_real_ack;
    output        input_b_imag_ack;

    // input reg real_product_1_stbA;  //input_a_real*input_b_real stb
    // input reg real_product_2_stbA;  //input_a_imag*input_b_imag stb
    // input reg imag_product_1_stbA;  //input_a_real*input_b_imag stb
    // input reg imag_product_2_stbA;  //input_a_imag*input_b_real stb

    // output reg real_product_1_stb;  //input_a_real*input_b_real stb
    // output reg real_product_2_stb;  //input_a_imag*input_b_imag stb
    // output reg imag_product_1_stb;  //input_a_real*input_b_imag stb
    // output reg imag_product_2_stb;  //input_a_imag*input_b_real stb

    
    // input real_product_1_ack;  //input_a_real*input_b_real ack
    // input real_product_2_ack;  //input_a_imag*input_b_imag ack
    // input imag_product_1_ack;  //input_a_real*input_b_imag ack
    // input imag_product_2_ack;  //input_a_imag*input_b_real ack

    reg real_product_1_ackA;  //input_a_real*input_b_real ack
    reg real_product_2_ackA;  //input_a_imag*input_b_imag ack
    reg imag_product_1_ackA;  //input_a_real*input_b_imag ack
    reg imag_product_2_ackA;  //input_a_imag*input_b_real ack

    reg [63:0] real_product_1;  //input_a_real*input_b_real
    reg [63:0] real_product_2;  //input_a_imag*input_b_imag
    reg [63:0] imag_product_1;  //input_a_real*input_b_imag
    reg [63:0] imag_product_2;  //input_a_imag*input_b_real

    reg real_product_1_ack;  //input_a_real*input_b_real ack
    reg real_product_2_ack;  //input_a_imag*input_b_imag ack
    reg imag_product_1_ack;  //input_a_real*input_b_imag ack
    reg imag_product_2_ack;  //input_a_imag*input_b_real ack

    reg real_product_1_stb;  //input_a_real*input_b_real stb
    reg real_product_2_stb;  //input_a_imag*input_b_imag stb
    reg imag_product_1_stb;  //input_a_real*input_b_imag stb
    reg imag_product_2_stb;  //input_a_imag*input_b_real stb
    
    assign real_product_1_ack=real_product_1_ackA;
    assign real_product_2_ack=real_product_2_ackA;
    assign imag_product_1_ack=imag_product_1_ackA;
    assign imag_product_2_ack=imag_product_2_ackA;
    
//Using double_multiplier to get intermediate products
    double_multiplier real_mul_1(input_a_real,input_b_real,
    input_a_real_stb,input_b_real_stb,real_product_1_ack,clk,
    rst,real_product_1,real_product_1_stb,input_a_real_ack,
    input_b_real_ack);
    double_multiplier real_mul_2(input_a_imag,input_b_imag,
    input_a_imag_stb,input_b_imag_stb,real_product_2_ack,
    clk,rst,real_product_2,real_product_2_stb,input_a_imag_ack,
    input_b_imag_ack);
    double_multiplier imag_mul_1(input_a_real,input_b_imag,
    input_a_real_stb,input_b_imag_stb,imag_product_1_ack,
    clk,rst,imag_product_1,imag_product_1_stb,input_a_real_ack,
    input_b_imag_ack);
    double_multiplier imag_mul_2(input_a_imag,input_b_real,
    input_a_imag_stb,input_b_real_stb,imag_product_2_ack,
    clk,rst,imag_product_2,imag_product_2_stb,input_a_imag_ack,
    input_b_real_ack);

//Using double_adder to get final product values
    sub real_adder(real_product_1,real_product_2,
    real_product_1_stb,real_product_2_stb,
    output_z_real_ack,clk,rst,output_z_real,
    output_z_real_stb,real_product_1_ackA,
    real_product_2_ackA);
    double_adder imag_adder(imag_product_1,imag_product_2,
    imag_product_1_stb,imag_product_2_stb,output_z_imag_ack,clk,rst,
    output_z_imag,output_z_imag_stb,imag_product_1_ackA,imag_product_2_ackA);

endmodule