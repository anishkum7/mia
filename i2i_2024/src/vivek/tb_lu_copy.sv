module tb_lu_copy;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 4;

  logic                               clk_i;
  logic                               rst_ni;

  logic [SIZE-1:0][2*64-1:0]          mat_row_i; // {b1,a1}
  logic                               mat_row_valid_i;
  logic [$clog2(SIZE)-1:0]            mat_row_read_addr_i;
  logic [$clog2(SIZE)-1:0]           mat_row_read_addr_o;
  logic                              mat_row_read_addr_valid_o;
  
  logic [SIZE-1:0][2*64-1:0]         mat_row_o; // {b1,a1}
  logic                              mat_row_valid_o;
  logic [$clog2(SIZE)-1:0]           mat_row_write_addr_o;
  logic                              mat_row_out_ready_i;
  
  logic [SIZE-1:0][2*64-1:0]         l_col_o; // {b1,a1}
  logic [SIZE-1:0][2*64-1:0]         u_row_o; // {b1,a1}
  logic [$clog2(SIZE)-1:0]           result_addr_o;
  logic                              result_valid_o;
  logic                              result_out_ready_i;

  logic                              in_ready_o;
  logic                              flush_i;
  logic                              start;
  //input  logic                              out_ready_i,

  logic                              busy_o;

  logic [SIZE-1:0][2*64-1:0]          triang_inv_mat_row_i; // {b1,a1}
  logic                               triang_inv_mat_row_valid_i;
  logic [$clog2(SIZE)-1:0]            triang_inv_mat_row_addr_i;
  logic [$clog2(SIZE)-1:0]           triang_inv_mat_row_addr_o;
  logic                              triang_inv_mat_row_addr_valid_o;
  
  logic [SIZE*2-1:0][63:0]          triang_inv_inv_col_o; // {b1,a1}
  logic [$clog2(SIZE)-1:0]          triang_inv_inv_col_addr_o;
  logic                             triang_inv_inv_col_valid_o;

  logic                              triang_inv_in_ready_o;
  logic                              triang_inv_start;
  logic                              triang_inv_out_ready_i;

  logic                              triang_inv_busy_o;


logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Linv;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Uinv;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Inv;


real input_mat [SIZE-1:0][2*SIZE-1:0];

real l_inv [SIZE-1:0][2*SIZE-1:0];
real u_inv [SIZE-1:0][2*SIZE-1:0];
real inverse [SIZE-1:0][2*SIZE-1:0];
real product [SIZE-1:0][2*SIZE-1:0];

real expected_real, expected_imaginary;
real a,b,c,d;

