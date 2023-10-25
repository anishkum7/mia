`timescale 1ps/1ps
module tb_mat_mult_complex_uneven();
    bit         clk;
    reg         rst;
    parameter out_row=2;
    parameter out_col=3;
    parameter common_factor=2;

    reg [2*64*out_row*common_factor-1:0] mat_a;
    reg [2*64*common_factor*out_col-1:0] mat_b;
    reg [2*64*out_row*out_col-1:0] mat_out;
    reg start,valid,done;

    // reg[63:0] a_real[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] a_imag[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] b_real[mat_num_row-1:0][mat_num_row-1:0];
    // reg[63:0] b_imag[mat_num_row-1:0][mat_num_row-1:0];
    integer i,j;
    real a_real,a_imag,b_real,b_imag;
    
    

    mat_mult_uneven#(.out_row(out_row), .out_col(out_col), .common_factor(common_factor)) uut(
        clk,rst,start,valid,
        mat_a, mat_b, mat_out, done);

    always begin
        #10 clk <= ~clk;
    end
    initial begin 
        #1 rst=1; start=0;valid=0;
        #50 rst=0;
        // computation1
        #10 start=0;valid=0;
        for(i=0;i<out_row;i=i+1) begin
            for(j=0;j<common_factor;j=j+1) begin
                a_real = $random%10;
                mat_a[64*(i*common_factor+j) +: 64]=$realtobits(a_real);
                a_imag = $random%10;
                mat_a[64*(i*common_factor+j)+(64*out_row*common_factor)+:64]=$realtobits(a_imag);
            end
        end
        for(i=0;i<common_factor;i=i+1) begin
            for(j=0;j<out_col;j=j+1) begin
                b_real = $random%10;
                mat_b[64*(i*out_col+j) +: 64]=$realtobits(b_real);
                b_imag = $random%10;
                mat_b[64*(i*out_col+j)+(64*common_factor*out_col)+:64]=$realtobits(b_imag);
            end
        end
        #20 valid=1;
        #20 start=1;
        #50 valid=0; start=0;
        #3000 start=0;
        $display("A=");
        for(i=0;i<out_row;i=i+1) begin
            for(j=0;j<common_factor;j=j+1) begin
                $write("%f+j%f    ",
                $bitstoreal(mat_a[64*(i*common_factor+j) +: 64]),
                $bitstoreal(mat_a[64*(i*common_factor+j)+(64*out_row*common_factor)+:64]));
            end
            $write("\n");
        end
        
        #10
        $display("B=");
        for(i=0;i<common_factor;i=i+1) begin
            for(j=0;j<out_col;j=j+1) begin
                $write("%f+j%f    ",
                $bitstoreal(mat_b[64*(i*out_col+j) +: 64]),
                $bitstoreal(mat_b[64*(i*out_col+j)+(64*out_col*common_factor)+:64]));
            end
            $write("\n");
        end

        #10
        $display("Out=");
        for(i=0;i<out_row;i=i+1) begin
            for(j=0;j<out_col;j=j+1) begin
                $write("%f+j%f     ",
                $bitstoreal(mat_out[64*(i*out_col+j) +: 64]),
                $bitstoreal(mat_out[64*(i*out_col+j)+(64*out_col*out_row)+:64]));
            end
            $write("\n");
        end
        #1000$stop();
    end

endmodule