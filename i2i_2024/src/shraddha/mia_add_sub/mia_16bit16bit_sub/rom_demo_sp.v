module rom_demo_sp (
  clk,
  reset_n,
  equal_out
);

parameter DATA_WIDTH = 32; //for rom
//parameter DATA_WIDTH_CO = 256;//
//parameter ADDR_WIDTH = 4; // This is dependent of the above parameter
parameter ROM_DEPTH  = 256;
parameter ADDR_WIDTH = $clog2(ROM_DEPTH);


input  clk;
input  reset_n;

reg    equal;

reg    [ADDR_WIDTH-1:0] addr1;
reg    [ADDR_WIDTH-1:0] addr2; //---------------
reg    [ADDR_WIDTH-1:0] addr3; //---------------
reg    [ADDR_WIDTH-1:0] addr4; //---------------
reg    [ADDR_WIDTH-1:0] addr5; //---------------
reg    [ADDR_WIDTH-1:0] addr6; //---------------
reg    [ADDR_WIDTH-1:0] addr7; //---------------
reg    [ADDR_WIDTH-1:0] addr8; //---------------

reg    [ADDR_WIDTH-1:0] addr9; //---------------
reg    [ADDR_WIDTH-1:0] addr10; //---------------
reg    [ADDR_WIDTH-1:0] addr11; //---------------
reg    [ADDR_WIDTH-1:0] addr12; //---------------
reg    [ADDR_WIDTH-1:0] addr13; //---------------
reg    [ADDR_WIDTH-1:0] addr14; //---------------
reg    [ADDR_WIDTH-1:0] addr15; //---------------
reg    [ADDR_WIDTH-1:0] addr16; //---------------

reg    [DATA_WIDTH-1:0] dout1;
reg    [DATA_WIDTH-1:0] dout2; //---------------
reg    [DATA_WIDTH-1:0] dout3; //---------------
reg    [DATA_WIDTH-1:0] dout4; //---------------
reg    [DATA_WIDTH-1:0] dout5; //---------------
reg    [DATA_WIDTH-1:0] dout6; //---------------
reg    [DATA_WIDTH-1:0] dout7; //---------------
reg    [DATA_WIDTH-1:0] dout8; //---------------

reg    [DATA_WIDTH-1:0] dout9; //---------------
reg    [DATA_WIDTH-1:0] dout10; //---------------
reg    [DATA_WIDTH-1:0] dout11; //---------------
reg    [DATA_WIDTH-1:0] dout12; //---------------
reg    [DATA_WIDTH-1:0] dout13; //---------------
reg    [DATA_WIDTH-1:0] dout14; //---------------
reg    [DATA_WIDTH-1:0] dout15; //---------------
reg    [DATA_WIDTH-1:0] dout16; //---------------

