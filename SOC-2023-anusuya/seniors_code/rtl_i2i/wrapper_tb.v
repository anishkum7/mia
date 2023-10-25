`timescale 1ns / 1ps

module wrapper_tb;

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

    wrapper wrapper_obj(clk, reset, address, writedata, write, read, byteenable, readdata, waitrequest);

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
        //hw ans: 4022c2d727ff9cc8 9.3805477618719947940917336382E0
        //actual answer: 9.3805477618719946
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
        //hw ans: 4083c1bc6a7d1544 6.32216999985896563885034993291E2
        //actual ans: 632.216999985896556
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
        //hw ans: c0c3337dedd8237d -9.83098382093174768669996410608E3
        //actual ans: -9,830.983820931747
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
        //hw ans: c0c350a3d086dd48 -9.88927980123333691153675317764E3
        //actual ans: -9,889.27980123333729
        #10 byteenable = 8'hF0;
        #10 write = 0; read = 1;
        @(posedge waitrequest)
        @(negedge waitrequest)
        #10 read = 0;
        #100 $finish();
    end
endmodule
