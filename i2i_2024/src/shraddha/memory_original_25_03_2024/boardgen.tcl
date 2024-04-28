board_system_create -haps -name Test_board
board_system_create -add HAPS100_4F -name mb1

board_system_configure -top_io {mb1.A4 mb1.B4 mb1.A8 mb1.B8 mb1.A9 mb1.B9}
board_system_configure -voltage {mb1.A4 mb1.B4 mb1.A8 mb1.B8 mb1.A9 mb1.B9} 1.2

board_system_create -interconnect -manual CON_CABLE_50_HT3  -name mb1_B2A2 -connector {mb1.A2 mb1.B2}
board_system_create -interconnect -manual CON_CABLE_100_HT3 -name mb1_A3B3 -connector {mb1.A3 mb1.B3}
board_system_create -interconnect -manual CON_CABLE_100_HT3 -name conn_6 -connector {mb1.A7 mb1.B7}
board_system_create -interconnect -manual CON_CABLE_100_HT3 -name conn_7 -connector {mb1.B30 mb1.A12}
board_system_create -interconnect -manual CON_CABLE_100_HT3 -name conn_8 -connector {mb1.B6 mb1.A11}
board_system_create -interconnect -manual CON_CABLE_100_HT3 -name conn_9 -connector {mb1.B1 mb1.A6}


board_system_configure -pll mb1.PLL1.CLK1 -frequency 20000 -name d_clk 
board_system_configure -clock {mb1.uA.CLK1} d_clk
board_system_configure -clock {mb1.uB.CLK1} d_clk