reg    [DATA_WIDTH-1:0] dout1_prev;
output equal_out;
reg    [DATA_WIDTH-1:0] output_of_add;
reg    [79:0] output_of_add_5;
reg    [8*DATA_WIDTH-1:0] output_of_add_16; //---------------
reg    [DATA_WIDTH-1:0] rom_inst;

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
    dout1       <= {(DATA_WIDTH){1'b0}};
    dout2       <= {(DATA_WIDTH){1'b0}}; //---------------
    dout3       <= {(DATA_WIDTH){1'b0}}; //---------------
    dout4       <= {(DATA_WIDTH){1'b0}}; //---------------
    dout5       <= {(DATA_WIDTH){1'b0}};
    dout6       <= {(DATA_WIDTH){1'b0}}; //---------------
    dout7       <= {(DATA_WIDTH){1'b0}}; //---------------
    dout8       <= {(DATA_WIDTH){1'b0}}; //---------------

    dout9       <= {(DATA_WIDTH){1'b0}};
    dout10      <= {(DATA_WIDTH){1'b0}}; //---------------
    dout11      <= {(DATA_WIDTH){1'b0}}; //---------------
    dout12      <= {(DATA_WIDTH){1'b0}}; //---------------
    dout13      <= {(DATA_WIDTH){1'b0}};
    dout14      <= {(DATA_WIDTH){1'b0}}; //---------------
    dout15      <= {(DATA_WIDTH){1'b0}}; //---------------
    dout16      <= {(DATA_WIDTH){1'b0}}; //---------------

    dout1_prev <= {(DATA_WIDTH){1'b0}};
    
    addr1       <= {ADDR_WIDTH{1'b0}};
    addr2       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr3       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr4       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr5       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr6       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr7       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr8       <= {ADDR_WIDTH{1'b0}}; //---------------

    addr9       <= {ADDR_WIDTH{1'b0}}; //---------------
    addr10      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr11      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr12      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr13      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr14      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr15      <= {ADDR_WIDTH{1'b0}}; //---------------
    addr16      <= {ADDR_WIDTH{1'b0}}; //---------------

  end
  else 
  begin  
      addr1      <= addr1 + 1;
      dout1_prev <= dout1;
      
      addr2      <= addr1 + 1; //---------------
      addr3      <= addr1 + 2; //---------------
      addr4      <= addr1 + 3; //---------------
      addr5      <= addr1 + 4; //---------------
      addr6      <= addr1 + 5; //---------------
      addr7      <= addr1 + 6; //---------------
      addr8      <= addr1 + 7; //---------------

      addr9      <= addr1 + 8; //---------------
      addr10     <= addr1 + 9; //---------------
      addr11     <= addr1 + 10; //---------------
      addr12     <= addr1 + 11; //---------------
      addr13     <= addr1 + 12; //---------------
      addr14     <= addr1 + 13; //---------------
      addr15     <= addr1 + 14; //---------------
      addr16     <= addr1 + 15; //---------------
      
      dout16     <= rom[addr16];
      dout15     <= rom[addr15];
      dout14     <= rom[addr14];
      dout13     <= rom[addr13];
      dout12     <= rom[addr12];
      dout11     <= rom[addr11];
      dout10     <= rom[addr10];
      dout9      <= rom[addr9];
      dout8      <= rom[addr8];
      dout7      <= rom[addr7];
      dout6      <= rom[addr6];
      dout5      <= rom[addr5];
      dout4      <= rom[addr4]; //---------------
      dout3      <= rom[addr3]; //---------------
      dout2      <= rom[addr2]; //---------------
      dout1      <= rom[addr1];

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
      if (dout1 == dout1_prev)
        equal <= 1'b1;
      else
        equal <= 1'b0;

      //if (dout2 == dout2_prev)
        //equal <= 1'b1;
      //else
        //equal <= 1'b0;
    end
end

assign equal_out = equal;
assign rom_inst = rom[1]; 
matrix_add m0 (.a(dout1[31:16]), .b(dout1[15:0]), .c(output_of_add));
/*matrix_add_5 m (.a1(dout1[31:16]),
                 .a2(dout1[15:0]),
                 .a3(dout2[31:16]),
                 .a4(dout2[15:0]),
                 .a5(dout3[31:16]),
                 .a6(dout3[15:0]),
                 .a7(dout4[31:16]),
                 .a8(dout4[15:0]),
                 .a9(dout5[15:0]),
                 .a10(dout5[15:0]),
                 .out(output_of_add_5));
*/
matrix_add_16 m1 (.a1(dout1[31:16]),
                 .a2(dout1[15:0]),
                 .a3(dout2[31:16]),
                 .a4(dout2[15:0]),
                 .a5(dout3[31:16]),
                 .a6(dout3[15:0]),
                 .a7(dout4[31:16]),
                 .a8(dout4[15:0]),
                 .a9(dout5[31:16]),
                 .a10(dout5[15:0]),
		 .a11(dout6[31:16]),
                 .a12(dout6[15:0]),
                 .a13(dout7[31:16]),
                 .a14(dout7[15:0]),
                 .a15(dout8[31:16]),
                 .a16(dout8[15:0]),
                 .a17(dout9[31:16]),
                 .a18(dout9[15:0]),
                 .a19(dout10[31:16]),
                 .a20(dout10[15:0]),
                 .a21(dout11[31:16]),
                 .a22(dout11[15:0]),
                 .a23(dout12[31:16]),
                 .a24(dout12[15:0]),
                 .a25(dout13[31:16]),
                 .a26(dout13[15:0]),
                 .a27(dout14[31:16]),
                 .a28(dout14[15:0]),
                 .a29(dout15[31:16]),
                 .a30(dout15[15:0]),
                 .a31(dout16[31:16]),
                 .a32(dout16[15:0]),
                 .out(output_of_add_16)); //---------------  

endmodule
