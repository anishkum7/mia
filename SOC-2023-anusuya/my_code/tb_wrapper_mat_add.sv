`timescale 1ps / 1ps
module tb_wrapper_mat_add;

    bit         clk;
    reg         reset;
    reg [22:0]   address;
    reg [63:0]  writedata;
    reg         write;
    reg         read;
    reg [7:0] byteenable;
    wire [63:0] readdata;
    wire        waitrequest;
    localparam mat_num_row = 2;
    sc_wrapper_mat_add#(.mat_num_row(mat_num_row)) dut_inst(
                                                            clk,
                                                            reset,
                                                            address, 
                                                            writedata,
                                                            write,
                                                            read,
                                                            byteenable,
                                                            readdata,
                                                            waitrequest);
    real a_real,a_imag,b_real,b_imag;
    reg[63:0] a_val;
    integer i;
    always begin
        #5 clk <= ~clk;
    end
    
    initial begin
        #1 clk = 1; reset = 1; i=-1;
        # 10 reset=0;
        // a_real;
        #10 //i=0
        a_real = 8; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; 
        byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=1
        a_real = 7; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=2
        a_real = 1; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=3
        a_real = 9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; byteenable = 8'h0F;
        #10 byteenable = 8'hF0;
        
        // a_imaginary;
        #10 //i=0
        a_real = -9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=1
        a_real = 7; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=2
        a_real = 9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=3
        a_real = 2; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        // b_real;
        #10 //i=0
        a_real = -9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=1
        a_real = -1; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=2
        a_real = 8; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=3
        a_real = 9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

         // b_imaginary;
        #10 //i=0
        a_real = -9; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=1
        a_real = -4; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val;  byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=2
        a_real = 7; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 //i=3
        a_real = 0; i=i+1; address =i; write =1; a_val = $realtobits(a_real); writedata = a_val; byteenable = 8'h0F;
        #10 byteenable = 8'hF0;

        #10 
        a_real = 0; i=i+1; address =i; 
        #10 i=-1; address =i; write=0;

        
        #3000 i=-1;

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        // out_real
        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

         // out_imaginary;
        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #10 
        i=i+1; address =i; read =1; 
        #10 a_val=readdata; a_real = $bitstoreal(a_val);
        $write("i=%d val = %f\n",i,a_real);

        #3000 $stop();


    end
endmodule

