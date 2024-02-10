module complex_div
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
  // Output signals
  output logic [1:0][63:0]                  result_o,
  output fpnew_pkg::status_t                status_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);

logic                              mul_add0_in_ready_o;
logic                              mul_add1_in_ready_o;
logic [63:0]                       mul_add0_result_o;
fpnew_pkg::status_t                mul_add0_status_o;
logic                              mul_add0_out_valid_o;

logic                              div_in_ready_o;
logic [63:0]                       mul_add1_result_o;
fpnew_pkg::status_t                mul_add1_status_o;
logic                              mul_add1_out_valid_o;

logic                              complex_mul_in_ready_o;
logic [127:0]                      complex_mul_result_o;
fpnew_pkg::status_t                complex_mul_status_o;
logic                              complex_mul_out_valid_o;



logic [63:0] a1 , a2, b1, b2;
logic mul_add0_busy, mul_add1_busy, complex_mul_busy, div_busy;

assign busy_o = mul_add0_busy | mul_add1_busy | complex_mul_busy | div_busy;
assign in_ready_o = mul_add0_in_ready_o & complex_mul_in_ready_o;

assign a1 = operands_i[0];
assign b1 = operands_i[1];
assign a2 = operands_i[2];
assign b2 = operands_i[3];


complex_mul complex_mul
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  // Input signals
  .operands_i({{~b2[63],b2[62:0]},a2,b1,a1}), // {b2,a2,b1,a1}
  // Input Handshake
  .in_valid_i(in_valid_i),
  .in_ready_o(complex_mul_in_ready_o),
  .flush_i(flush_i),
  // Output signals
  .result_o(complex_mul_result_o),
  .status_o(complex_mul_status_o),
  // Output handshake
  .out_valid_o(complex_mul_out_valid_o),
  .out_ready_i(div_in_ready_o),
  // Indication of valid data in flight
  .busy_o(complex_mul_busy)

);




fpnew_top 
#(
  .Features       ( '{
                        Width:         64,
                        EnableVectors: 1'b0,
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
  .operands_i({64'b0,a2,a2}),
  .rnd_mode_i(fpnew_pkg::RNE),
  .op_i(fpnew_pkg::MUL),
  .op_mod_i(1'b0),
  .src_fmt_i(fpnew_pkg::FP64),
  .dst_fmt_i(fpnew_pkg::FP64),
  //.int_fmt_i,
  //.vectorial_op_i(1'b1),
  //.simd_mask_i,
  //.tag_i,
  .in_valid_i(in_valid_i),
  .in_ready_o(mul_add0_in_ready_o),
  .flush_i(flush_i),
  .result_o(mul_add0_result_o),
  .status_o(mul_add0_status_o),
  //.tag_o(tag_o),
  .out_valid_o(mul_add0_out_valid_o),
  .out_ready_i(mul_add1_in_ready_o),
  .busy_o(mul_add0_busy)
);

fpnew_top 
#(
  .Features       ( '{
                        Width:         64,
                        EnableVectors: 1'b0,
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
mul_add1
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i({mul_add0_result_o,b2,b2}),
  .rnd_mode_i(fpnew_pkg::RNE),
  .op_i(fpnew_pkg::FMADD),
  .op_mod_i(1'b0),
  .src_fmt_i(fpnew_pkg::FP64),
  .dst_fmt_i(fpnew_pkg::FP64),
  //.int_fmt_i,
  //.vectorial_op_i(1'b0),
  //.simd_mask_i,
  //.tag_i,
  .in_valid_i(mul_add0_out_valid_o & in_valid_i),
  .in_ready_o(mul_add1_in_ready_o),
  .flush_i(flush_i),
  .result_o(mul_add1_result_o),
  .status_o(mul_add1_status_o),
  //.tag_o(tag_o),
  .out_valid_o(mul_add1_out_valid_o),
  .out_ready_i(div_in_ready_o),
  .busy_o(mul_add1_busy)
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
  .Implementation ( '{
                        PipeRegs:   '{default: 0},
                        UnitTypes:  '{'{default: fpnew_pkg::DISABLED}, // ADDMUL
                                    '{default: fpnew_pkg::MERGED},   // DIVSQRT
                                    '{default: fpnew_pkg::DISABLED}, // NONCOMP
                                    '{default: fpnew_pkg::DISABLED}},  // CONV
                        PipeConfig: fpnew_pkg::BEFORE
                    }),
  .TagType        ( logic                     ),
  .PulpDivsqrt    ( 1'b1                      )
) 
div
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i({{128'b0},{mul_add1_result_o,mul_add1_result_o},{complex_mul_result_o}}),
  .rnd_mode_i(fpnew_pkg::RNE),
  .op_i(fpnew_pkg::DIV),
  .op_mod_i(1'b0),
  .src_fmt_i(fpnew_pkg::FP64),
  .dst_fmt_i(fpnew_pkg::FP64),
  //.int_fmt_i,
  .vectorial_op_i(1'b1),
  //.simd_mask_i,
  //.tag_i,
  .in_valid_i(mul_add1_out_valid_o & complex_mul_out_valid_o),
  .in_ready_o(div_in_ready_o),
  .flush_i(flush_i),
  .result_o(result_o),
  .status_o(status_o),
  //.tag_o(tag_o),
  .out_valid_o(out_valid_o),
  .out_ready_i(out_ready_i),
  .busy_o(div_busy)
);


endmodule
