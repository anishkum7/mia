`timescale 1ps/1ps
module tb_mat_add_complex();
    bit         clk;
    reg         rst;
    parameter mat_num_row =2;
    reg [2*64*mat_num_row*mat_num_row-1:0] mat_a;
    reg [2*64*mat_num_row*mat_num_row-1:0] mat_b;
    reg [2*64*mat_num_row*mat_num_row-1:0] mat_out;
    reg start,done;

    // reg[63:0] a_real[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] a_imag[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] b_real[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] b_imag[mat_num_row-1:0][mat_num_row-1:0];
    integer i,j;
    real a_real,a_imag,b_real,b_imag;
    
    

    mat4add_complex#(mat_num_row) uut(
        clk,rst,
        mat_a, mat_b, start, mat_out, done);

    always begin
        #10 clk <= ~clk;
    end
    initial begin 
        #1 rst=1; start=0;
        #5 rst=0;
        // computation1
        #10 start=1;
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                a_real = $random%10;
                mat_a[64*(i*mat_num_row+j) +: 64]=$realtobits(a_real);
                a_imag = $random%10;
                mat_a[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]=$realtobits(a_imag);
                b_real = $random%10;
                mat_b[64*(i*mat_num_row+j) +: 64]=$realtobits(b_real);
                b_imag = $random%10;
                mat_b[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]=$realtobits(b_imag);
            end
        end

        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("A[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_a[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_a[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end
        
        #10
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("B[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_b[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_b[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end

        #10
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("Out[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_out[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_out[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end

        // computation2
        #10 start=0;
	#10 start=1;
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                a_real = $random%10;
                mat_a[64*(i*mat_num_row+j) +: 64]=$realtobits(a_real);
                a_imag = $random%10;
                mat_a[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]=$realtobits(a_imag);
                b_real = $random%10;
                mat_b[64*(i*mat_num_row+j) +: 64]=$realtobits(b_real);
                b_imag = $random%10;
                mat_b[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]=$realtobits(b_imag);
            end
        end

        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("A[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_a[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_a[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end
        
        #10
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("B[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_b[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_b[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end

        #10
        for(i=0;i<mat_num_row;i=i+1) begin
            for(j=0;j<mat_num_row;j=j+1) begin
                $display("Out[%d,%d]   = %f+j%f\n",i, j,
                $bitstoreal(mat_out[64*(i*mat_num_row+j) +: 64]),
                $bitstoreal(mat_out[64*(i*mat_num_row+j)+(64*mat_num_row*mat_num_row)+:64]));
            end
        end

        #1000$stop();
    end

endmodule
