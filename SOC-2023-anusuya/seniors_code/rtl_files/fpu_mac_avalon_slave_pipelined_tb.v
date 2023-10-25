`timescale 1ns/1ps
module fpu_mac_avalon_slave_pipelined_tb;
    reg         clk;
    reg         reset;
    reg [2:0]   address;
    reg [63:0]  writedata;
    reg         write;
    reg         read;
    wire [63:0] readdata;
    wire        waitrequest;

    fpu_mac_avalon_pipelined fpu_mac_avalon_pipelined_inst(clk, reset, address, writedata, write, read, readdata, waitrequest);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; reset = 1;
        #20 reset = 0; 
        #10 address = 0; write = 1; writedata [63:0]  = 64'h418e333340866666;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h421ce3a341280000; 
        #10 write = 0;
        //See OP of mult1 is 32'h42306666 or 44.1 i.e. 4.2*10.5 = 44.1
        //See OP of mult2 is 32'h442e4b4a i.e. 17.775*39.2223 = 697.1763825
        //See OP of add1 is 32'h443951b0 i.e. 44.1+697.1763825 = 741.2763825
        //See OP of add2 is 32'h443951b0 i.e. 44.1+697.1763825 = 741.2763825
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [63:0]  = 64'hc0147ae1418e3333;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h4065c28f421ce3a3; 
        #10 write = 0;
        //See OP of mult1 is 32'h442e4b4a i.e. 17.775*39.2223 = 697.1763825
        //See OP of mult2 is 32'hc10542c4 i.e. -2.32*3.59 = -8.3288
        //See OP of add1 is 32'h442c363f i.e. 697.1763825-8.3288 = 688.8475825
        //See OP of add2 is 32'hc10542c4 i.e. 32'h44b2c3f8 i.e. 44.1+697.1763825+697.1763825-8.3288 = 1430.123965
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [63:0]  = 64'h418e333340866666;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h421ce3a341280000; 
        #10 write = 0;
        //See OP of add2 is 32'hc10542c4 i.e. 32'h4507b668 i.e. 1430.123965+44.1+697.1763825 = 2171.4003475
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [63:0]  = 64'hc0147ae1418e3333;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h4065c28f421ce3a3; 
        #10 write = 0;
        //See OP of add2 is 32'h4532c3f8 i.e. 32'h44b2c3f8 i.e. 1430.123965 + 1430.123965 = 2860.24793
        @(posedge waitrequest)
        @(negedge waitrequest)
        //NEW INPUTS
        #10 address = 0; write = 1; writedata [63:0]  = 64'h40df07b3c057ae14;
        #10 address = 1; write = 1; writedata [63:0]  = 64'hc057ae1440df07b3; 
        #10 write = 0;
        //See OP of add2 is 32'hc10542c4 i.e. 32'h452fd45b i.e. 2860.24793-23.4878553-23.4878553 = 2813.2722194
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 address = 0; write = 1; writedata [63:0]  = 64'hc3160000c3160000;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h4120000041200000; 
        #10 write = 0;
        //See OP of add2 is 32'hc10542c4 i.e. 32'hc33aba50 i.e. 2813.2722194 - 1500 - 1500 = -186.7277806
        @(posedge waitrequest)
        @(negedge waitrequest)
        #400 read = 1;
        #10 read = 0;
        #200 $finish();
    end
endmodule
