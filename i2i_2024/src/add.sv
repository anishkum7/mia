module add 
#(
    parameter NUM_OPERANDS = 3,
                WIDTH = 64
)
(
  input logic                               clk_i,
  input logic                               rst_ni,
  // Input signals

  // Input Handshake
  input  logic                              in_valid_i,
  output logic                              in_ready_o,
  input  logic                              flush_i,
  input  logic [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i,
  // Output signals
  output logic [WIDTH-1:0]                  result_o,
  output fpnew_pkg::status_t                status_o,
  output TagType                            tag_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i,
  // Indication of valid data in flight
  output logic                              busy_o

);
    
    fpnew_pkg::roundmode_e              rnd_mode_i;
    assign rnd_mode_i = RNE;
    
    fpnew_pkg::operation_e              op_i;
    assign op_i = ADD;
        
    logic                               op_mod_i;
    assign op_mod_i = 0;
    
    fpnew_pkg::fp_format_e              src_fmt_i;
    src_fmt_i = FP64;

    fpnew_pkg::fp_format_e              dst_fmt_i;
    dst_fmt_i = FP64;
    
    //fpnew_pkg::int_format_e             int_fmt_i;
    // logic                               vectorial_op_i;
    // TagType                             tag_i;
    // MaskType                            simd_mask_i;



// FPU instance
fpnew_top #(
  .Features       ( fpnew_pkg::RV64F          ),
  .Implementation ( fpnew_pkg::ADD_MUL_ONLY ),
  .TagType        ( logic                     ),
  .PulpDivsqrt    ( 1'b1                      )
) i_fpnew_top (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i(operands_i),
  .rnd_mode_i(rnd_mode_i),
  .op_i(op_i),
  .op_mod_i(op_mod_i),
  .src_fmt_i(src_fmt_i),
  .dst_fmt_i(dst_fmt_i),
  //.int_fmt_i,
  //.vectorial_op_i,
  //.simd_mask_i,
  //.tag_i,
  .in_valid_i(in_valid_i),
  .in_ready_o(in_ready_o),
  .flush_i(flush_i),
  .result_o(result_o),
  .status_o(status_o),
  .tag_o(tag_o),
  .out_valid_o(out_valid_o),
  .out_ready_i(out_ready_i),
  .busy_o(busy_o)
);

endmodule