initial begin
  for (int i = 0; i < SIZE; i++) begin
    for (int j = 0; j < SIZE; j++) begin
      

        // Generate random real and imaginary parts
        a = $itor($urandom_range(0,2000));
        a = (a-1000)/100;

        b = $itor($urandom_range(0,2000));
        b = (b-1000)/100;

        b = 0;
        // Make sure diagonal elements are non-zero
        if (i == j && a == 0)
          a = 1; // Set a non-zero value for the diagonal

        // Assign values to the matrix
        Matrix[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
        Matrix[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);

        input_mat[i][2*j] = a;
        input_mat[i][2*j+1] = b;

    end
  end

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
end


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
rst_ni = 0;
flush_i = 0;
start = 0;
triang_inv_start = 0;
#35
result_out_ready_i = 1;
mat_row_out_ready_i = 1;
triang_inv_out_ready_i = 1;
rst_ni = 1;
start = 1;
#20
start = 0;
wait(in_ready_o == 1);

Matrix = U;
#5
triang_inv_start = 1;
#20
triang_inv_start = 0;
wait(triang_inv_in_ready_o == 1);

Uinv = Inv;
Matrix = L;
#5
triang_inv_start = 1;
#20
triang_inv_start = 0;
wait(triang_inv_in_ready_o == 1);

Linv = Inv;

$write("Output L Matrix: \n\n");

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(L[j][i*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(L[j][i*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end

$write("Output U Matrix: \n\n");

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(U[i][j*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(U[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end

$write("L Inverse Matrix: \n\n");

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(Linv[i][j*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(Linv[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end


$write("U Inverse Matrix: \n\n");

for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = $bitstoreal(Uinv[j][i*2*WIDTH + WIDTH-1 -: WIDTH]);
    b = $bitstoreal(Uinv[j][i*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
    $write("(%f + j%f)",a,b);
    if (j == SIZE-1) begin
      $write("\n");
    end
  end
end



for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    inverse[i][2*j] = 0;
    inverse[i][2*j+1] = 0;
    for (int k=0; k<SIZE; k=k+1) begin
      a = $bitstoreal(Uinv[k][i*2*WIDTH + WIDTH-1 -: WIDTH]);
      b = $bitstoreal(Uinv[k][i*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
      c = $bitstoreal(Linv[k][j*2*WIDTH + WIDTH-1 -: WIDTH]);
      d = $bitstoreal(Linv[k][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
      inverse[i][2*j] += a*c - b*d;
      inverse[i][2*j+1] += a*d + b*c;
    end
  end
end

$write("Inverse: \n\n");
for (int i=0; i<SIZE; i=i+1) begin
  for (int j=0; j<SIZE; j=j+1) begin
    a = inverse[i][2*j];
    b = inverse[i][2*j+1];
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
      a = input_mat[i][2*k];
      b = input_mat[i][2*k+1];
      c = inverse[k][2*j];
      d = inverse[k][2*j+1];
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

initial begin
#900000
$finish;
end

always @ (posedge clk_i) begin
  mat_row_i <= Matrix[mat_row_read_addr_o];
  mat_row_read_addr_i <= mat_row_read_addr_o;
  mat_row_valid_i <= mat_row_read_addr_valid_o;

  if (mat_row_valid_o) begin
    Matrix[mat_row_write_addr_o] <= mat_row_o;
  end
  if (result_valid_o) begin
    L[result_addr_o] <= l_col_o;
    U[result_addr_o] <= u_row_o;
  end

  triang_inv_mat_row_i <= Matrix[triang_inv_mat_row_addr_o];
  triang_inv_mat_row_addr_i <= triang_inv_mat_row_addr_o;
  triang_inv_mat_row_valid_i <= triang_inv_mat_row_addr_valid_o;

  if (triang_inv_inv_col_valid_o) begin
    Inv[triang_inv_inv_col_addr_o] <= triang_inv_inv_col_o;
  end

end


lu
#(
    .SIZE(SIZE)
 )
 lu
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),

  .mat_row_i(mat_row_i), // {b1,a1}
  .mat_row_valid_i(mat_row_valid_i),
  .mat_row_read_addr_i(mat_row_read_addr_i),
  .mat_row_read_addr_o(mat_row_read_addr_o),
  .mat_row_read_addr_valid_o(mat_row_read_addr_valid_o),
  
  .mat_row_o(mat_row_o), // {b1,a1}
  .mat_row_valid_o(mat_row_valid_o),
  .mat_row_write_addr_o(mat_row_write_addr_o),
  .mat_row_out_ready_i(mat_row_out_ready_i),
  
  .l_col_o(l_col_o), // {b1,a1}
  .u_row_o(u_row_o), // {b1,a1}
  .result_addr_o(result_addr_o),
  .result_valid_o(result_valid_o),
  .result_out_ready_i(result_out_ready_i),

  .in_ready_o(in_ready_o),
  .flush_i(flush_i),
  .start(start),
  //input  logic                              out_ready_i,

  .busy_o(busy_o)

);

triang_matrix_inv
#(
  .SIZE(SIZE)
 )
 DUT
(
  .clk_i(clk_i),
  .rst_ni(rst_ni),

  .mat_row_i(triang_inv_mat_row_i), // {b1,a1}
  .mat_row_valid_i(triang_inv_mat_row_valid_i),
  .mat_row_addr_i(triang_inv_mat_row_addr_i),
  .mat_row_addr_o(triang_inv_mat_row_addr_o),
  .mat_row_addr_valid_o(triang_inv_mat_row_addr_valid_o),
  .inv_col_o(triang_inv_inv_col_o), // {b1,a1}
  .inv_col_addr_o(triang_inv_inv_col_addr_o),
  .inv_col_valid_o(triang_inv_inv_col_valid_o),
  .in_ready_o(triang_inv_in_ready_o),
  .flush_i(flush_i),
  .start(triang_inv_start),
  .out_ready_i(triang_inv_out_ready_i),
  .busy_o(triang_inv_busy_o)

);


endmodule