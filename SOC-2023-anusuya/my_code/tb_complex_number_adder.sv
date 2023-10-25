`timescale 1ps/1ps
module complex_number_adder();
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
    wire [63:0] output_z_real;
    wire        output_z_real_stb;
    
    reg         output_z_imag_ack;
    wire [63:0] output_z_imag;
    wire        output_z_imag_stb;
    
    wire        input_a_real_ack;
    wire        input_a_imag_ack;
    
    wire        input_b_real_ack;
    wire        input_b_imag_ack;

    reg[63:0] vin;
    reg[52:0] vout;
    reg        done, error,rst2;
    integer ip_file,op_file, r3,r4,r5,r6;


    //double_adder adder_real(input_a_real, input_b_real, input_a_real_stb, input_b_real_stb, output_z_real_ack, clk, rst, output_z_real, output_z_real_stb, input_a_real_ack, input_b_real_ack);
    //double_adder adder_imag(input_a_imag, input_b_imag, input_a_imag_stb, input_b_imag_stb, output_z_imag_ack, clk, rst, output_z_imag, output_z_imag_stb, input_a_imag_ack, input_b_imag_ack);

    double_complexnumber_adder uut(input_a_real,input_a_imag,input_a_real_stb,input_a_imag_stb, input_a_real_ack,
     input_a_imag_ack,
    input_b_real,input_b_imag,input_b_real_stb,input_b_imag_stb, input_b_real_ack, input_b_imag_ack,
    output_z_real,output_z_imag,output_z_real_stb,output_z_imag_stb,output_z_real_ack,output_z_imag_ack,
    clk,rst);

    // double2int dispunit_output_real (clk,rst2,vin,vout,done,error);
    // double2int dispunit_output_imag (clk,rst,output_z_imag,output_int_imag,done,error);
    // double2int dispunit_inA_real (clk,rst,input_a_real,inA_int_real,done,error);
    // double2int dispunit_inA_imag (clk,rst,input_a_imag,inA_int_imag,done,error);
    // double2int dispunit_inB_real (clk,rst,input_B_real,inB_int_real,done,error);
    // double2int dispunit_inB_imag (clk,rst,input_B_imag,inB_int_imag,done,error);

always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; rst = 1;
        // #10  ip_file = $fopen("C:\\Users\\anusu\\OneDrive\\Documents\\MSECE_Purdue\\Spring1_2023\\I2I_2\\SOC-2023\\my_code\\input.txt","r"); //op_file = $fopen("output.txt","w");
         #20 rst = 0;
        // #10 r3 = $fscanf(ip_file,"%h\n",input_a_real);
        // r4 = $fscanf(ip_file,"%h\n",input_a_imag);
        // r5 = $fscanf(ip_file,"%h\n",input_b_real);
        // r6 = $fscanf(ip_file,"%h\n",input_b_imag);

        #10 input_a_real = 64'hC024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h4024000000000000;input_b_imag = 64'h4024000000000000; 
        // #10 input_a_real = 64'h4024000000000000; input_a_imag = 64'h4024000000000000; input_b_real = 64'h4024000000000000;input_b_imag = 64'h4024000000000000; 
        input_a_real_stb = 1;
        input_a_imag_stb = 1; 
        input_b_real_stb = 1; input_b_imag_stb = 1; 
        #30 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        #550 output_z_real_ack = 1; output_z_imag_ack =1;

        $display("\n A   = %f+j%f\n B   = %f+j%f\n Sum = %f+j%f\n", 
        $bitstoreal(input_a_real),$bitstoreal(input_a_imag),$bitstoreal(input_b_real),$bitstoreal(input_b_imag),$bitstoreal(output_z_real),$bitstoreal(output_z_imag));

        // #30 input_a_real = 32'h418e3333; input_a_real_stb = 1;
        // input_b_real = 32'h421ce3a3; input_b_real_stb = 1;
        // input_a_imag = 32'h418e3333; input_a_imag_stb = 1;
        // input_b_imag = 32'h421ce3a3; input_b_imag_stb = 1;
        // #30 input_a_real_stb = 0; input_b_real_stb = 0; input_b_imag_stb = 0; input_a_imag_stb = 0;
        // #150 output_z_real_ack = 1; output_z_imag_ack =1;

        // #150 $display("\n input_a_real = %G input_a_imag = %G input_b_real = %G input_b_imag = %G output_z_real=%G output_z_imag=%G", (input_a_real),(input_a_imag),(input_b_real),(input_b_imag),(output_z_real),(output_z_imag));
        #300 $stop();
    end
endmodule