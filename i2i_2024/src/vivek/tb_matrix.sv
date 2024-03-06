module tb_matrix;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 16;

logic                               clk_i;
logic                               rst_ni;
  // Input signals

  // Input Handshake
logic                              in_valid_i;
logic                              in_ready_o;
logic                              flush_i;
logic [SIZE*NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
  // Output signals
logic [2*SIZE-1:0][WIDTH-1:0]             result_o;
fpnew_pkg::status_t                status_o;
logic                             tag_o;
  // Output handshake
logic                              out_valid_o;
logic                              out_ready_i;
  // Indication of valid data in flight
logic                              busy_o;

logic                              sub;


logic [SIZE-1:0][WIDTH-1:0] Vector1real, Vector1imaginary;
logic [SIZE-1:0][WIDTH-1:0] Vector2real, Vector2imaginary;

assign Vector1real = {{64'h404313a0ff5f8f88}, {64'hc036162502a0b894}, {64'hc0542dc9b8c1a8ba}, {64'hc0281de8bfa6cb28}, {64'h404ad0ee3485851c}, {64'h40325dd9777c7668}, {64'hc05386aa80b42f26}, {64'hc0535605d176e4a5}, {64'hc043a5fe2d6d5d95}, {64'h4054900c4031135c}, {64'h405613e5e095362a}, {64'h405270c6c462bc22}, {64'h40470cd1c48b720c}, {64'hc0414b5f86616086}, {64'h402eadd52553a688}, {64'h4047da9f96fb8b10}};
assign Vector1imaginary = {{64'hc04a7b99ebb96640}, {64'hc05233598d02e9c2}, {64'h4055494d7ef9d5c6}, {64'h4030857cd00e3c9c}, {64'hc0424024c8c067ec}, {64'h40447cc5be9abff8}, {64'h403fd7f44ffef8e8}, {64'h4039b09f7dbbb0f0}, {64'hbfdc403cc7870a00}, {64'hc021d3773d48f5f0}, {64'hc04485180ba4a2fa}, {64'hc04042f827db912a}, {64'h4051bf358c53264e}, {64'h4038284922b6cd90}, {64'hc04f933e12bb6985}, {64'hc055d74884d8ed2d}};
assign Vector2real = {{64'hc04343c2ebea3bf8}, {64'hc032490ccc50df64}, {64'h40359c799a674b74}, {64'hc041c781b3525b74}, {64'h4046f4b57c40a1b8}, {64'h4052d6a0b5f5cc62}, {64'hc041b0d11d2bcc34}, {64'hc0473cf63611ced5}, {64'h3ff53e856cf6e840}, {64'h40253490de566d48}, {64'h40491de9402ac820}, {64'hc046161dbdb956f8}, {64'h4043f92c41fb6e70}, {64'h40115cc513c19160}, {64'h405764b72515e3d0}, {64'hc0300b7aacd7e10c}};
assign Vector2imaginary = {{64'h40500c167476c156}, {64'hc04e6586942e3ea6}, {64'hc0470e48d56d0f3a}, {64'hc0413ec9f5fd7e20}, {64'hc04ae48cb81b4c28}, {64'h4052be000070c464}, {64'h402f9e63e3ffd608}, {64'hc04d7e2206f477e0}, {64'hc0329233ffd74ae8}, {64'h404b1f1196f73cd4}, {64'h404c7cde3bd57040}, {64'hc0495c64c72b9ddb}, {64'h40334eb7555876d4}, {64'hc042e3a61975f69b}, {64'h403e4642399162f0}, {64'hc04911ddf1cb91e6}};


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
sub = 1;
rst_ni = 0;
in_valid_i = 0;
out_ready_i = 0;

for (int i=0; i<SIZE; i=i+1) begin
  // operands_i[i*NUM_OPERANDS] = 64'h401c000000000000;
  // operands_i[i*NUM_OPERANDS+1] = 64'h4000000000000000;
  // operands_i[i*NUM_OPERANDS+2] = 64'h3ff0000000000000;
  // operands_i[i*NUM_OPERANDS+3] = 64'h4000000000000000;
  operands_i[i*NUM_OPERANDS] = Vector1real[i];
  operands_i[i*NUM_OPERANDS+1] = Vector1imaginary[i];
  operands_i[i*NUM_OPERANDS+2] = Vector2real[i];
  operands_i[i*NUM_OPERANDS+3] = Vector2imaginary[i];
end

flush_i = 0;
#35
rst_ni = 1;
in_valid_i = 1;
out_ready_i = 1;
wait(out_valid_o == 1'b1);
@(negedge clk_i);
for (int i=0; i<SIZE; i=i+1) begin
  $display("Answer %d : %x  %x", i, result_o[2*i+1], result_o[2*i]);
end
#1000
$finish;
end


complex_matrix_mul 
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
//.status_o(status_o),
//.tag_o(tag_o),
//.sub(sub),
.out_valid_o(out_valid_o),
.out_ready_i(out_ready_i),
.busy_o(busy_o)

);


endmodule