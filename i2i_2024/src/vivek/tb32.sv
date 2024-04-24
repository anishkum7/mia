module tb32;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 4;

  logic                               clk_i;
  logic                               rst_ni;
  logic                              flush_i;

  logic [SIZE-1:0][2*64-1:0]         lu_mat_row_i; // {b1,a1}
  logic                              lu_mat_row_valid_i;
  logic [$clog2(SIZE)-1:0]           lu_mat_row_read_addr_i;
  logic [$clog2(SIZE)-1:0]           lu_mat_row_read_addr_o;
  logic                              lu_mat_row_read_addr_valid_o;
  
  logic [SIZE-1:0][2*64-1:0]         lu_mat_row_o; // {b1,a1}
  logic                              lu_mat_row_valid_o;
  logic [$clog2(SIZE)-1:0]           lu_mat_row_write_addr_o;
  logic                              lu_mat_row_out_ready_i;
  
  logic [SIZE-1:0][2*64-1:0]         lu_l_col_o; // {b1,a1}
  logic [SIZE-1:0][2*64-1:0]         lu_u_row_o; // {b1,a1}
  logic [$clog2(SIZE)-1:0]           lu_result_addr_o;
  logic                              lu_result_valid_o;
  logic                              lu_result_out_ready_i;

  logic                              lu_in_ready_o;
 
  logic                              lu_start;
  //input  logic                              out_ready_i,

  logic                              lu_busy_o;


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



logic                              complex_matrix_mul_in_valid_i;
logic                              complex_matrix_mul_in_ready_o;
logic [SIZE*NUM_OPERANDS-1:0][WIDTH-1:0] complex_matrix_mul_operands_i;
logic [2*SIZE-1:0][WIDTH-1:0]             complex_matrix_mul_result_o;
logic                              complex_matrix_mul_out_valid_o;
logic                              complex_matrix_mul_out_ready_i;
logic                              complex_matrix_mul_busy_o;

logic                              complex_add_in_valid_i;
logic                              complex_add_in_ready_o;
logic [NUM_OPERANDS-1:0][WIDTH-1:0] complex_add_operands_i;
logic [1:0][WIDTH-1:0]             complex_add_result_o;
logic                              complex_add_out_valid_o;
logic                              complex_add_out_ready_i;
logic                              complex_add_busy_o;



logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix0;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix1;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix2;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Matrix3;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L0;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L1;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L2;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] L3;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U0;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U1;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U2;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] U3;

logic [SIZE-1:0][SIZE*2*WIDTH-1:0] InvMatrix;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Linv;
logic [SIZE-1:0][SIZE*2*WIDTH-1:0] Uinv;

real product [SIZE-1:0][2*SIZE-1:0];

real expected_real, expected_imaginary;
real a,b,c,d;

