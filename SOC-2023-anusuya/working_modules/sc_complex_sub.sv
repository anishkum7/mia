module double_complexnumber_sub(
    input_a_real,input_a_imag,input_a_real_stb,input_a_imag_stb, input_a_real_ack, input_a_imag_ack,
    input_b_real,input_b_imag,input_b_real_stb,input_b_imag_stb, input_b_real_ack, input_b_imag_ack,
    output_z_real,output_z_imag,output_z_real_stb,output_z_imag_stb,output_z_real_ack,output_z_imag_ack,
    clk,rst);

    input reg clk, rst;
    input reg [63:0]  input_a_real;
    input reg         input_a_real_stb;
    
    input reg [63:0]  input_a_imag;
    input reg         input_a_imag_stb;
    
    input reg [63:0]  input_b_real;
    input reg         input_b_real_stb;
    
    input reg [63:0]  input_b_imag;
    input reg         input_b_imag_stb;

    input reg         output_z_real_ack;
    output reg [63:0] output_z_real;
    output reg        output_z_real_stb;
    
    input reg         output_z_imag_ack;
    output reg [63:0] output_z_imag;
    output reg        output_z_imag_stb;
    
    output reg        input_a_real_ack;
    output reg        input_a_imag_ack;
    
    output reg        input_b_real_ack;
    output reg        input_b_imag_ack;

    sub sub_real(input_a_real, input_b_real, input_a_real_stb, input_b_real_stb, output_z_real_ack, clk, rst, output_z_real, output_z_real_stb, input_a_real_ack, input_b_real_ack);
    sub sub_imag(input_a_imag, input_b_imag, input_a_imag_stb, input_b_imag_stb, output_z_imag_ack, clk, rst, output_z_imag, output_z_imag_stb, input_a_imag_ack, input_b_imag_ack);

    endmodule