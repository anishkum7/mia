module tb_triang_inv;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 16;

  input logic                               clk_i;
  input logic                               rst_ni;

  input logic [SIZE-1:0][2*63:0]            mat_row_i; // {b1,a1}
  input logic                               mat_row_valid_i;
  input logic [$clog2(SIZE)-1:0]            mat_row_addr_i;
  output logic [$clog2(SIZE)-1:0]           mat_row_addr_o;
  output logic                              mat_row_addr_valid_o;
  
  output logic [SIZE*2-1:0][63:0]           inv_col_o; // {b1,a1}
  output  logic                             inv_col_valid_o;

  output logic                              in_ready_o;
  input  logic                              flush_i;
  input  logic                              start;

  output logic                              busy_o;


logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix;

real expected_real, expected_imaginary;
real a,b,c,d;

initial begin
  for (int i = 0; i < SIZE; i++) begin
    for (int j = 0; j <= i; j++) begin
      // Generate random real and imaginary parts
      a = $itor($urandom_range(0,2000));
      a = (a-1000)/100;

      b = $itor($urandom_range(0,2000));
      b = (a-1000)/100;

      // Make sure diagonal elements are non-zero
      if (i == j && a == 0)
        a = 1; // Set a non-zero value for the diagonal

      // Assign values to the matrix
      Matrix[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
      Matrix[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);
    end
  end
end


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
sub = 1;
rst_ni = 0;
flush_i = 0;
start = 0;
#35
rst_ni = 1;
start = 1;
#1000
$finish;
end

always @ (posedge clk_i) begin
  mat_row_i <= Matrix[mat_row_addr_o];
  mat_row_addr_i <= mat_row_addr_o;
  mat_row_valid_i <= mat_row_addr_valid_o;
end


traing_matrix_inv
#(
     localparam SIZE = 16
 )
(
  .clk_i,
  .rst_ni,

  .mat_row_i(mat_row_i), // {b1,a1}
  .mat_row_valid_i(mat_row_valid_i),
  .mat_row_addr_i(mat_row_addr_i),
  .mat_row_addr_o(mat_row_addr_o),
  .mat_row_addr_valid_o(mat_row_addr_valid_o),
  .inv_col_o(inv_col_o), // {b1,a1}
  .inv_col_valid_o(inv_col_valid_o),
  .in_ready_o(in_ready_o),
  .flush_i(flush_i),
  .start(start),
  .busy_o(busy_o)

);


endmodule