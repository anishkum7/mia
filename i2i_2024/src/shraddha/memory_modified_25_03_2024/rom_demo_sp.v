module rom_demo_sp (
  clk,
  reset_n,
  equal_out
);

parameter DATA_WIDTH = 16;
//parameter ADDR_WIDTH = 4; // This is dependent of the above parameter
parameter ROM_DEPTH  = 256;
parameter ADDR_WIDTH = $clog2(ROM_DEPTH);


input  clk;
input  reset_n;
reg    equal;
reg    [ADDR_WIDTH-1:0] addr;
reg    [DATA_WIDTH-1:0] dout;
reg    [DATA_WIDTH-1:0] dout_prev;
output equal_out;

// Instantiate ROM
//(* memory *) reg [DATA_WIDTH-1:0] rom [ROM_DEPTH-1:0] /* synthesis syn_preserve=1 syn_allow_dynamic_init=1 syn_romstyle = "block_ram" */;
reg [DATA_WIDTH-1:0] rom [ROM_DEPTH-1:0] /* synthesis syn_preserve=1 syn_allow_dynamic_init=1 */;

`include "force_signal_dumpvars_sprom.v"

initial
begin
//$readmemb("rom_init.dat", rom);
$readmemh("rom_init_hex.dat", rom);
end

always @ (posedge clk or negedge reset_n)
begin
  if (~reset_n)
  begin
    dout      <= {(DATA_WIDTH){1'b0}};
    dout_prev <= {(DATA_WIDTH){1'b0}};
    addr      <= {ADDR_WIDTH{1'b0}};
  end
  else
  begin
    addr      <= addr + 1;
    dout_prev <= dout;
    dout      <= rom[addr];
  end
end

always @ (posedge clk or negedge reset_n)
begin
  if (~reset_n)
  begin
    equal  <= 1'b0;
  end
  else
  begin
    if (dout == dout_prev)
      equal <= 1'b1;
    else
      equal <= 1'b0;
  end
end

assign equal_out = equal;

endmodule