initial begin
  $fsdbDumpvars;
  for (int i = 0; i < SIZE; i++) begin
    for (int j = 0; j < SIZE; j++) begin
      

        // Generate random real and imaginary parts
        a = $itor($urandom_range(0,2000));
        a = (a-1000)/100;

        b = $itor($urandom_range(0,2000));
        b = (a-1000)/100;

        // Make sure diagonal elements are non-zero
        if (i == j && a == 0)
          a = 1; // Set a non-zero value for the diagonal

        // Assign values to the matrix
        Matrix0[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
        Matrix0[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);

                // Generate random real and imaginary parts
        a = $itor($urandom_range(0,2000));
        a = (a-1000)/100;

        b = $itor($urandom_range(0,2000));
        b = (a-1000)/100;

        // Make sure diagonal elements are non-zero
        if (i == j && a == 0)
          a = 1; // Set a non-zero value for the diagonal

        // Assign values to the matrix
        Matrix1[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
        Matrix1[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);

                // Generate random real and imaginary parts
        a = $itor($urandom_range(0,2000));
        a = (a-1000)/100;

        b = $itor($urandom_range(0,2000));
        b = (a-1000)/100;

        // Make sure diagonal elements are non-zero
        if (i == j && a == 0)
          a = 1; // Set a non-zero value for the diagonal

        // Assign values to the matrix
        Matrix2[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
        Matrix2[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);

                // Generate random real and imaginary parts
        a = $itor($urandom_range(0,2000));
        a = (a-1000)/100;

        b = $itor($urandom_range(0,2000));
        b = (a-1000)/100;

        // Make sure diagonal elements are non-zero
        if (i == j && a == 0)
          a = 1; // Set a non-zero value for the diagonal

        // Assign values to the matrix
        Matrix3[i][j*2*WIDTH + WIDTH-1 -: WIDTH] = $realtobits(a);
        Matrix3[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH] = $realtobits(b);

    end
  end

  // $write("Input Matrix: \n\n");
  // for (int i=0; i<SIZE; i=i+1) begin
  //   for (int j=0; j<SIZE; j=j+1) begin
  //     a = $bitstoreal(Matrix[i][j*2*WIDTH + WIDTH-1 -: WIDTH]);
  //     b = $bitstoreal(Matrix[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
  //     $write("(%f + j%f)",a,b);
  //     if (j == SIZE-1) begin
  //       $write("\n");
  //     end
  //   end
  // end
end


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin

rst_ni = 0;
flush_i = 0;
lu_start = 0;
triang_inv_start = 0;

Matrix = Matrix0;

#35
lu_result_out_ready_i = 1;
lu_mat_row_out_ready_i = 1;
triang_inv_out_ready_i = 1;
complex_matrix_mul_out_ready_i = 1;
complex_add_out_ready_i = 1;

rst_ni = 1;

lu_start = 1;

#20
lu_start = 0;

wait(lu_in_ready_o == 1);

$display("LU 1 done");

//L0 = L;
U0 = U;

for (int i = 0; i < SIZE; i=i+1) begin
    for (int j = 0; j < SIZE; j=j+1) begin
      L0[i][j*2*WIDTH +: WIDTH] = L[j][i*2*WIDTH +: WIDTH];        
      L0[i][j*2*WIDTH+WIDTH +: WIDTH] = L[j][i*2*WIDTH+WIDTH +: WIDTH];
    end
end


Matrix = L;

#5

triang_inv_start = 1;

#20

triang_inv_start = 0;

wait(triang_inv_in_ready_o == 1);

$display("TRIANG INV 1 done");

Linv = InvMatrix;
Matrix = U;
rst_ni = 0;
#35
rst_ni = 1;
triang_inv_start = 1;

#20

triang_inv_start = 0;

wait(triang_inv_in_ready_o == 1);
$display("TRIANG INV 2 done");

Uinv = InvMatrix;

for (int i = 0; i < SIZE; i=i+1) begin
    for (int j = 0; j < SIZE; j=j+1) begin
        @ (posedge clk_i);
        for (int k = 0; k < SIZE; k=k+1) begin
        complex_matrix_mul_operands_i[k*NUM_OPERANDS] = Linv[i][k*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+1] = Linv[i][k*2*WIDTH+WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+2] = Matrix1[k][j*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+3] = Matrix1[k][j*2*WIDTH+WIDTH +: WIDTH];;  
        end
        U1[i][j*2*WIDTH +: 2*WIDTH] = complex_matrix_mul_result_o;
    end
end

for (int i = 0; i < SIZE; i=i+1) begin
    for (int j = 0; j < SIZE; j=j+1) begin
        @ (posedge clk_i);
        for (int k = 0; k < SIZE; k=k+1) begin
        complex_matrix_mul_operands_i[k*NUM_OPERANDS] = Matrix2[i][k*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+1] = Matrix2[i][k*2*WIDTH+WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+2] = Uinv[j][k*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+3] = Uinv[j][k*2*WIDTH+WIDTH +: WIDTH];;  
        end
        L2[i][j*2*WIDTH +: 2*WIDTH] = complex_matrix_mul_result_o;
    end
end

for (int i = 0; i < SIZE; i=i+1) begin
    for (int j = 0; j < SIZE; j=j+1) begin
        @ (posedge clk_i);
        for (int k = 0; k < SIZE; k=k+1) begin
        complex_matrix_mul_operands_i[k*NUM_OPERANDS] = L2[i][k*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+1] = L2[i][k*2*WIDTH+WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+2] = U1[k][j*2*WIDTH +: WIDTH];
        complex_matrix_mul_operands_i[k*NUM_OPERANDS+3] = U1[k][j*2*WIDTH+WIDTH +: WIDTH];;  
        end
        complex_add_operands_i = {complex_matrix_mul_result_o, Matrix3[i][j*2*WIDTH +: 2*WIDTH]};
        Matrix3[i][j*2*WIDTH +: 2*WIDTH] = complex_add_result_o;
    end
end
Matrix = Matrix3;

 $display("lu_ready = %d", lu_in_ready_o);
rst_ni = 0;
#35
rst_ni = 1;
lu_start = 1;

#20
lu_start = 0;
$display("lu_ready = %d", lu_in_ready_o);

wait(lu_in_ready_o == 1);
//#1000

$display("lu_ready = %d", lu_in_ready_o);

$display("LU 2 done");

U3 = U;

for (int i = 0; i < SIZE; i=i+1) begin
    for (int j = 0; j < SIZE; j=j+1) begin
      L3[i][j*2*WIDTH +: WIDTH] = L[j][i*2*WIDTH +: WIDTH];        
      L3[i][j*2*WIDTH+WIDTH +: WIDTH] = L[j][i*2*WIDTH+WIDTH +: WIDTH];
    end
end


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

// $write("Output U Matrix: \n\n");

// for (int i=0; i<SIZE; i=i+1) begin
//   for (int j=0; j<SIZE; j=j+1) begin
//     a = $bitstoreal(U[i][j*2*WIDTH + WIDTH-1 -: WIDTH]);
//     b = $bitstoreal(U[i][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
//     $write("(%f + j%f)",a,b);
//     if (j == SIZE-1) begin
//       $write("\n");
//     end
//   end
// end

// for (int i=0; i<SIZE; i=i+1) begin
//   for (int j=0; j<SIZE; j=j+1) begin
//     product[i][2*j] = 0;
//     product[i][2*j+1] = 0;
//     for (int k=0; k<SIZE; k=k+1) begin
//       a = $bitstoreal(L[k][i*2*WIDTH + WIDTH-1 -: WIDTH]);
//       b = $bitstoreal(L[k][i*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
//       c = $bitstoreal(U[k][j*2*WIDTH + WIDTH-1 -: WIDTH]);
//       d = $bitstoreal(U[k][j*2*WIDTH + 2*WIDTH-1 -: WIDTH]);
//       product[i][2*j] += a*c - b*d;
//       product[i][2*j+1] += a*d + b*c;
//     end
//   end
// end

// $write("Product: \n\n");
// for (int i=0; i<SIZE; i=i+1) begin
//   for (int j=0; j<SIZE; j=j+1) begin
//     a = product[i][2*j];
//     b = product[i][2*j+1];
//     $write("(%f + j%f)",a,b);
//     if (j == SIZE-1) begin
//       $write("\n");
//     end
//   end
// end

#20
$finish;
end

initial begin
#100000
for (int i=0; i<SIZE; i=i+1) begin
  $display("%x",Matrix3[i]);
end
$finish;
end

always @ (posedge clk_i) begin
  
  // if (lu_in_ready_o)
  //   $display("lu_ready = %d", lu_in_ready_o);

  lu_mat_row_i <= Matrix[lu_mat_row_read_addr_o];
  lu_mat_row_read_addr_i <= lu_mat_row_read_addr_o;
  lu_mat_row_valid_i <= lu_mat_row_read_addr_valid_o;

  if (lu_mat_row_valid_o) begin
    Matrix[lu_mat_row_write_addr_o] <= lu_mat_row_o;
  end
  if (lu_result_valid_o) begin
    L[lu_result_addr_o] <= lu_l_col_o;
    U[lu_result_addr_o] <= lu_u_row_o;
  end


  triang_inv_mat_row_i <= Matrix[triang_inv_mat_row_addr_o];
  triang_inv_mat_row_addr_i <= triang_inv_mat_row_addr_o;
  triang_inv_mat_row_valid_i <= triang_inv_mat_row_addr_valid_o;

  if (triang_inv_inv_col_valid_o) begin
    InvMatrix[triang_inv_inv_col_addr_o] <= triang_inv_inv_col_o;
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

  .mat_row_i(lu_mat_row_i), // {b1,a1}
  .mat_row_valid_i(lu_mat_row_valid_i),
  .mat_row_read_addr_i(lu_mat_row_read_addr_i),
  .mat_row_read_addr_o(lu_mat_row_read_addr_o),
  .mat_row_read_addr_valid_o(lu_mat_row_read_addr_valid_o),
  
  .mat_row_o(lu_mat_row_o), // {b1,a1}
  .mat_row_valid_o(lu_mat_row_valid_o),
  .mat_row_write_addr_o(lu_mat_row_write_addr_o),
  .mat_row_out_ready_i(lu_mat_row_out_ready_i),
  
  .l_col_o(lu_l_col_o), // {b1,a1}
  .u_row_o(lu_u_row_o), // {b1,a1}
  .result_addr_o(lu_result_addr_o),
  .result_valid_o(lu_result_valid_o),
  .result_out_ready_i(lu_result_out_ready_i),

  .in_ready_o(lu_in_ready_o),
  .flush_i(flush_i),
  .start(lu_start),
  //input  logic                              out_ready_i,

  .busy_o(lu_busy_o)

);

triang_matrix_inv
#(
  .SIZE(SIZE)
 )
triang_matrix_inv
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

complex_matrix_mul 
#(
  .SIZE(SIZE)
)
complex_matrix_mul
(
.clk_i(clk_i),
.rst_ni(rst_ni),
.in_valid_i(1'b1),
.in_ready_o(complex_matrix_mul_in_ready_o),
.flush_i(flush_i),
.operands_i(complex_matrix_mul_operands_i),
.result_o(complex_matrix_mul_result_o),
//.sub(sub),
.out_valid_o(complex_matrix_mul_out_valid_o),
.out_ready_i(complex_matrix_mul_out_ready_i),
.busy_o(complex_matrix_mul_busy_o)

);


complex_add
complex_add
(
.clk_i(clk_i),
.rst_ni(rst_ni),
.operands_i(complex_add_operands_i), // {b2,a2,b1,a1}
.in_valid_i(1'b1),
.in_ready_o(complex_add_in_ready_o),
.flush_i(flush_i),
.sub(1'b1),
.result_o(complex_add_result_o),
.out_valid_o(complex_add_out_valid_o),
.out_ready_i(1'b1),
.busy_o(complex_add_busy_o)
);



endmodule