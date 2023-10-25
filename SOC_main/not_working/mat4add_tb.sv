`timescale 1ns / 1ps   // Set the timescale for the simulation

module tb_mat4add;

  // Define module inputs and outputs as wires
  reg clk, rst, start;
  wire done;
  reg [255:0] a, b;
  wire [255:0] c;

  // Instantiate the DUT (Device Under Test)
  mat4add dut(
    .clk(clk),
    .rst(rst),
    .a(a),
    .b(b),
    .start(start),
    .c(c),
    .done(done)
  );

	//clk 
  
  initial begin
    clk=1;
    forever begin
      #5 clk = ~clk;
    end
  end
  
   initial begin
     $monitor("Time = %d, done = %b \n", $time, done);
  end
  
	initial begin
      a[63:0] = 64'd1;
      a[127:64] = 64'd2;
      a[191:128]= 64'd3;
      a[255:192] = 64'd4;
      
      b[63:0] = 64'd1;
      b[127:64] = 64'd2;
      b[191:128]= 64'd3;
      b[255:192] = 64'd4;
    end
  
//     always @ (posedge clk) begin
//     if (done) begin
//       c = dut.c;
//     end
//   end
  
    always @ (posedge clk) begin
    if (done) begin
      $display("c = %h", c);
    end
  end
  
//   if(done) begin
//     $display("c = %256b", c[255:0]);
//   end
    
  
endmodule