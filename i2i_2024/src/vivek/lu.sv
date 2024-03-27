module lu
#(
     parameter SIZE = 16
 )
(
  input logic                               clk_i,
  input logic                               rst_ni,

  input logic [SIZE-1:0][2*64-1:0]          mat_row_i, // {b1,a1}
  input logic                               mat_row_valid_i,
  input logic [$clog2(SIZE)-1:0]            mat_row_read_addr_i,
  output logic [$clog2(SIZE)-1:0]           mat_row_read_addr_o,
  output logic                              mat_row_read_addr_valid_o,
  
  output logic [SIZE-1:0][2*64-1:0]         mat_row_o, // {b1,a1}
  output logic                              mat_row_valid_o,
  output logic [$clog2(SIZE)-1:0]           mat_row_write_addr_o,
  input logic                               mat_row_out_ready_i,
  
  output logic [SIZE-1:0][2*64-1:0]         l_col_o, // {b1,a1}
  output logic [SIZE-1:0][2*64-1:0]         u_row_o, // {b1,a1}
  output logic [$clog2(SIZE)-1:0]           result_addr_o,
  output logic                              result_valid_o,
  input logic                               result_out_ready_i,

  output logic                              in_ready_o,
  input  logic                              flush_i,
  input  logic                              start,
  //input  logic                              out_ready_i,

  output logic                              busy_o

);


typedef enum logic [2:0] {IDLE, INIT, LU} state_t;

state_t state;


logic [3:0][63:0]                  div_operands_i; // {b2,a2,b1,a1}
logic                              div_in_valid_i;
logic                              div_in_ready_o;
logic [1:0][63:0]                  div_result_o;
fpnew_pkg::status_t                div_status_o;
logic                              div_out_valid_o;
logic                              div_out_ready_i;
logic                              div_busy_o;



logic [SIZE-1:0][3:0][63:0]        vector_sub_operands_i; // {b2,a2,b1,a1}
logic                              vector_sub_in_valid_i;
logic                              vector_sub_in_ready_o;
logic [SIZE-1:0][1:0][63:0]        vector_sub_result_o;
logic                              vector_sub_out_valid_o;
logic                              vector_sub_out_ready_i;
logic                              vector_sub_busy_o;


logic [SIZE-1:0][3:0][63:0]        vector_mul_operands_i; // {b2,a2,b1,a1}
logic                              vector_mul_in_valid_i;
logic [SIZE-1:0]                   vector_mul_in_ready_o;
logic [SIZE-1:0][1:0][63:0]        vector_mul_result_o;
fpnew_pkg::status_t [SIZE-1:0]     vector_mul_status_o;
logic [SIZE-1:0]                   vector_mul_out_valid_o;
logic                              vector_mul_out_ready_i;
logic [SIZE-1:0]                   vector_mul_busy_o;


logic [3:0][63:0]                  mul_operands_i; // {b2,a2,b1,a1}
logic                              mul_in_valid_i;
logic                              mul_in_ready_o;
logic [1:0][63:0]                  mul_result_o;
fpnew_pkg::status_t                mul_status_o;
logic                              mul_out_valid_o;
logic                              mul_out_ready_i;
logic                              mul_busy_o;


logic [1:0][63:0]                  div_result_buffer;
//logic [SIZE-1:0][2*64-1:0]         mat_row_buffer;

//logic                              loaded;

logic                              result_written, mat_row_written;

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
          state <= INIT;
        end
      end
      INIT : begin
        if (div_out_valid_o) begin
          state <= LU;
        end
      end
      LU : begin
        if (result_written & mat_row_written) begin
          state <= INIT;
        end 
      end

    endcase
  
  end
 
end



