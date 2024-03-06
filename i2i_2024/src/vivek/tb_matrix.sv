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

Vector1real = {{64'hc057abd4b82cc2cb}, {64'hc05800847ec10f1b}, {64'h405262655dee9b80}, {64'h4058ecb9063db582}, {64'hc0518e0fd15aa1c6}, {64'hc03396a3bbc7e4c8}, {64'h3fd9fcc76adda600}, {64'hc03ffff48e8426b8}, {64'hc056693e1f3a956f}, {64'hc040146fce04320c}, {64'h4037e7d3fb1f8db4}, {64'hbfed24366521dc80}, {64'hc05305fff4ca56b8}, {64'h404de9ae7705abe0}, {64'h401047872168e790}, {64'hc054c68bd8960c86}};
Vector1imaginary = {{64'h4052e8032376b7e4}, {64'h40557bd965a05c9a}, {64'hc04a01e3b3f2fbf0}, {64'hc02179c56f0d08e8}, {64'hc02ef748b99e95b8}, {64'hc04165ab1649b3b8}, {64'hc037f16a00717a28}, {64'hc01894798c795ca0}, {64'h40551f96a6720e0a}, {64'h404eb8a8cff32398}, {64'hc03558aab09ca970}, {64'hc0504f159900337e}, {64'h4031457a4954b580}, {64'h4043cebbb3296638}, {64'h404da65bf968a368}, {64'hc04142d2fadb0730}};
Vector2real = {{64'h403f0df0d45c5328}, {64'h405210af8deb6260}, {64'h40406de3a4605f9c}, {64'h404c9633ed503ae0}, {64'h4054790de739a38c}, {64'hc04e899461265c3f}, {64'h4051b765a7bd3d1e}, {64'hc03067aab3174d0c}, {64'hc033ea9068793e74}, {64'h40579da5fc188056}, {64'hc0576fb638e3e7ea}, {64'h404740893b4c73ac}, {64'h4056a27b2d2e43d4}, {64'hc0534c32e7dcd30b}, {64'h4027dfc68b9ef580}, {64'h404800032cede8c8}};
Vector2imaginary = {{64'hc0518437a5b0ed3c}, {64'hc04fd5f8cdc55c46}, {64'hc055c20926a6ef4b}, {64'hc052386b7ff055e7}, {64'h4031396c531a5dd4}, {64'hc02bd2db9c8281f8}, {64'h404cf17a32d45068}, {64'h401c75d277584e60}, {64'h4045f3c15c655bd0}, {64'h4049487b633f2378}, {64'h4054e1da91ce1000}, {64'h40513d2b76997426}, {64'h40588d9ad4f9d940}, {64'h4026f2401ea83918}, {64'hc04dff3a4350eba5}, {64'h40573127c20228d8}};


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