module traing_matrix_inv
#(
     localparam SIZE = 16
 )
(
  input logic                               clk_i,
  input logic                               rst_ni,

  input logic [SIZE-1:0][2*63:0]            mat_row_i, // {b1,a1}
  input logic                               mat_row_valid_i,
  input logic [$clog2(SIZE)-1:0]            mat_row_addr_i,
  output logic [$clog2(SIZE)-1:0]           mat_row_addr_o,
  output logic                              mat_row_addr_valid_o,
  
  output logic [SIZE*2-1:0][63:0]           inv_col_o, // {b1,a1}
  output  logic                             inv_col_valid_o,

  output logic                              in_ready_o,
  input  logic                              flush_i,
 
  output logic [1:0][63:0]                  result_o,

 
  output logic                              out_valid_o,
  input  logic                              out_ready_i,

  output logic                              busy_o

);


typedef enum logic [2:0] {IDLE, DIAG, INV} state_t;


  logic [3:0][63:0]                  div_operands_i; // {b2,a2,b1,a1}
  logic                              div_in_valid_i;
  logic                              div_in_ready_o;
  logic [1:0][63:0]                  div_result_o;
  fpnew_pkg::status_t                div_status_o;
  logic                              div_out_valid_o;
  logic                              div_out_ready_i;
  logic                              div_busy_o;
  

logic [SIZE-1:0][2*63:0]            diag_buffer;

always @ (posedge clk) begin
  if (!rst_ni) begin
    mat_row_addr_o <= 0;
    mat_row_addr_valid_o <= 0;
  end
  else begin
    case (state_t) 
      DIAG : begin
        if (div_out_valid_o) begin
          if (mat_row_addr_o == SIZE-1) begin
            mat_row_addr_o <= 0;
          end
          else begin
            mat_row_addr_o <= mat_row_addr_o + 1;
          end
          diag_buffer[mat_row_addr_o] <= div_result_o;      
        end

      end
    endcase
  
  end
 
end

always @ (*) begin

  div_operands_i = {64'b0,64'h3ff0000000000000,mat_row_i[mat_row_addr_i]};
  div_in_valid_i = 0;
  case (state_t) 
    DIAG : begin
      mat_row_addr_valid_o = div_in_ready_o;
      div_in_valid_i = mat_row_valid_i & (mat_row_addr_i == mat_row_addr_o);
    end
  endcase 

end




complex_div
// #(
//     localparam
// )
div
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i(div_operands_i), // {b2,a2,b1,a1}
  .in_valid_i(div_in_valid_i),
  .in_ready_o(div_in_ready_o),
  .flush_i(flush_i),
  .result_o(div_result_o),
  .status_o(div_status_o),
  .out_valid_o(div_out_valid_o),
  .out_ready_i(div_out_ready_i),
  .busy_o(div_busy_o)
);

endmodule