always @ (posedge clk_i) begin
  if (!rst_ni) begin
    mat_row_read_addr_o <= 0;
    mat_row_read_addr_valid_o <= 0;
    write_ptr <= 0;
    iterate <= 0;
    result_valid_o <= 0;
    result_written <= 0;
    mat_row_written <= 0;
    result_addr_o <= 0;
  end
  else begin
    case (state) 
      IDLE : begin
        if (start) begin
          iterate <= 1;
        end
      end
      INIT : begin
        if (div_in_valid_i) begin
          iterate <= 0;
          l_col_o[result_addr_o] <= {64'b0,64'h3ff0000000000000};

          for (int i=0; i<SIZE; i=i+1) begin
            if (i < result_addr_o) begin
              u_row_o[i] <= 0;
            end
            else begin
              u_row_o[i] <= mat_row_i[i];
            end
          end
        
        end
        
        if (div_out_valid_o) begin
          div_result_buffer <= div_result_o;
          iterate <= 1;
          //mat_row_read_addr_o <= result_addr_o + 1;
          //write_ptr <= result_addr_o + 1;
        end

      end
      LU : begin
        if (vector_sub_in_valid_i & vector_sub_in_ready_o & iterate) begin
          if (mat_row_read_addr_o == SIZE-1) begin
            iterate <= 0;
            if (result_addr_o == SIZE-2) begin
              mat_row_read_addr_o <= 0;
            end
            else begin
              mat_row_read_addr_o <= result_addr_o + 'd2;
            end
          end
          else begin
            mat_row_read_addr_o <= mat_row_read_addr_o + 1;
          end
        end

        if (mul_out_valid_o) begin
          l_col_o[write_ptr] <= mul_result_o;
        end

        if (vector_sub_out_valid_o & vector_sub_out_ready_i) begin
          if (write_ptr == SIZE-1) begin
            mat_row_written <= 1;
            if (result_addr_o == SIZE-2) begin
              write_ptr <= 0;
            end
            else begin
              write_ptr <= result_addr_o + 'd2;
            end
          end
          else begin
            write_ptr <= write_ptr + 1;
          end
        end

        if (mul_out_valid_o & write_ptr == SIZE-1) begin
          result_valid_o <= 1;
        end
        if (result_valid_o & result_out_ready_i) begin
          result_valid_o <= 0;
          result_written <= 1;
        end
        if (result_written & mat_row_written) begin
          result_written <= 0;
          mat_row_written <= 0;
          iterate <= 1;
          if (result_addr_o == SIZE-2) begin
            result_addr_o <= 0;
          end
          else begin
            result_addr_o <= result_addr_o + 1;
          end

        end 

      end

    endcase
  
  end
 
end

always @ (*) begin

  div_operands_i = {mat_row_i[result_addr_o],64'b0,64'h3ff0000000000000};
  div_in_valid_i = 0;
  div_out_ready_i = 1;

  mat_row_read_addr_valid_o = 0;
  in_ready_o = state == IDLE;
  busy_o = state != IDLE;

  for (int i=0; i<SIZE; i=i+1) begin  
    vector_mul_operands_i[i] = {u_row_o[i],mul_result_o};
    vector_sub_operands_i[i] = {vector_mul_result_o[i],mat_row_i[i]};
  end
  vector_mul_in_valid_i = 0;
  vector_mul_out_ready_i = 0;
  vector_sub_in_valid_i = 0;
  vector_sub_out_ready_i = 0;
  
  mul_operands_i = {div_result_buffer,mat_row_i[result_addr_o]};
  mul_in_valid_i = 0;
  mul_out_ready_i = 0;

  mat_row_write_addr_o = write_ptr;
  mat_row_valid_o = 0;
  mat_row_o = vector_sub_result_o;

  case (state)
    IDLE : begin
    end
    INIT  : begin
      mat_row_read_addr_valid_o = iterate;
      div_in_valid_i = mat_row_valid_i & mat_row_read_addr_o == mat_row_read_addr_i;
    end
    LU : begin

      vector_mul_in_valid_i = mul_out_valid_o;
      vector_mul_out_ready_i = vector_sub_in_ready_o;
      
      vector_sub_in_valid_i = (&vector_mul_out_valid_o) & (mat_row_read_addr_i == mat_row_read_addr_o) & mat_row_valid_i;
      vector_sub_out_ready_i = mat_row_out_ready_i;

      mul_in_valid_i = (mat_row_read_addr_i == mat_row_read_addr_o) & mat_row_valid_i;
      mul_out_ready_i = vector_mul_in_ready_o;

      mat_row_read_addr_valid_o = iterate;
      mat_row_valid_o = vector_sub_out_valid_o;
    
    end
  endcase 

end



genvar j;

for (j=0 ; j<SIZE; j=j+1) begin : vector_mul_loop
  complex_mul
  vector_mul
  (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i(vector_mul_operands_i[j]), // {b2,a2,b1,a1}
  .in_valid_i(vector_mul_in_valid_i),
  .in_ready_o(vector_mul_in_ready_o[j]),
  .flush_i(flush_i),
  .result_o(vector_mul_result_o[j]),
  .status_o(vector_mul_status_o[j]),
  .out_valid_o(vector_mul_out_valid_o[j]),
  .out_ready_i(vector_mul_out_ready_i),
  .busy_o(vector_mul_busy_o[j])
  );

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


complex_matrix_add
#(
  .SIZE(SIZE)
 )
vector_sub 
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .operands_i(vector_sub_operands_i), // {b2,a2,b1,a1}
  .in_valid_i(vector_sub_in_valid_i),
  .in_ready_o(vector_sub_in_ready_o),
  .flush_i(flush_i),
  .sub(1'b1),
  .result_o(vector_sub_result_o),
  .out_valid_o(vector_sub_out_valid_o),
  .out_ready_i(vector_sub_out_ready_i),
  .busy_o(vector_sub_busy_o)

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