module tb;

localparam NUM_OPERANDS=3,
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
logic [WIDTH-1:0]                  result_o;
fpnew_pkg::status_t                status_o;
logic                            tag_o;
  // Output handshake
logic                              out_valid_o;
logic                              out_ready_i;
  // Indication of valid data in flight
logic                              busy_o;

initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
rst_ni = 1;
operands_i[0] = 64'h4008000000000000;
operands_i[1] = 64'h4010000000000000;
operands_i[2] = 64'h4008000000000000;
flush_i = 0;
#15
rst_ni = 0;
in_valid_i = 1;
out_ready_i = 1;
#100
$display("Answer : %x",result_o);
$finish;
end


add 
#(
.NUM_OPERANDS(3),
.WIDTH(64)
)
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
.tag_o(tag_o),
.out_valid_o(out_valid_o),
.out_ready_i(out_ready_i),
.busy_o(busy_o)

);


endmodule