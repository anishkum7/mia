`timescale 1ps/1ps
module complex_mult_tb();
    bit         clk;
    reg         rst;
    
    reg [63:0]  input_a_real;
    reg         input_a_real_stb;
    
    reg [63:0]  input_a_imag;
    reg         input_a_imag_stb;
    
    reg [63:0]  input_b_real;
    reg         input_b_real_stb;
    
    reg [63:0]  input_b_imag;
    reg         input_b_imag_stb;

    reg         output_z_real_ack;
    reg [63:0] output_z_real;
    wire        output_z_real_stb;
    
    reg         output_z_imag_ack;
    reg [63:0] output_z_imag;
    wire        output_z_imag_stb;
    
    wire        input_a_real_ack;
    wire        input_a_imag_ack;
    
    wire        input_b_real_ack;
    wire        input_b_imag_ack;

    reg        real_product_1_ackA;
    reg        real_product_2_ackA;
    reg        imag_product_1_ackA;
    reg        imag_product_2_ackA;

    reg        real_product_1_stb;
    reg        real_product_2_stb;
    reg        real_product_1_ack;
    reg        real_product_2_ack;
    reg        imag_product_1_stb;
    reg        imag_product_2_stb;
    reg        imag_product_1_ack;
    reg        imag_product_2_ack;

    reg        real_product_1_stbA;
    reg        real_product_2_stbA;
    reg        imag_product_1_stbA;
    reg        imag_product_2_stbA;

    reg [63:0] real_product_1;  //input_a_real*input_b_real
    reg [63:0] real_product_2;  //input_a_imag*input_b_imag
    reg [63:0] imag_product_1;  //input_a_real*input_b_imag
    reg [63:0] imag_product_2;  //input_a_imag*input_b_real

    //double_adder adder_real(input_a_real, input_b_real, input_a_real_stb, input_b_real_stb, output_z_real_ack, clk, rst, output_z_real, output_z_real_stb, input_a_real_ack, input_b_real_ack);
    //double_adder adder_imag(input_a_imag, input_b_imag, input_a_imag_stb, input_b_imag_stb, output_z_imag_ack, clk, rst, output_z_imag, output_z_imag_stb, input_a_imag_ack, input_b_imag_ack);

    // double_complex_mult_sim uut(input_a_real,
    //     input_a_imag,
    //     input_b_real,
    //     input_b_imag,
    //     input_a_real_stb,
    //     input_a_imag_stb,
    //     input_b_real_stb,
    //     input_b_imag_stb,
    //     output_z_real_ack,
    //     output_z_imag_ack,
    //     clk,
    //     rst,
    //     output_z_real,
    //     output_z_imag,
    //     output_z_real_stb,
    //     output_z_imag_stb,
    //     input_a_real_ack,
    //     input_a_imag_ack,
    //     input_b_real_ack,
    //     input_b_imag_ack,
    //     real_product_1_ack,
    //     real_product_2_ack,
    //     imag_product_1_ack,
    //     imag_product_2_ack,
    //     real_product_1_ackA,
    //     real_product_2_ackA,
    //     imag_product_1_ackA,
    //     imag_product_2_ackA,
    //     real_product_1,
    //     real_product_2,
    //     imag_product_1,
    //     imag_product_2,
    //     real_product_1_stb,
    //     real_product_2_stb,
    //     imag_product_1_stb,
    //     imag_product_2_stb,
    //     real_product_1_stbA,
    //     real_product_2_stbA,
    //     imag_product_1_stbA,
    //     imag_product_2_stbA
    // );
    
    // assign real_product_1_stbA = real_product_1_stb;
    // assign real_product_2_stbA = real_product_2_stb;
    // assign imag_product_1_stbA = imag_product_1_stb;
    // assign imag_product_2_stbA = imag_product_2_stb;

    double_complex_mult uut(input_a_real,
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

    always begin
        #10 clk <= ~clk;
    end

    initial begin
        #1 rst = 1;
        #20 rst = 0; 

        // #10 input_a_real = 64'hC024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h4024000000000000;input_b_imag = 64'h4024000000000000; 
        // #10 input_a_real = 64'h4014000000000000; input_a_imag = 64'h401C000000000000; input_b_real = 64'h4008000000000000;input_b_imag = 64'h4000000000000000;  // (5+7j) * (3+2j) = (1+31j)
        // #10 input_a_real = 64'h4014000000000000; input_a_imag = 64'h401C000000000000; input_b_real = 64'hC008000000000000;input_b_imag = 64'h4000000000000000;  // (5+7j) * (-3+2j) = (1+31j)
        // #10 input_a_real = 64'hC034000000000000; input_a_imag = 64'h4034000000000000; input_b_real = 64'h4034000000000000;
        // input_b_imag = 64'h4034000000000000;  // (-20+20j) * (-20+20j) = -800

        // #10 input_a_real = 64'hC014000000000000; input_a_imag = 64'h401C000000000000; 
        // input_b_real = 64'h4008000000000000;input_b_imag = 64'h4000000000000000;  // (-5+7j) * (3+2j) = (1+31j)
        // #10 input_a_real = 64'hC014000000000000; input_a_imag = 64'h4034000000000000; input_b_real = 64'h4034000000000000;
        // input_b_imag = 64'h4034000000000000;  // (-20+20j) * (-20+20j) = -800
        // #10 input_a_real = 64'h4024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'hC024000000000000;input_b_imag = 64'h4024000000000000; //(10+10j)*(10+10j)
        // #10 input_a_real = 64'h4024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h3FF0000000000000;input_b_imag = 64'h3FF0000000000000; //(10+10j)*(1+1j) = 20j
        // #10 input_a_real = 64'h4024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h4008000000000000;input_b_imag = 64'h4008000000000000; //(10+10j)*(3+3j) = 60j
        // #10 input_a_real = 64'h4024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h4010000000000000;input_b_imag = 64'h4010000000000000; //(10+10j)*(4+4j) = 80j
        #10 input_a_real = 64'h4014000000000000; input_a_imag = 64'hC014000000000000; 
        input_b_real = 64'h4014000000000000;input_b_imag = 64'h4014000000000000; //(10+10j)*(4+4j) = 80j
        input_a_real_stb = 1;  input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 
        #500 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        // #100 real_product_1_ack =1; real_product_2_ack=1; imag_product_1_ack=1;imag_product_2_ack=1;
        // #500 real_product_1_stbA=1; real_product_2_stbA=1; imag_product_1_stbA=1; imag_product_2_stbA=1;
        // #300 real_product_1_stbA=0; real_product_2_stbA=0; imag_product_1_stbA=0; imag_product_2_stbA=0;
        #300 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Product = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),$bitstoreal(input_b_real),$bitstoreal(input_b_imag),$bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        // $display("\n real_product_1   = %f\n real_product_2   = %f\n imag_product_1 = %f\n imag_product_2 = %f\n", 
        // $bitstoreal(real_product_1),$bitstoreal(real_product_2),
        // $bitstoreal(imag_product_1),$bitstoreal(imag_product_2));

        // #100 rst = 1;
        // #20 rst = 0; 
        
        #10 input_a_real = 64'hC014000000000000; input_a_imag = 64'hC014000000000000; 
        input_b_real = 64'h4014000000000000;input_b_imag = 64'h4014000000000000; //(10+10j)*(4+4j) = 80j
        input_a_real_stb = 1;  input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 
        #500 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        // #100 real_product_1_ack =1; real_product_2_ack=1; imag_product_1_ack=1;imag_product_2_ack=1;
        #300 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Product = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),
        $bitstoreal(input_b_real),$bitstoreal(input_b_imag),
        $bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        // $display("real_product_1   = %f\n real_product_2   = %f\n
        //  imag_product_1 = %f\n imag_product_2 = %f\n", 
        // $bitstoreal(real_product_1),$bitstoreal(real_product_2),
        // $bitstoreal(imag_product_1),$bitstoreal(imag_product_2));

        // #100 rst = 1;
        // #20 rst = 0; 
        
        #10  input_a_real = 64'h4014000000000000; input_a_imag = 64'hC014000000000000; 
        input_b_real = 64'h4014000000000000;input_b_imag = 64'h4014000000000000; //(10+10j)*(4+4j) = 80j
        input_a_real_stb = 1;  input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 
        #500 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        // #100 real_product_1_ack =1; real_product_2_ack=1; imag_product_1_ack=1;imag_product_2_ack=1;
        #300 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Product = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),
        $bitstoreal(input_b_real),$bitstoreal(input_b_imag),
        $bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        // $display("\n real_product_1   = %f\n real_product_2   = %f\n imag_product_1 = %f\n imag_product_2 = %f\n", 
        // $bitstoreal(real_product_1),$bitstoreal(real_product_2),
        // $bitstoreal(imag_product_1),$bitstoreal(imag_product_2));

        // #100 rst = 1;
        // #20 rst = 0; 
        
        #10  input_a_real = 64'h4014000000000000; input_a_imag = 64'h4014000000000000; 
        input_b_real = 64'h4014000000000000;input_b_imag = 64'h4014000000000000; //(10+10j)*(4+4j) = 80j
        input_a_real_stb = 1;  input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 
        #500 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        // #100 real_product_1_ack =1; real_product_2_ack=1; imag_product_1_ack=1;imag_product_2_ack=1;
        #300 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Product = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),$bitstoreal(input_b_real),$bitstoreal(input_b_imag),$bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        // $display("\n real_product_1   = %f\n real_product_2   = %f\n imag_product_1 = %f\n imag_product_2 = %f\n", 
        // $bitstoreal(real_product_1),$bitstoreal(real_product_2),
        // $bitstoreal(imag_product_1),$bitstoreal(imag_product_2));
        #1000 $stop();
    end
endmodule