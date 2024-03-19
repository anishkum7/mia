module tb_matrix;

localparam NUM_OPERANDS=4,
            WIDTH = 64,
            SIZE = 8;

logic                               clk_i;
logic                               rst_ni;
  // Input signals

  // Input Handshake
logic                              in_valid_i;
logic                              in_ready_o;
logic                              flush_i;
logic [SIZE*NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
  // Output signals
logic [2*SIZE-1:0][WIDTH-1:0]             result_o;
fpnew_pkg::status_t                status_o;
logic                             tag_o;
  // Output handshake
logic                              out_valid_o;
logic                              out_ready_i;
  // Indication of valid data in flight
logic                              busy_o;

logic                              sub;


logic [SIZE-1:0][WIDTH-1:0] Vector1real, Vector1imaginary;
logic [SIZE-1:0][WIDTH-1:0] Vector2real, Vector2imaginary;

// assign Vector1real = {{64'hc047ef63a5098d94}, {64'hc0504781e9169f54}, {64'hc04e5d5922eddbe5}, {64'hc03471030ff2ced8}, {64'hc057ecc7f42a3da7}, {64'hc051504145614902}, {64'hc0411ebd7d8feef8}, {64'h4052e6a81ef40d78}, {64'h405517e19a268d3c}, {64'hc04cecd374a73a1a}, {64'hc055a82ea86cc3a0}, {64'h40327c746f14f254}, {64'h4045ae1d303a45e8}, {64'hc057df8e7ffb04ff}, {64'hc057cbb4ccd77053}, {64'h4044eb83d3ff349c}};
// assign Vector1imaginary = {{64'h404874349458f250}, {64'h402c2340d0a9aa18}, {64'h4058799d16f1c09a}, {64'hc050231782626ece}, {64'hc04b8df5693fe993}, {64'hc050989674023f6c}, {64'hc03538aa1c822b4c}, {64'h4051e396aca9e00c}, {64'h405464efaa742302}, {64'h4042477816b10e10}, {64'h4057243e7726735e}, {64'hc050246a182de949}, {64'hc0526e25a1a83522}, {64'hbff0cf675c5a0c00}, {64'h4034f881b5fdbf80}, {64'h400126cdae99d080}};
// assign Vector2real = {{64'h402b40c7b1470090}, {64'hc01bf86866c8deb0}, {64'hc035f16de840ed0c}, {64'hc04fafe314a4d9f5}, {64'hc05760eb82e9b0e0}, {64'hc04d4e2c5a29c3db}, {64'h4055c5cf242992f6}, {64'hc032487979110098}, {64'h4039563db4b401f8}, {64'h4039b9b9a0906cd4}, {64'hc037b918c1d99528}, {64'h40054f3157765480}, {64'h4058747a6ed419c2}, {64'hbfee8a0bae692980}, {64'hc03c5bbc6f655aec}, {64'hc0554d5cb2cc141d}};
// assign Vector2imaginary = {{64'hc0554086e272811a}, {64'h405372a4015ea43e}, {64'h4049d0d943003c5c}, {64'hc040d607d2366e5e}, {64'hc01e89339be57590}, {64'h4043cb45c198e79c}, {64'hc0369013e9261e28}, {64'hc04bc3ca2d3d1d92}, {64'hc03202bb724a3b2c}, {64'h4044d82702477df0}, {64'hc04e639dabc90e08}, {64'h404186a78538af88}, {64'h4052c949a13dd494}, {64'h40571615914189d8}, {64'h404d3d7ce38ad988}, {64'hc046408306d797f4}};

real expected_real, expected_imaginary;
real a,b,c,d;

initial begin
  expected_real = 0;
  expected_imaginary = 0;
  
  for (int i=0; i<SIZE; i=i+1) begin
    a = $itor($urandom_range(0,2000));
    a = (a-1000)/100;
    Vector1real[i] = $realtobits(a);

    b = $itor($urandom_range(0,2000));
    b = (b-1000)/100;
    Vector1imaginary[i] = $realtobits(b);

    c = $itor($urandom_range(0,2000));
    c = (c-1000)/100;
    Vector2real[i] = $realtobits(c);

    d = $itor($urandom_range(0,2000));
    d = (d-1000)/100;
    Vector2imaginary[i] = $realtobits(d);            

    expected_real = expected_real + (a*c - b*d);
    expected_imaginary = expected_imaginary + (a*d + b*c);
  end
end


initial clk_i = 0;
always #5 clk_i = ~clk_i;

initial begin
sub = 1;
rst_ni = 0;
in_valid_i = 0;
out_ready_i = 0;

for (int i=0; i<SIZE; i=i+1) begin
  // operands_i[i*NUM_OPERANDS] = 64'h401c000000000000;
  // operands_i[i*NUM_OPERANDS+1] = 64'h4000000000000000;
  // operands_i[i*NUM_OPERANDS+2] = 64'h3ff0000000000000;
  // operands_i[i*NUM_OPERANDS+3] = 64'h4000000000000000;
  operands_i[i*NUM_OPERANDS] = Vector1real[i];
  operands_i[i*NUM_OPERANDS+1] = Vector1imaginary[i];
  operands_i[i*NUM_OPERANDS+2] = Vector2real[i];
  operands_i[i*NUM_OPERANDS+3] = Vector2imaginary[i];
end

flush_i = 0;
#35
rst_ni = 1;
in_valid_i = 1;
out_ready_i = 1;
wait(out_valid_o == 1'b1);
@(negedge clk_i);
for (int i=0; i<SIZE; i=i+1) begin
  $display("Expected Answer %d : %f  %f", i, expected_imaginary, expected_real);
  $display("Answer %d : %f  %f", i, $bitstoreal(result_o[2*i+1]), $bitstoreal(result_o[2*i]));
end
#1000
$finish;
end


complex_matrix_mul 
#(
  .SIZE(SIZE)
)
DUT
(
.clk_i(clk_i),
.rst_ni(rst_ni),
.in_valid_i(in_valid_i),
.in_ready_o(in_ready_o),
.flush_i(flush_i),
.operands_i(operands_i),
.result_o(result_o),
//.status_o(status_o),
//.tag_o(tag_o),
//.sub(sub),
.out_valid_o(out_valid_o),
.out_ready_i(out_ready_i),
.busy_o(busy_o)

);


endmodule