module sc_complex_num_divider(input_a_real,
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
    // number1 = a+b*i
    // number2 = c+d*i
    // number1/number2 real part = (ac+bd)/ (c_sqrd + d_sqrd) 
    // number1/number2 imag part = (bc-ad)/ (c_sqrd + d_sqrd) 


    reg[63:0] conjugated_b_imag;
    reg [63:0] c_sqrd; //c*c
    reg [63:0] d_sqrd; // d*d
    reg [63:0] sqrd_terms_summed; // c*c + d*d 
    reg [63:0] conjugate_prod_real;
    reg [63:0] conjugate_prod_imag;

    reg c_sqrd_ackA;  //input_a_real*input_b_real ack
    reg d_sqrd_ackA;  //input_a_imag*input_b_imag ack
    reg c_sqrd_ackM;  //input_a_real*input_b_real ack
    reg d_sqrd_ackM;  //input_a_imag*input_b_imag ack
    reg c_sqrd_stb;  //input_a_real*input_b_real ack
    reg d_sqrd_stb;  //input_a_imag*input_b_imag ack
    reg sqrd_terms_summed_ackA;
    reg sqrd_terms_summed_ackD;
    reg sqrd_terms_summed_stb;

    reg conjugate_prod_imag_ackP;
    reg conjugate_prod_imag_ackD;
    reg conjugate_prod_imag_stb;
    reg conjugate_prod_real_ackP;
    reg conjugate_prod_real_ackD;
    reg conjugate_prod_real_stb;

    assign conjugated_b_imag = {~input_b_imag[63], input_b_imag[62:0]};
    assign c_sqrd_ackM = c_sqrd_ackA;
    assign d_sqrd_ackM = d_sqrd_ackA;
    assign conjugate_prod_imag_ackP = conjugate_prod_imag_ackD;
    assign conjugate_prod_real_ackP = conjugate_prod_real_ackD;
    assign sqrd_terms_summed_ackA = sqrd_terms_summed_ackD;

    double_complex_mult conjugate_product(input_a_real,
                                            input_a_imag,
                                            input_b_real,
                                            conjugated_b_imag,
                                            input_a_real_stb,
                                            input_a_imag_stb,
                                            input_b_real_stb,
                                            input_b_imag_stb,
                                            conjugate_prod_real_ackP,
                                            conjugate_prod_imag_ackP,
                                            clk,
                                            rst,
                                            conjugate_prod_real,
                                            conjugate_prod_imag,
                                            conjugate_prod_real_stb,
                                            conjugate_prod_imag_stb,
                                            input_a_real_ack,
                                            input_a_imag_ack,
                                            input_b_real_ack,
                                            input_b_imag_ack);
    
    double_multiplier c_sqrd_term(input_b_real,
                                input_b_real,
                                input_b_real_stb,
                                input_b_real_stb,
                                c_sqrd_ackM,
                                clk,
                                rst,
                                c_sqrd,
                                c_sqrd_stb,
                                input_b_real_ack,
                                input_b_real_ack);

    double_multiplier d_sqrd_term(input_b_imag,
                                    input_b_imag,
                                    input_b_imag_stb,
                                    input_b_imag_stb,
                                    d_sqrd_ackM,
                                    clk,
                                    rst,
                                    d_sqrd,
                                    d_sqrd_stb,
                                    input_b_imag_ack,
                                    input_b_imag_ack);
    
    double_adder  sum_sqrd_terms(c_sqrd,
                                d_sqrd,
                                c_sqrd_stb,
                                d_sqrd_stb,
                                sqrd_terms_summed_ackA,
                                clk,
                                rst,
                                sqrd_terms_summed,
                                sqrd_terms_summed_stb,
                                c_sqrd_ackA,
                                d_sqrd_ackA);

    sc_double_divider divider_real(conjugate_prod_real,
                                    sqrd_terms_summed,
                                    conjugate_prod_real_stb,
                                    sqrd_terms_summed_stb,
                                    output_z_real_ack,
                                    clk,
                                    rst,
                                    output_z_real,
                                    output_z_real_stb,
                                    conjugate_prod_real_ackD,
                                    sqrd_terms_summed_ackD);
    
    sc_double_divider divider_imag(conjugate_prod_imag,
                                    sqrd_terms_summed,
                                    conjugate_prod_imag_stb,
                                    sqrd_terms_summed_stb,
                                    output_z_imag_ack,
                                    clk,
                                    rst,
                                    output_z_imag,
                                    output_z_imag_stb,
                                    conjugate_prod_imag_ackD,
                                    sqrd_terms_summed_ackD);

endmodule