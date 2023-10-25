`timescale 1ns / 1ps

module mult_wrapper_tb;

    reg         clk;
    reg         reset;
    reg         reset2;
    reg [2:0]   address;
    reg [63:0]  writedata;
    reg         write;
    reg         read;
    reg [7:0] byteenable;
    wire [63:0] readdata;
    wire        waitrequest;

    mult_wrapper mult_wrapper_obj(clk, reset, address, writedata, write, read, byteenable, readdata, waitrequest);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; reset = 1; reset2 = 1;
        #20 reset = 0; reset2 = 0;        
        #10 address = 0; write = 1; writedata [63:0]  = 64'h40092AF77DB8CC83; byteenable = 8'h0F; 
        //3.1459798643132346
        #10 byteenable = 8'hF0;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h4018F0329122D34E; byteenable = 8'h0F;
        //6.23456789755876
        //hw ans: 40339d23a3c24d1a 1.96138250684135542201147472952E1
        //actual answer: 19.613825068413556098373299165096
        #10 byteenable = 8'hF0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #10 address = 0; write = 1; writedata [63:0]  = 64'hC035A77C30B4E545; byteenable = 8'h0F;
        //-21.654238742984734
        #10 byteenable = 8'hF0;
        #10 address = 1; write = 1; writedata [63:0]  = 64'h40846EF84C02BC6E; byteenable = 8'h0F;
        //653.87123872888129
        //hw ans: c0cba78abd952f0e -1.41590839106063613144215196371E4
        //actual ans: -14,159.083910606361304635383368227
        #10 byteenable = 8'hF0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;     
        #10 address = 0; write = 1; writedata [63:0]  = 64'hC0C3330E104E9E8A; byteenable = 8'h0F;
        //-9830.1098726534
        #10 byteenable = 8'hF0;
        #10 address = 1; write = 1; writedata [63:0]  = 64'hBFEBF762613CAAF7; byteenable = 8'h0F;
        //-0.873948278347
        //hw ans: 40c0c780f9026f7c 8.59100759916728566167876124382E3
        //actual ans: 8,591.0075991672863466559298
        #10 byteenable = 8'hF0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #10 address = 0; write = 1; writedata [63:0]  = 64'h405305F0F163539F; byteenable = 8'h0F;
        //76.09283098888271
        #10 byteenable = 8'hF0;
        #10 address = 1; write = 1; writedata [63:0]  = 64'hC0C376AFB269A3EF; byteenable = 8'h0F;
        //-9965.37263222222
        //hw ans: c127242ad4b53267 -7.58293415444922517053782939911E5
        //actual ans: -758,293.4154449226033943422358162
        #10 byteenable = 8'hF0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #100 $finish();
    end
endmodule
