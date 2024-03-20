module basic_lu
(input logic clk_i,
input logic rst_ni,



);


complex_div
lu_div
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  // Input signals
  .operands_i(operands_i), // {b2,a2,b1,a1}
//   input fpnew_pkg::roundmode_e              rnd_mode_i,
//   input fpnew_pkg::operation_e              op_i,
//   input logic                               op_mod_i,
  // Input Handshake
  .in_valid_i(in_valid_i),
  output logic                              in_ready_o,
  input  logic                              flush_i,
  // Output signals
  output logic [1:0][63:0]                  result_o,
  output fpnew_pkg::status_t                status_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);









endmodule