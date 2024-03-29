module tb_triang_inv;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 4;

  logic                               clk_i;
  logic                               rst_ni;

  logic [SIZE-1:0][2*64-1:0]            mat_row_i; // {b1,a1}
  logic                               mat_row_valid_i;
  logic [$clog2(SIZE)-1:0]            mat_row_addr_i;
  logic [$clog2(SIZE)-1:0]           mat_row_addr_o;
  logic                              mat_row_addr_valid_o;
  
  logic [SIZE*2-1:0][63:0]           inv_col_o; // {b1,a1}
  logic [$clog2(SIZE)-1:0]          inv_col_addr_o;
  logic                             inv_col_valid_o;

  logic                              in_ready_o;
  logic                              flush_i;
  logic                              start;
  logic                              out_ready_i;

  logic                              busy_o;


logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] InvMatrix;

real product [SIZE-1:0][2*SIZE-1:0];

real expected_real, expected_imaginary;
real a,b,c,d;

initial begin
  for (int i = 0; i < SIZE; i++) begin
    for (int j = 0; j < SIZE; j++) begin
      
      if (j < i) begin
        Matrix[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = 0;
        Matrix[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = 0;
      end
      else begin
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
end


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
rst_ni = 0;
flush_i = 0;
start = 0;
#35
out_ready_i = 1;
rst_ni = 1;
start = 1;
#20
start = 0;
wait(in_ready_o == 1);
$write("Input Matrix: \n\n");
for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(Matrix[i][j*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(Matrix[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end

$write("Output Matrix: \n\n");

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(InvMatrix[j][i*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(InvMatrix[j][i*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    product[i][2*j] = 0;
    product[i][2*j+1] = 0;
    for (int k=0; k<SIZE; k=k+1) begin
      a = $bitstoreal(Matrix[i][k*2*WIDTH + WIDTH-1 -: WIDTH]);
      b = $bitstoreal(Matrix[i][k*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
      c = $bitstoreal(InvMatrix[j][k*2*WIDTH + WIDTH-1 -: WIDTH]);
      d = $bitstoreal(InvMatrix[j][k*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
      product[i][2*j] += a*c - b*d;
      product[i][2*j+1] += a*d + b*c;
    end
  end
end

$write("Product: \n\n");
for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = product[i][2*j];
    b = product[i][2*j+1];
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end

#20
$finish;
end

always @ (posedge clk_i) begin
  mat_row_i <= Matrix[mat_row_addr_o];
  mat_row_addr_i <= mat_row_addr_o;
  mat_row_valid_i <= mat_row_addr_valid_o;

  if (inv_col_valid_o) begin
    InvMatrix[inv_col_addr_o] <= inv_col_o;
  end

end


triang_matrix_inv
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
  .inv_col_addr_o(inv_col_addr_o),
  .inv_col_valid_o(inv_col_valid_o),
  .in_ready_o(in_ready_o),
  .flush_i(flush_i),
  .start(start),
  .out_ready_i(out_ready_i),
  .busy_o(busy_o)

);


endmodule