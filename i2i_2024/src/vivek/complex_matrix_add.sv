module complex_matrix_add
#(
     parameter SIZE = 16
 )
(
  input logic                               clk_i,
  input logic                               rst_ni,
  // Input signals
  input logic [SIZE*4-1:0][63:0]            operands_i, // {b2,a2,b1,a1}
//   input fpnew_pkg::roundmode_e              rnd_mode_i,
//   input fpnew_pkg::operation_e              op_i,
//   input logic                               op_mod_i,
  // Input Handshake
  input  logic                              in_valid_i,
  output logic                              in_ready_o,
  input  logic                              flush_i,
  input  logic                              sub,
  // Output signals
  output logic [SIZE*2-1:0][63:0]           result_o,
  //output fpnew_pkg::status_t                status_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);


//logic                              out_ready_i,
  // Indication of valid data in flight
//logic                              busy_o
logic [SIZE-1:0] complex_add_in_ready_o;
logic [SIZE-1:0] complex_add_out_valid_o;
logic [SIZE-1:0] complex_add_busy_o;

assign out_valid_o = &complex_add_out_valid_o;
assign in_ready_o = &complex_add_in_ready_o;
assign busy_o = &complex_add_busy_o;

genvar i;

for (i = 0; i < SIZE; i=i+1) begin : add_loop
complex_add
complex_add
(
.clk_i(clk_i),
.rst_ni(rst_ni),
  // Input signals
.operands_i({operands_i[4*i+3],operands_i[4*i+2],operands_i[4*i+1],operands_i[4*i]}), // {b2,a2,b1,a1}
  // Input Handshake
.in_valid_i(in_valid_i),
.in_ready_o(complex_add_in_ready_o[i]),
.flush_i(flush_i),
.sub(sub),
  // Output signals
.result_o({result_o[2*i+1], result_o[2*i]}),
//.status_o(status_o),
  // Output handshake
.out_valid_o(complex_add_out_valid_o[i]),
.out_ready_i(out_ready_i),
  // Indication of valid data in flight
.busy_o(complex_add_busy_o[i])
);

end




endmodule