module traing_matrix_inv
#(
     parameter SIZE = 16
 )
(
  input logic                               clk_i,
  input logic                               rst_ni,

  input logic [SIZE-1:0][2*64-1:0]          mat_row_i, // {b1,a1}
  input logic                               mat_row_valid_i,
  input logic [$clog2(SIZE)-1:0]            mat_row_addr_i,
  output logic [$clog2(SIZE)-1:0]           mat_row_addr_o,
  output logic                              mat_row_addr_valid_o,
  
  output logic [SIZE*2-1:0][63:0]           inv_col_o, // {b1,a1}
  output logic [$clog2(SIZE)-1:0]           inv_col_addr_o,
  output  logic                             inv_col_valid_o,

  output logic                              in_ready_o,
  input  logic                              flush_i,
  input  logic                              start,
  input  logic                              out_ready_i,

  output logic                              busy_o

);


typedef enum logic [2:0] {IDLE, DIAG, INV} state_t;

state_t state;


logic [3:0][63:0]                  div_operands_i; // {b2,a2,b1,a1}
logic                              div_in_valid_i;
logic                              div_in_ready_o;
logic [1:0][63:0]                  div_result_o;
fpnew_pkg::status_t                div_status_o;
logic                              div_out_valid_o;
logic                              div_out_ready_i;
logic                              div_busy_o;



logic [SIZE*4-1:0][63:0]           vector_mul_operands_i; // {b2,a2,b1,a1}
logic                              vector_mul_in_valid_i;
logic                              vector_mul_in_ready_o;
logic [1:0][63:0]                  vector_mul_result_o;
logic                              vector_mul_out_valid_o;
logic                              vector_mul_out_ready_i;
logic                              vector_mul_busy_o;


logic [3:0][63:0]                  mul_operands_i; // {b2,a2,b1,a1}
logic                              mul_in_valid_i;
logic                              mul_in_ready_o;
logic [1:0][63:0]                  mul_result_o;
fpnew_pkg::status_t                mul_status_o;
logic                              mul_out_valid_o;
logic                              mul_out_ready_i;
logic                              mul_busy_o;


logic [SIZE-1:0][2*64-1:0]            diag_buffer;

logic [$clog2(SIZE)-1:0]              write_ptr;
logic                                 iterate;

always @ (posedge clk_i) begin
  if (!rst_ni) begin
    state <= IDLE;
  end
  else begin
    case (state) 
      IDLE : begin
        if (start) begin
          state <= DIAG;
        end
      end
      DIAG : begin
        if (div_out_valid_o & write_ptr == SIZE-1) begin
          state <= INV;      
        end
      end
      INV : begin
        if (inv_col_addr_o == SIZE-1 & inv_col_valid_o & out_ready_i) begin
          state <= IDLE;
        end
      end
    endcase
  
  end
 
end



