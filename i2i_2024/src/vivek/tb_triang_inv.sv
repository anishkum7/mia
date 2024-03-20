module tb_triang_inv;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 16;

  logic                               clk_i;
  logic                               rst_ni;

  logic [SIZE-1:0][2*63:0]            mat_row_i; // {b1,a1}
  logic                               mat_row_valid_i;
  logic [$clog2(SIZE)-1:0]            mat_row_addr_i;
  logic [$clog2(SIZE)-1:0]           mat_row_addr_o;
  logic                              mat_row_addr_valid_o;
  
  logic [SIZE*2-1:0][63:0]           inv_col_o; // {b1,a1}
  logic                             inv_col_valid_o;

  logic                              in_ready_o;
  logic                              flush_i;
  logic                              start;

  logic                              busy_o;


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
rst_ni = 0;
flush_i = 0;
start = 0;
#35
rst_ni = 1;
start = 1;
#20000
$finish;
end

always @ (posedge clk_i) begin
  mat_row_i <= Matrix[mat_row_addr_o];
  mat_row_addr_i <= mat_row_addr_o;
  mat_row_valid_i <= mat_row_addr_valid_o;
end


traing_matrix_inv
#(
  .SIZE(SIZE)
 )
 DUT
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