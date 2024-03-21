module complex_add
// #(
//     localparam
// )
(
  input logic                               clk_i,
  input logic                               rst_ni,
  // Input signals
  input logic [3:0][63:0]                  operands_i, // {b2,a2,b1,a1}
//   input fpnew_pkg::roundmode_e              rnd_mode_i,
//   input fpnew_pkg::operation_e              op_i,
//   input logic                               op_mod_i,
  // Input Handshake
  input  logic                              in_valid_i,
  output logic                              in_ready_o,
  input  logic                              flush_i,
  input  logic                              sub,
  // Output signals
  output logic [1:0][63:0]                  result_o,
  output fpnew_pkg::status_t                status_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);


//logic                              out_ready_i,
  // Indication of valid data in flight
//logic                              busy_o
logic [63:0] a1 , a2, b1, b2;

assign a1 = operands_i[0];
assign b1 = operands_i[1];
assign a2 = operands_i[2];
assign b2 = operands_i[3];


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
  .Implementation ( '{
                        PipeRegs:   '{default: 0},
                        UnitTypes:  '{'{default: fpnew_pkg::PARALLEL}, // ADDMUL
                                    '{default: fpnew_pkg::DISABLED},   // DIVSQRT
                                    '{default: fpnew_pkg::DISABLED}, // NONCOMP
                                    '{default: fpnew_pkg::DISABLED}},  // CONV
                        PipeConfig: fpnew_pkg::BEFORE
                    }),
  .TagType        ( logic                     ),
  .PulpDivsqrt    ( 1'b1                      )
) 
mul_add0
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i({{b2,a2},{b1,a1},{128'b0}}),
  .rnd_mode_i(fpnew_pkg::RNE),
  .op_i(fpnew_pkg::ADD),
  .op_mod_i(sub),
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
