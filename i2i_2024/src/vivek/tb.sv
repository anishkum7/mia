module tb;

localparam NUM_OPERANDS=4,
            WIDTH = 64;

logic                               clk_i;
logic                               rst_ni;
  // Input signals

  // Input Handshake
logic                              in_valid_i;
logic                              in_ready_o;
logic                              flush_i;
logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
  // Output signals
logic [1:0][WIDTH-1:0]             result_o;
fpnew_pkg::status_t                status_o;
logic                             tag_o;
  // Output handshake
logic                              out_valid_o;
logic                              out_ready_i;
  // Indication of valid data in flight
logic                              busy_o;

logic                              sub;

real a,b,c,d, expected_div_real, expected_div_imaginary, expected_mul_real, expected_mul_imaginary;

initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
sub = 1;
rst_ni = 0;
in_valid_i = 0;
out_ready_i = 1;

a = $itor($urandom_range(0,2000));
a = (a-1000)/100;
operands_i[0] = $realtobits(a);

b = $itor($urandom_range(0,2000));
b = (b-1000)/100;
operands_i[1] = $realtobits(b);

c = $itor($urandom_range(0,2000));
c = (c-1000)/100;
//c = 0;
operands_i[2] = $realtobits(c);

d = $itor($urandom_range(0,2000));
d = (d-1000)/100;
//d = 0;
operands_i[3] = $realtobits(d);  

// operands_i[0] = 64'h401c000000000000;
// operands_i[1] = 64'h4000000000000000;
// operands_i[2] = 64'h3ff0000000000000;
// operands_i[3] = 64'h4000000000000000;

expected_div_real = (a*c + b*d)/(c*c + d*d);
expected_div_imaginary = (-a*d + b*c)/(c*c + d*d);

expected_mul_real = (a*c - b*d);
expected_mul_imaginary = (a*d + b*c);


flush_i = 0;
#35
rst_ni = 1;
in_valid_i = 1;

wait(out_valid_o == 1'b1);
@(negedge clk_i);
$display("A = %f + j%f        B = %f + j%f", a,b,c,d);
$display("Expected Answer = A*B : %f + j%f ",expected_mul_real, expected_mul_imaginary);
$display("Answer : %f + j%f \n\n\n",$bitstoreal(result_o[0]), $bitstoreal(result_o[1]));
#1000
$finish;
end


// always @ (negedge clk_i) begin
//   $display("%d",out_valid_o);
// end



initial begin
#1000
$finish;
end

complex_mul 
// #(
// .NUM_OPERANDS(3),
// .WIDTH(64)
// )
DUT
(
.clk_i(clk_i),
.rst_ni(rst_ni),
.in_valid_i(in_valid_i),
.in_ready_o(in_ready_o),
.flush_i(flush_i),
.operands_i(operands_i),
.result_o(result_o),
.status_o(status_o),
//.tag_o(tag_o),
//.sub(sub),
.out_valid_o(out_valid_o),
.out_ready_i(out_ready_i),
.busy_o(busy_o)

);


endmodule