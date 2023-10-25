`timescale 1ns/1ps

module matinvtb_lower_triangle_tb;

reg [1023:0] inputmat;
reg clk;
reg rst;
reg start;

wire[1023:0] result;

matinv_lower_triangle UUT(.inp(inputmat),.clk(clk),.rst(rst),.start(start),.ainv(result));

always begin
    //clk = 0;
    #5 clk=~clk;
    end

/*initial begin
    rst = 1'b0;
    inputmat = {64'h}*/

initial begin
        clk = 1; rst = 0; 
        start = 0;
        #20 rst = 1;
		#20 rst = 0; 
      
        //#10 inputmat = {64'h3FF0000000000000, 64'h4020000000000000,64'h4000000000000000,64'h401C000000000000,64'h4008000000000000,64'h4018000000000000,64'h4010000000000000,64'h4014000000000000,64'h4014000000000000,64'h4010000000000000,64'h4018000000000000,64'h4008000000000000,64'h401C000000000000,64'h4000000000000000,64'h4020000000000000,64'h3FF0000000000000};
/*
        #10 inputmat = {64'h3FF0000000000000, 
						64'h0,
						64'h0,
						64'h0,
						64'h4008000000000000,
						64'h4018000000000000,
						64'h0,
						64'h0,
						64'h4014000000000000,
						64'h4010000000000000,
						64'h4018000000000000,
						64'h0,
						64'h401C000000000000,
						64'h4000000000000000,
						64'h4020000000000000,
						64'h3FF0000000000000};

*/
		#10 inputmat = {64'h3FF0000000000000, 
						64'h401C000000000000,
						64'h4008000000000000,
						64'h4018000000000000,
						64'h0,						
						64'h4014000000000000,
						64'h4010000000000000,
						64'h4018000000000000,
						64'h0,
						64'h0,
						64'h4000000000000000,
						64'h4020000000000000,
						64'h0,
						64'h0,
						64'h0,
						64'h3FF0000000000000};
		
		#20 start= 1;
        #10 start= 0;
 /*       
        #10 inputmat = {64'h4014000000000000,64'h4020000000000000,64'h4018000000000000,64'h401C000000000000,64'h401C000000000000,64'h4018000000000000,64'h4020000000000000,64'h4014000000000000,64'h3FF0000000000000,64'h4010000000000000,64'h4000000000000000,64'h4008000000000000,64'h4008000000000000,64'h4000000000000000,64'h4010000000000000,64'h3FF0000000000000};

        #20 start =1;
        #10 start =0;

        #10 inputmat = {64'h3FF0000000000000,64'h401C000000000000,64'h4000000000000000,64'h4020000000000000,64'h4008000000000000,64'h4014000000000000,64'h4010000000000000,64'h4018000000000000,64'h4014000000000000,64'h4008000000000000,64'h4018000000000000,64'h4010000000000000,64'h401C000000000000,64'h3FF0000000000000,64'h4020000000000000,64'h4000000000000000};

        #20 start =1;
        #10 start =0;

        #10 inputmat = {64'h4014000000000000,64'h401C000000000000,64'h4018000000000000,64'h4020000000000000,64'h401C000000000000,64'h4014000000000000,64'h4020000000000000,64'h4018000000000000,64'h3FF0000000000000,64'h4008000000000000,64'h4000000000000000,64'h4010000000000000,64'h4008000000000000,64'h3FF0000000000000,64'h4010000000000000,64'h4000000000000000};

        #20 start = 1;
        #10 start = 0;
*/
        #2000 $finish();
    end
endmodule
/*module matlu_tb;
	
	localparam p=2;
	localparam period=20;
	
	//reg [63:0] a[0:p-1][0:p-1];
	reg [63:0] a[3:0];
	reg clk;
	reg rst;
	wire [63:0] l[3:0];
	wire [63:0] u[3:0];
	//wire [63:0] l[0:p-1][0:p-1];
	//wire [63:0] u[0:p-1][0:p-1];
	
	matlu UUT(.a({a[3],a[2],a[1],a[0]}),.clk(clk),.rst(rst),.ll({l[3],l[2],l[1],l[0]}),.uu({u[3],u[2],u[1],u[0]}));
	
	initial begin
		clk=0;
		forever #5 clk= ~clk;
		end
	
	initial
		begin
		rst=1'b0;
		{a[3],a[2],a[1],a[0]}={64'h0000000000000008,64'h0000000000000008,64'h0000000000000002,64'h0000000000000004};
		//#20 a=16'hFEDCBA987654321;
		#20
		{a[3],a[2],a[1],a[0]}={64'h0000000000000008,64'h0000000000000006,64'h0000000000000004,64'h0000000000000002};
		#20 $stop;
		end
		endmodule
*/
