module complex_mul_add
// #(
//     localparam
// )
(
  input logic                               clk_i,
  input logic                               rst_ni,
  // Input signals
  input logic [3:0][63:0]                  operands_i, // {a1,b1,a2,b2}
//   input fpnew_pkg::roundmode_e              rnd_mode_i,
//   input fpnew_pkg::operation_e              op_i,
//   input logic                               op_mod_i,
  // Input Handshake
  input  logic                              in_valid_i,
  output logic                              in_ready_o,
  input  logic                              flush_i,
  // Output signals
  output logic [3:0][63:0]                     result_o,
  output fpnew_pkg::status_t                status_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);


fpnew_top 
#(
  .Features       ( '{
                        Width:         2*64,
                        EnableVectors: 1'b1,
                        EnableNanBox:  1'b1,
                        FpFmtMask:     5'b01000,
                        IntFmtMask:    4'b0000
                    }
                    ),
  .Implementation ( fpnew_pkg::ADD_MUL_ONLY ),
  .TagType        ( logic                     ),
  .PulpDivsqrt    ( 1'b1                      )
) 
mul_add0
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i({{128'b0},{operands_i[3],operands_i[2]},{operands_i[1],operands_i[0]}}),
  .rnd_mode_i(fpnew_pkg::RNE),
  .op_i(fpnew_pkg::MUL),
  .op_mod_i(1'b0),
  .src_fmt_i(fpnew_pkg::FP64),
  .dst_fmt_i(fpnew_pkg::FP64),
  //.int_fmt_i,
  .vectorial_op_i(1'b1),
  //.simd_mask_i,
  //.tag_i,
  .in_valid_i(in_valid_i),
  .in_ready_o(in_ready_o),
  .flush_i(flush_i),
  .result_o(result_o),
  .status_o(status_o),
  //.tag_o(tag_o),
  .out_valid_o(out_valid_o),
  .out_ready_i(out_ready_i),
  .busy_o(busy_o)
);


endmodule
