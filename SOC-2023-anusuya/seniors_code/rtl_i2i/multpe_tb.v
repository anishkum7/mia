`timescale 1ns / 1ps
module multpe_tb();
    reg clk;
    reg [1:0] addr;
    reg [63:0] inp;
    reg rst;
    reg valid;
    reg start;
    wire done;
    wire [127:0] out;

    initial
    begin
        clk = 0;
        valid = 0;
        start = 0;
        #5
        rst = 1;
        #10 
        rst = 0;
        #10
        valid = 1;
        inp = 64'h40092AF77DB8CC83;
        addr = 0;
        #10
        valid = 1;
        inp = 64'h4018F0329122D34E;
        addr = 1;
        #10
        valid = 1;
        inp = 64'h40092AF77DB8CC83;
        addr = 2;
        #10
        valid = 0;
        start = 1;
        #10
        start = 0;
        #500 
        valid = 1;
        inp = 64'hC035A77C30B4E545;
        addr = 0;
        #10
        valid = 1;
        inp = 64'h40846EF84C02BC6E;
        addr = 1;
        #10
        valid = 1;
        inp = 64'hC035A77C30B4E545;
        addr = 2;
        #10
        valid = 0;
        start = 1;
        #10
        start = 0;
        #1000$finish;

    end

    always
    begin
        #5 clk = ~clk;
    end

    multpe peobj(clk, addr, inp, rst, valid, start, done, out);

endmodule

    