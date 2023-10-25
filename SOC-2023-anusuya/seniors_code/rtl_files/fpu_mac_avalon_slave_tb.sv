`timescale 1ns/1ps
module fpu_mac_avalon_slave_tb;
    reg         clk;
    reg         reset;
    reg [2:0]   address;
    reg [31:0]  writedata;
    reg         write;
    reg         read;
    wire [31:0] readdata;
    wire        waitrequest;

    fpu_mac_avalon fpu_mac_avalon_inst(clk, reset, address, writedata, write, read, readdata, waitrequest);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; reset = 1;
        #20 reset = 0; 
        #10 address = 0; write = 1; writedata [31:0]  = 32'h40866666;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h41280000; 
        //See OP is 32'h42306666 or 44.1 i.e. 4.2*10.5 = 44.1
        #10 address = 0; write = 1; writedata [31:0]  = 32'h418e3333;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 1; write = 1; writedata [31:0]  = 32'h421ce3a3;
        //See OP of mult is 32'h442e4b4a i.e. 17.775*39.2223 = 697.1763825
        //See OP of add is 32'h443951b0 i.e. 44.1+697.1763825 = 741.2763825
        #10 write = 0;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [31:0]  = 32'h418e3333;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h421ce3a3;
        //See OP of mult is 32'h442e4b4a i.e. 17.775*39.2223 = 697.1763825
        //See OP of add is 32'h44b3ce7d i.e. 44.1+697.1763825+697.1763825 = 1438.452765
        #10 write = 0;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [31:0]  = 32'hc0147ae1;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h4065c28f;
        //See OP of mult is 32'hc10542c4 i.e. -2.32*3.59 = -8.3288
        //See OP of add is 32'h44b2c3f8 i.e. 44.1+697.1763825+697.1763825-8.3288 = 1430.123965
        #10 write = 0;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [31:0]  = 32'h0;
        #10 address = 1; write = 1; writedata [31:0]  = 32'h0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #50 $finish();
    end
endmodule
