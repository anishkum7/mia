`timescale 1ps/1ps
module tb_complex_dvider();
    bit         clk;
    reg         rst;
    
    reg [63:0]  input_a_real;
    reg         input_a_real_stb;
    reg         input_a_real_ack;
    
    reg [63:0]  input_a_imag;
    reg         input_a_imag_stb;
    reg         input_a_imag_ack;
    
    reg [63:0]  input_b_real;
    reg         input_b_real_stb;
    reg         input_b_real_ack;
    
    reg [63:0]  input_b_imag;
    reg         input_b_imag_stb;
    reg         input_b_imag_ack;

    reg         output_z_real_ack;
    reg [63:0] output_z_real;
    wire        output_z_real_stb;
    
    reg         output_z_imag_ack;
    reg [63:0] output_z_imag;
    wire        output_z_imag_stb;

    real a_real, a_imag, b_real, b_imag;

    sc_complex_num_divider uut(input_a_real,
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
                                input_b_imag_ack);

    always begin
        #10 clk <= ~clk;
    end

    initial begin
        #1 rst = 1;
        #20 rst = 0; 

        #10 
        a_real = 8; input_a_real = $realtobits(a_real); 
        a_imag = 0; input_a_imag = $realtobits(a_imag); 
        b_real = -9; input_b_real = $realtobits(b_real); 
        b_imag = 1; input_b_imag = $realtobits(b_imag); 
        input_a_real_stb = 1;  input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 

        #500 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        #5000 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Quotient = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),
        $bitstoreal(input_b_real),$bitstoreal(input_b_imag),
        $bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        #1000 $stop();

    end
endmodule