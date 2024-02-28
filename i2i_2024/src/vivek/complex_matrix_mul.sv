module complex_matrix_mul
#(
     localparam SIZE = 16
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
  output logic [1:0][63:0]           result_o,
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
logic [SIZE/2-1:0] complex_add0_in_ready_o;
logic [SIZE/2-1:0] complex_add0_out_valid_o;
logic [SIZE/2-1:0] complex_add0_busy_o;
logic [2*(SIZE/2)-1:0][63:0] complex_add0_result_o;

logic [SIZE/4-1:0] complex_add1_in_ready_o;
logic [SIZE/4-1:0] complex_add1_out_valid_o;
logic [SIZE/4-1:0] complex_add1_busy_o;
logic [2*(SIZE/4)-1:0][63:0] complex_add1_result_o;

logic [SIZE/8-1:0] complex_add2_in_ready_o;
logic [SIZE/8-1:0] complex_add2_out_valid_o;
logic [SIZE/8-1:0] complex_add2_busy_o;
logic [2*(SIZE/8)-1:0][63:0] complex_add2_result_o;

logic complex_addfinal_in_ready_o;
// logic complex_add2_in_ready_o;
// logic complex_add2_out_valid_o;
// logic complex_add2_busy_o;
// logic [2*(SIZE/8)-1:0][63:0] complex_add2_result_o;



logic [SIZE-1:0] complex_mul_in_ready_o;
logic [SIZE-1:0] complex_mul_out_valid_o;
logic [SIZE-1:0] complex_mul_busy_o;
logic [SIZE*2-1:0][63:0] complex_mul_result_o;
;
assign in_ready_o = &complex_mul_in_ready_o;
assign busy_o = (&complex_add0_busy_o) & (&complex_add1_busy_o) & (&complex_add2_busy_o) ;

genvar i, j;

// for (i=0; i < 8; i=i+1) begin : mul_loop0
//   for (j=0; j < SIZE/(2*(i+1)); j = j+1) begin : mul_loop1
//     if (i == 0) begin
//       complex_add
//       complex_add
//       (
//       .clk_i(clk_i),
//       .rst_ni(rst_ni),
//         // Input signals
//       .operands_i({operands_i[4*j+3],operands_i[4*j+2],operands_i[4*j+1],complex_mul_result_o[4*j]}), // {b2,a2,b1,a1}
//         // Input Handshake
//       .in_valid_i(in_valid_i),
//       .in_ready_o(complex_add_in_ready_o[i]),
//       .flush_i(flush_i),
//       .sub(1'b0),
//         // Output signals
//       .result_o({result_o[2*i+1], result_o[2*i]}),
//       //.status_o(status_o),
//         // Output handshake
//       .out_valid_o(complex_add_out_valid_o[i]),
//       .out_ready_i(out_ready_i),
//         // Indication of valid data in flight
//       .busy_o(complex_add_busy_o[i])
//       );
//     end
//   end
  
// end

for (i=0; i < SIZE/2; i=i+1) begin : add_loop0
  complex_add
  complex_add
  (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
    // Input signals
  .operands_i({complex_mul_result_o[4*i+3],complex_mul_result_o[4*i+2],complex_mul_result_o[4*i+1],complex_mul_result_o[4*i]}), // {b2,a2,b1,a1}
    // Input Handshake
  .in_valid_i(&complex_mul_out_valid_o),
  .in_ready_o(complex_add0_in_ready_o[i]),
  .flush_i(flush_i),
  .sub(1'b0),
    // Output signals
  .result_o({complex_add0_result_o[2*i+1], complex_add0_result_o[2*i]}),
  //.status_o(status_o),
    // Output handshake
  .out_valid_o(complex_add0_out_valid_o[i]),
  .out_ready_i(&complex_add1_in_ready_o),
    // Indication of valid data in flight
  .busy_o(complex_add0_busy_o[i])
  );

end

for (i=0; i < SIZE/4 ; i=i+1) begin : add_loop1
  complex_add
  complex_add
  (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
    // Input signals
  .operands_i({complex_add0_result_o[4*i+3],complex_add0_result_o[4*i+2],complex_add0_result_o[4*i+1],complex_add0_result_o[4*i]}), // {b2,a2,b1,a1}
    // Input Handshake
  .in_valid_i(&complex_mul_out_valid_o),
  .in_ready_o(complex_add1_in_ready_o[i]),
  .flush_i(flush_i),
  .sub(1'b0),
    // Output signals
  .result_o({complex_add1_result_o[2*i+1], complex_add1_result_o[2*i]}),
  //.status_o(status_o),
    // Output handshake
  .out_valid_o(complex_add1_out_valid_o[i]),
  .out_ready_i(&complex_add2_in_ready_o),
    // Indication of valid data in flight
  .busy_o(complex_add1_busy_o[i])
  );

end


for (i=0; i < SIZE/8 ; i=i+1) begin : add_loop2
  complex_add
  complex_add
  (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
    // Input signals
  .operands_i({complex_add1_result_o[4*i+3],complex_add1_result_o[4*i+2],complex_add1_result_o[4*i+1],complex_add1_result_o[4*i]}), // {b2,a2,b1,a1}
    // Input Handshake
  .in_valid_i(&complex_mul_out_valid_o),
  .in_ready_o(complex_add2_in_ready_o[i]),
  .flush_i(flush_i),
  .sub(1'b0),
    // Output signals
  .result_o({complex_add2_result_o[2*i+1], complex_add2_result_o[2*i]}),
  //.status_o(status_o),
    // Output handshake
  .out_valid_o(complex_add2_out_valid_o[i]),
  .out_ready_i(complex_addfinal_in_ready_o),
    // Indication of valid data in flight
  .busy_o(complex_add2_busy_o[i])
  );

end

complex_add
final_add
(
.clk_i(clk_i),
.rst_ni(rst_ni),
  // Input signals
.operands_i({complex_add2_result_o[3],complex_add2_result_o[2],complex_add2_result_o[1],complex_add2_result_o[0]}), // {b2,a2,b1,a1}
  // Input Handshake
.in_valid_i(&complex_mul_out_valid_o),
.in_ready_o(complex_addfinal_in_ready_o),
.flush_i(flush_i),
.sub(1'b0),
  // Output signals
.result_o(result_o),
//.status_o(status_o),
  // Output handshake
.out_valid_o(out_valid_o),
.out_ready_i(out_ready_i),
  // Indication of valid data in flight
.busy_o(busy_o)
);


for (i = 0; i < SIZE; i=i+1) begin : mul_loop
complex_mul
complex_mul
(
.clk_i(clk_i),
.rst_ni(rst_ni),
  // Input signals
.operands_i({operands_i[4*i+3],operands_i[4*i+2],operands_i[4*i+1],operands_i[4*i]}), // {b2,a2,b1,a1}
  // Input Handshake
.in_valid_i(in_valid_i),
.in_ready_o(complex_mul_in_ready_o[i]),
.flush_i(flush_i),
  // Output signals
.result_o({complex_mul_result_o[2*i+1], complex_mul_result_o[2*i]}),
//.status_o(status_o),
  // Output handshake
.out_valid_o(complex_mul_out_valid_o[i]),
.out_ready_i(&complex_add0_in_ready_o),
  // Indication of valid data in flight
.busy_o(complex_mul_busy_o[i])
);

end




endmodule