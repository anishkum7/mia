`timescale 1ns/1ps
module fpu_multiplier_avalon_slave_tb;
    reg         clk;
    reg         reset;
    reg [2:0]   address;
    reg [31:0]  writedata;
    reg         write;
    reg         read;
    wire [31:0] readdata;
    wire        waitrequest;

    fpu_multiplier_avalon fpu_multiplier_avalon_inst(clk, reset, address, writedata, write, read, readdata, waitrequest);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; reset = 1;
        #20 reset = 0; 
        #10 address = 0; write = 1; writedata [31:0]  = 32'h40866666;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h41280000;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #10 address = 0; write = 1; writedata [31:0]  = 32'h418e3333;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h421ce3a3;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #100 $finish();
    end
endmodule
