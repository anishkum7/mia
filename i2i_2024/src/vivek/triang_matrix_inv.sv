module traing_matrix_inv
#(
     localparam SIZE = 16
 )
(
  input logic                               clk_i,
  input logic                               rst_ni,

  input logic [SIZE*2-1:0][63:0]            mat_row_i, // {b1,a1}
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

logic [SIZE*2-1:0][63:0]            diag_buffer;

always @ (posedge clk) begin
  if (!rst_ni) begin
    mat_row_addr_o <= 0;
    mat_row_addr_valid_o <= 0;
  end
  else begin
    case (state_t) 
    
    endcase
  
  end
 

end

endmodule