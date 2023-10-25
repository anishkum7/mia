`timescale 1ns/1ps
module fpu_adder_tb;
    reg         clk;
    reg         rst;
    reg [31:0]  input_a;
    reg         input_a_stb;
    reg [31:0]  input_b;
    reg         input_b_stb;
    reg         output_z_ack;
    wire [31:0] output_z;
    wire        output_z_stb;
    wire        input_a_ack;
    wire        input_b_ack;

    adder adder_inst(input_a, input_b, input_a_stb, input_b_stb, output_z_ack, clk, rst, output_z, output_z_stb, input_a_ack, input_b_ack);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; rst = 1;
        #20 rst = 0; 
        //4.2,10.5 OP should be 14.7
        #10 input_a = 32'h40866666; input_a_stb = 1; 
        input_b = 32'h41280000; input_b_stb = 1;
        #30 input_a_stb = 0; input_b_stb = 0;
        #150 output_z_ack = 1; 
        //See OP is 32'h416B3333
        //17.775, 39.2223 OP should be 56.9973
        #30 input_a = 32'h418e3333; input_a_stb = 1; output_z_ack = 0;
        input_b = 32'h421ce3a3; input_b_stb = 1;
        #30 input_a_stb = 0; input_b_stb = 0;
        //See OP is 32'h4263FD3C
        $display("\n input_a = %0h input_b = %0h", input_a,input_b);
        #300 $finish();
    end
endmodule