always @ (posedge clk_i) begin
  if (!rst_ni) begin
    mat_row_addr_o <= 0;
    mat_row_addr_valid_o <= 0;
    inv_col_o <= 0;
    inv_col_addr_o <= 0;
    write_ptr <= 0;
    iterate <= 0;
  end
  else begin
    case (state) 
      IDLE : begin
        if (start) begin
          iterate <= 1;
        end
      end
      DIAG : begin
        if (div_in_valid_i & div_in_ready_o & iterate) begin
          if (mat_row_addr_o == SIZE-1) begin
            mat_row_addr_o <= 0;
            iterate <= 0;
          end
          else begin
            mat_row_addr_o <= mat_row_addr_o + 1;
          end      
        end

        if (div_out_valid_o) begin
          if (write_ptr == SIZE-1) begin
            write_ptr <= 0;
            
            //Setting up for the next state
            iterate <= 1;
            inv_col_o <= 0;
            mat_row_addr_o <= 'd1;
            
            inv_col_addr_o <= 0;
            inv_col_o[0] <= diag_buffer[0];
          end
          else begin
            write_ptr <= write_ptr+1;
          end
          diag_buffer[write_ptr] <= div_result_o;
        end
      end
      INV : begin
        if (vector_mul_in_valid_i & vector_mul_in_ready_o & iterate) begin
          if (mat_row_addr_o == SIZE-1) begin
            if (inv_col_addr_o == SIZE-2) begin
              mat_row_addr_o <= 0;
            end
            else begin
              mat_row_addr_o <= inv_col_addr_o + 1;
            end
            iterate <= 0;
          end
          else begin
            mat_row_addr_o <= mat_row_addr_o + 1;
          end      
        end 

        if (mul_out_valid_o) begin
          if (write_ptr == SIZE-1) begin
            inv_col_valid_o <= 1;
            if (inv_col_addr_o == SIZE-2) begin      
              write_ptr <= 0;
            end
            else begin
              write_ptr <= inv_col_addr_o + 'd2;
            end            
          end
          else begin
            write_ptr <= write_ptr + 1;
          end
          inv_col_o[write_ptr] <= mul_result_o;
        end

        if (inv_col_valid_o & out_ready_i) begin
          if (inv_col_addr_o != SIZE-2) begin
            inv_col_valid_o <= 0;
          end
          if (inv_col_addr_o == SIZE-1) begin
            inv_col_addr_o <= 0;
          end
          else begin
            inv_col_o <= 0;
            inv_col_o[inv_col_addr_o + 1] <= diag_buffer[inv_col_addr_o + 1];
            if (inv_col_addr_o != SIZE-2) begin
              iterate <= 1;
            end
          end
        end
      end
    endcase
  
  end
 
end

always @ (*) begin

  div_operands_i = {mat_row_i[mat_row_addr_i],64'b0,64'h3ff0000000000000};
  div_in_valid_i = 0;
  div_out_ready_i = 1;
  mat_row_addr_valid_o = 0;

  for (int i=0; i<SIZE; i=i+1) begin
    vector_mul_operands_i[i*4] = inv_col_o[i*2];
    vector_mul_operands_i[i*4+1] = inv_col_o[i*2+1];
    vector_mul_operands_i[i*4+2] = mat_row_i[i][63:0];
    vector_mul_operands_i[i*4+3] = mat_row_i[i][127:64];
  end

  vector_mul_in_valid_i = 0;
  vector_mul_out_ready_i = mul_in_ready_o;
  mul_operands_i = {{~vector_mul_result_o[1][63],vector_mul_result_o[1][62:0],
    ~vector_mul_result_o[0][63],vector_mul_result_o[0][62:0]},
    diag_buffer[write_ptr]}; 
  
  mul_in_valid_i = vector_mul_out_valid_o;
  mul_out_ready_i = out_ready_i;

  case (state) 
    DIAG : begin
      mat_row_addr_valid_o = iterate;
      div_in_valid_i = mat_row_valid_i & (mat_row_addr_i == mat_row_addr_o);
    end
    INV : begin
      mat_row_addr_valid_o = iterate;   
      vector_mul_in_valid_i = mat_row_valid_i & (mat_row_addr_i == mat_row_addr_o);
    end
  endcase 

end




complex_div
// #(
//   
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


complex_matrix_mul
#(
  .SIZE(SIZE)
 )
vector_mul 
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i(vector_mul_operands_i), // {b2,a2,b1,a1}
  .in_valid_i(vector_mul_in_valid_i),
  .in_ready_o(vector_mul_in_ready_o),
  .flush_i(flush_i),
  .result_o(vector_mul_result_o),
  .out_valid_o(vector_mul_out_valid_o),
  .out_ready_i(vector_mul_out_ready_i),
  .busy_o(vector_mul_busy_o)

);

complex_mul
mul
(
.clk_i(clk_i),
.rst_ni(rst_ni),
.operands_i(mul_operands_i), // {b2,a2,b1,a1}
.in_valid_i(mul_in_valid_i),
.in_ready_o(mul_in_ready_o),
.flush_i(flush_i),
.status_o(mul_status_o),
.result_o(mul_result_o),
.out_valid_o(mul_out_valid_o),
.out_ready_i(mul_out_ready_i),
.busy_o(mul_busy_o)
);


endmodule