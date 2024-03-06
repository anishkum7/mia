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

assign Vector1real = {{64'h4048cc542607b3a4}, {64'h4050cf86cf5d54ae}, {64'h401ee1f7e2888640}, {64'hc057ded85709ddf5}, {64'hc0508241913d2fc2}, {64'h40515da89d8e1146}, {64'hc053b6b8b594d935}, {64'hc05767fb10e847e5}, {64'hc04bf392fcc47f0a}, {64'hc04dc03b5de79661}, {64'h4049409ee736fe9c}, {64'h403793dca8037554}, {64'h4047193420eb5170}, {64'h404306691f268c88}, {64'hc044a8a321482fc3}, {64'hc046f994dce81afc}};
assign Vector1imaginary = {{64'hc0249834a0edd5b0}, {64'h4053672735a29638}, {64'h40570782880e1cb2}, {64'hc057d4ddd4f85b2d}, {64'h404052370f50b03c}, {64'h4054992e89cff9c4}, {64'h404e8e65565f3704}, {64'hc02fd657f2a76ad0}, {64'h405642d3759bf51c}, {64'h4054c74a921f1424}, {64'h40531702a3d3f370}, {64'hc0442df8d0dbea56}, {64'h405028419916e422}, {64'h40425d74799d119c}, {64'h40496dc55baa5f4c}, {64'h404174abac2d5cf8}};
assign Vector2real = {{64'hc0585399381cac9a}, {64'hc0449d28f1f65e42}, {64'h40564747ddf444c4}, {64'h4048c629f68d8e84}, {64'h4053c7b36bb78680}, {64'h404f159c8cc1e6e0}, {64'hc03106e8e2eb7ed0}, {64'h4049a4f066e5d004}, {64'h404d8190e6dd2264}, {64'hc0547a5f0e21db30}, {64'h40507a4f7cf2d72c}, {64'hc0550b868b9d3b54}, {64'h40569ea6d809241e}, {64'hc054f2d7c5f147be}, {64'hc02af81f3477a5e0}, {64'h40207612874e2f48}};
assign Vector2imaginary = {{64'hc03ae032ed9a876c}, {64'h40405dd4984192dc}, {64'h405167a0b2d40e54}, {64'hc050c581fc99d809}, {64'h40004333be70e580}, {64'hc050c13c1108b08c}, {64'hc050a7dad97ea77d}, {64'h404a776d8000f01c}, {64'h4050ec020f6c9058}, {64'hc00ab5838ed50540}, {64'h40570b335e64bc8a}, {64'hc0503b7b3c39688f}, {64'h405175938f7066f4}, {64'h401c742bed927af0}, {64'h403b78ed9d6d7d7c}, {64'h404f055082b59f24}};


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