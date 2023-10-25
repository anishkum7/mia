`timescale 1ps/1ps
module tb_subtractor();
    bit         clk;
    reg         rst;
    
    reg [63:0]  input_a;
    reg         input_a_stb;
    reg [63:0]  input_b;
    reg         input_b_stb;
    reg         output_z_ack;
    reg [63:0] output_z;
    reg        output_z_stb;

    reg        input_a_ack;
    
    reg        input_b_ack;

    //double_adder adder_real(input_a_real, input_b_real, input_a_real_stb, input_b_real_stb, output_z_real_ack, clk, rst, output_z_real, output_z_real_stb, input_a_real_ack, input_b_real_ack);
    //double_adder adder_imag(input_a_imag, input_b_imag, input_a_imag_stb, input_b_imag_stb, output_z_imag_ack, clk, rst, output_z_imag, output_z_imag_stb, input_a_imag_ack, input_b_imag_ack);

   sub real_adder(input_a,input_b,
    input_a_stb,input_b_stb,
    output_z_ack,clk,rst,output_z,
    output_z_stb,input_a_ack,
    input_b_ack);

always begin
        #5 clk <= ~clk;
    end

    initial begin
        #1 clk = 1; 
        #10 rst = 1;
        #20 rst = 0;
        // #10 input_a =64'h4014000000000000; input_b =64'h4014000000000000; 
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #100 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));

        // #100 rst = 1;
        // #20 rst = 0;
        // #10 input_a =64'hC014000000000000; input_b =64'hC014000000000000;
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #100 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));

        // #100 rst = 1;
        // #20 rst = 0;
        // #10 input_a =64'h4014000000000000; input_b =64'hC014000000000000;
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #100 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));

        // #100 rst = 1;
        // #20 rst = 0;
        // #10 input_a =64'hC014000000000000; input_b =64'h4014000000000000;
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #100 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));

        //64'hC008000000000000 = -3
        // 64'h4008000000000000 = 3
        // 64'h4014000000000000 = 5
        // 64'hC014000000000000 = -5
        // #100 rst = 1;
        // #20 rst = 0;
        #10 input_a =64'hC014000000000000; input_b=64'h4014000000000000; // 5-(-3)
        input_a_stb = 1;input_b_stb = 1; 
        #30 input_a_stb = 0; input_b_stb = 0; 
        #150 output_z_ack = 1; //output_z_imag_ack =1;

        $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
         $display("A   = %h \n B   = %h \n Diff = %h\n", 
        (input_a),(input_b),(output_z));
        #100 rst = 1;
        #20 rst = 0;
        #10 input_a =64'hC008000000000000; input_b=64'h4014000000000000; // -3-5
        input_a_stb = 1;input_b_stb = 1; 
        #30 input_a_stb = 0; input_b_stb = 0; 
        #150 output_z_ack = 1; //output_z_imag_ack =1
        $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
        $display("A   = %h \n B   = %h \n Diff = %h\n", 
        (input_a),(input_b),(output_z));
        #100 rst = 1;
        #20 rst = 0;
        #10 input_a =64'hC014000000000000; input_b=64'hC014000000000000; // 5-(-3)
        input_a_stb = 1;input_b_stb = 1; 
        #30 input_a_stb = 0; input_b_stb = 0; 
        #150 output_z_ack = 1; //output_z_imag_ack =1;

        $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
         $display("A   = %h \n B   = %h \n Diff = %h\n", 
        (input_a),(input_b),(output_z));

        #100 rst = 1;
        #20 rst = 0;
        #10 input_a =64'h4014000000000000; input_b=64'h4014000000000000; // 5-(-3)
        input_a_stb = 1;input_b_stb = 1; 
        #30 input_a_stb = 0; input_b_stb = 0; 
        #150 output_z_ack = 1; //output_z_imag_ack =1;

        $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
         $display("A   = %h \n B   = %h \n Diff = %h\n", 
        (input_a),(input_b),(output_z));

        #100 rst = 1;
        #20 rst = 0;
        #10 input_a =64'h4014000000000000; input_b=64'hC014000000000000; // 5-(-3)
        input_a_stb = 1;input_b_stb = 1; 
        #30 input_a_stb = 0; input_b_stb = 0; 
        #150 output_z_ack = 1; //output_z_imag_ack =1;

        $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
         $display("A   = %h \n B   = %h \n Diff = %h\n", 
        (input_a),(input_b),(output_z));
        // #100 rst = 1;
        // #20 rst = 0;
        // #10 input_a =64'h4008000000000000; input_b=64'h4014000000000000; // 3-5
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #150 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));

        // #100 rst = 1;
        // #20 rst = 0;
        // #10 input_a =64'h4039000000000000; input_b=64'hC039000000000000; // 25-(-25)
        // input_a_stb = 1;input_b_stb = 1; 
        // #30 input_a_stb = 0; input_b_stb = 0; 
        // #300 output_z_ack = 1; //output_z_imag_ack =1;

        // $display("\n A   = %f \n B   = %f \n Diff = %f\n", 
        // $bitstoreal(input_a),$bitstoreal(input_b),$bitstoreal(output_z));
        
        #300 $stop();
    end
endmodule