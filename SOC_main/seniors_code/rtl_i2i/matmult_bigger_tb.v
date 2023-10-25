/*

4x4 matrix multiplication


*/

`timescale 1ns / 1ps

module mult_wrapper_tb();

    reg         clk;
    reg         rst;
    reg         valid;
    reg         start;
    reg [2:0]   addra;
    reg [63:0]  inpa;
    reg [2:0]   addrb;
    reg [63:0]  inpb;
    wire [255:0] c;
    wire        done;


    matmult matmult_dut(clk,rst,valid,start,addra,inpa,addrb,inpb,c,done);

    always begin
        #5 clk <= ~clk;
    end

    initial begin
        clk = 1; rst = 1; 
        start = 0;
        #20 rst = 0; 
  
        #10 valid = 1;     
        #10 addra = 0; inpa  = 64'h3FF0000000000000; addrb = 0; inpb  = 64'h4020000000000000;
        //a=1 b=8
        #10 addra = 1; inpa  = 64'h4000000000000000; addrb = 1; inpb  = 64'h401C000000000000;
        //a=2 b=7
        
        #10 addra = 2; inpa  = 64'h4008000000000000; addrb = 2; inpb  = 64'h4018000000000000;
        //a=3 b=6
        
        #10 addra = 3; inpa  = 64'h4010000000000000; addrb = 3; inpb  = 64'h4014000000000000;
        //a=4 b=5
            
        #10 addra = 4; inpa  = 64'h4014000000000000; addrb = 4; inpb  = 64'h4010000000000000;
        //a=5 b=4
       
        #10 addra = 5; inpa  = 64'h4018000000000000; addrb = 5; inpb  = 64'h4008000000000000;
        //a=6 b=3
       
        
        #10 addra = 6; inpa  = 64'h401C000000000000; addrb = 6; inpb  = 64'h4000000000000000;
        //a=7 b=2
      
        #10 addra = 7; inpa  = 64'h4020000000000000; addrb = 7;  inpb  = 64'h3FF0000000000000;
        //a=8 b= 1

        #20 start = 1;
        #10 start = 0;
       
       
    
        //@(posedge done)
        //@(negedge done)
        #10000 valid = 0;

        #10 valid = 1;     
        #10 addra = 0; inpa  = 64'h4014000000000000; addrb = 0; inpb  = 64'h4020000000000000;
        //a=5 b=8
        #10 addra = 1; inpa  = 64'h4018000000000000; addrb = 1; inpb  = 64'h401C000000000000;
        //a=6 b=7
        
        #10 addra = 2; inpa  = 64'h401C000000000000; addrb = 2; inpb  = 64'h4018000000000000;
        //a=7 b=6
        
        #10 addra = 3; inpa  = 64'h4020000000000000; addrb = 3; inpb  = 64'h4014000000000000;
        //a=8 b=5
            
        #10 addra = 4; inpa  = 64'h3FF0000000000000; addrb = 4; inpb  = 64'h4010000000000000;
        //a=1 b=4
       
        #10 addra = 5; inpa  = 64'h4000000000000000; addrb = 5; inpb  = 64'h4008000000000000;
        //a=2 b=3
       
        
        #10 addra = 6; inpa  = 64'h4008000000000000; addrb = 6; inpb  = 64'h4000000000000000;
        //a=3 b=2
      
        #10 addra = 7; inpa  = 64'h4010000000000000; addrb = 7;  inpb  = 64'h3FF0000000000000;
        //a=4 b= 1

        #20 start = 1;
        #10 start = 0;
       

        //@(posedge done)
        //@(negedge done)
        #10000 valid = 0;

        #10 valid = 1;     
        #10 addra = 0; inpa  = 64'h3FF0000000000000; addrb = 0; inpb  = 64'h401C000000000000;
        //a=1 b=7
        #10 addra = 1; inpa  = 64'h4000000000000000; addrb = 1; inpb  = 64'h4020000000000000;
        //a=2 b=8
        
        #10 addra = 2; inpa  = 64'h4008000000000000; addrb = 2; inpb  = 64'h4014000000000000;
        //a=3 b=5
        
        #10 addra = 3; inpa  = 64'h4010000000000000; addrb = 3; inpb  = 64'h4018000000000000;
        //a=4 b=6
            
        #10 addra = 4; inpa  = 64'h4014000000000000; addrb = 4; inpb  = 64'h4008000000000000;
        //a=5 b=3
       
        #10 addra = 5; inpa  = 64'h4018000000000000; addrb = 5; inpb  = 64'h4010000000000000;
        //a=6 b=4
       
        
        #10 addra = 6; inpa  = 64'h401C000000000000; addrb = 6; inpb  = 64'h3FF0000000000000;
        //a=7 b=1
      
        #10 addra = 7; inpa  = 64'h4020000000000000; addrb = 7; inpb  = 64'h4000000000000000;
        //a=8 b=2

        #20 start = 1;
        #10 start = 0;
       
       
    
        //@(posedge done)
        //@(negedge done)
        #10000 valid = 0;

        #10 valid = 1;     
        #10 addra = 0; inpa  = 64'h4014000000000000; addrb = 0; inpb  = 64'h401C000000000000;
        //a=5 b=7
        #10 addra = 1; inpa  = 64'h4018000000000000; addrb = 1; inpb  = 64'h4020000000000000;
        //a=6 b=8
        
        #10 addra = 2; inpa  = 64'h401C000000000000; addrb = 2; inpb  = 64'h4014000000000000;
        //a=7 b=5
        
        #10 addra = 3; inpa  = 64'h4020000000000000; addrb = 3; inpb  = 64'h4018000000000000;
        //a=8 b=6
            
        #10 addra = 4; inpa  = 64'h3FF0000000000000; addrb = 4; inpb  = 64'h4008000000000000;
        //a=1 b=3
       
        #10 addra = 5; inpa  = 64'h4000000000000000; addrb = 5; inpb  = 64'h4010000000000000;
        //a=2 b=4
       
        
        #10 addra = 6; inpa  = 64'h4008000000000000; addrb = 6; inpb  = 64'h3FF0000000000000;
        //a=3 b=1
      
        #10 addra = 7; inpa  = 64'h4010000000000000; addrb = 7; inpb  = 64'h4000000000000000;
        //a=4 b=2

        #20 start = 1;
        #10 start = 0;
       

        //@(posedge done)
        //@(negedge done)
        #10000 valid = 0;




        #2000 $finish();
    end
endmodule



/*
 *
   A             B              C
 1 2 3 4      8 7 7 8    40   30  30  40
 5 6 7 8      6 5 5 6    120  94  94  120
 5 6 7 8      4 3 3 4    120  94  94  120
 1 2 3 4      2 1 1 2    40   30  30  40
 
 
 
 

c11 = 4044000000000000   --> 'd40
c12 = 403E000000000000   --> 'd30
c21 = 405E000000000000   --> 'd120
c22 = 4057800000000000   --> 'd94




405E000000000000, 4057800000000000,     4044000000000000 ,403E000000000000



NEW

c11 = 405E000000000000   --> 'd120
c12 = 4057800000000000   --> 'd94
c21 = 4044000000000000   --> 'd40
c22 = 403E000000000000   --> 'd30

 4044000000000000 ,403E000000000000 ,405E000000000000,4057800000000000



 NEW

c11 = 403E000000000000   --> 'd30
c12 = 4044000000000000   --> 'd40
c21 = 4057800000000000   --> 'd94
c22 = 405E000000000000   --> 'd120

 4057800000000000, 405E000000000000, 403E000000000000  , 4044000000000000

c11 = 4057800000000000   --> 'd94
c12 = 405E000000000000   --> 'd120
c21 = 403E000000000000   --> 'd30
c22 = 4044000000000000   --> 'd40


 403E000000000000  , 4044000000000000  , 4057800000000000  ,405E000000000000



*/
