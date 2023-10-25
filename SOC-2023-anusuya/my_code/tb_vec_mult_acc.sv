`timescale 1ps/1ps
module tb_vec_mult_acc();
    bit         clk;
    reg         rst;
    parameter num_mat_elements =2;

    reg[63:0] a_real[num_mat_elements-1:0];
    reg[63:0] a_imag[num_mat_elements-1:0];
    reg[63:0] b_real[num_mat_elements-1:0];
    reg[63:0] b_imag[num_mat_elements-1:0];
    
    reg[64*num_mat_elements-1:0] a_real_vec;
    reg[64*num_mat_elements-1:0] a_imag_vec;
    reg[64*num_mat_elements-1:0] b_real_vec;
    reg[64*num_mat_elements-1:0] b_imag_vec;

    reg[63:0] z_real, z_imag;
    reg done,valid,start;
    integer j;

    vec_mult_acc#(.mat_add_gen(num_mat_elements)) my_macc(clk,rst,start,valid, a_real_vec,
    a_imag_vec,b_real_vec,b_imag_vec,z_real,z_imag,done);

    always begin
        #10 clk <= ~clk;
    end

    initial begin
        #1 rst=1;
        #50 rst=0;

        #10 start=0;valid=0;a_real[0] = 64'h4014000000000000; a_imag[0]=64'h4034000000000000;
          b_real[0] = 64'hC014000000000000; b_imag[0] = 64'hC014000000000000; 
          a_real[1] = 64'h4034000000000000; a_imag[1]=64'h4014000000000000;
          b_real[1] = 64'hC014000000000000; b_imag[1] = 64'hC014000000000000; 

        for(j=0;j<num_mat_elements;j++) begin
            a_real_vec[64*j+:64]=a_real[j];
            a_imag_vec[64*j+:64]=a_imag[j];
            b_real_vec[64*j+:64]=b_real[j];
            b_imag_vec[64*j+:64]=b_imag[j];
        end
          
        #10 valid=1;
        #500 start=1; valid=0;
        

        #2000 
        for(j=0;j<num_mat_elements;j++) begin
            $display("(A[%d]   = %f+j%f * B[%d]   = %f+j%f)+", 
        j,$bitstoreal(a_real[j]),$bitstoreal(a_imag[j]),j,
        $bitstoreal(b_real[j]),$bitstoreal(b_imag[j]));
        end

        $display("\n acc_sum=%f+j%f\n",$bitstoreal(z_real),$bitstoreal(z_imag));

        #1000 start=0;valid=0;a_real[0] = 64'h4054000000000000; a_imag[0]=64'h4034000000000000;
          b_real[0] = 64'hC014000000000000; b_imag[0] = 64'hC012000000000000; 
          a_real[1] = 64'h4024000000000000; a_imag[1]=64'h4014000000000000;
          b_real[1] = 64'hC014000000000000; b_imag[1] = 64'hC017000000000000; 

        for(j=0;j<num_mat_elements;j++) begin
            a_real_vec[64*j+:64]=a_real[j];
            a_imag_vec[64*j+:64]=a_imag[j];
            b_real_vec[64*j+:64]=b_real[j];
            b_imag_vec[64*j+:64]=b_imag[j];
        end
          
        #10 valid=1;
        #500 start=1; valid=0;
        

        #2000 
        for(j=0;j<num_mat_elements;j++) begin
            $display("(A[%d]   = %f+j%f * B[%d]   = %f+j%f)+", 
        j,$bitstoreal(a_real[j]),$bitstoreal(a_imag[j]),j,
        $bitstoreal(b_real[j]),$bitstoreal(b_imag[j]));
        end

        $display("\n acc_sum=%f+j%f\n",$bitstoreal(z_real),$bitstoreal(z_imag));

        $stop();

    end

endmodule