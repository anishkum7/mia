initial
begin
	 (* haps_force *) $dumpvars (1, u_cnt_demo_inst1.capture_cnt[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_demo_inst1.capture_cnt_dly[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_demo_inst4.capture_cnt[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_demo_inst4.capture_cnt_dly[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_end_check1.cnt_dly_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_end_check1.cnt_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_end_check2.cnt_dly_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_end_check2.cnt_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_start_check1.cnt_dly_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_start_check1.cnt_reg[15:0]);
	 (* haps_force *) $dumpvars (1, u_cnt_start_check2.cnt_dly_reg[15:0]);
	 (* haps_force *) $dumpvars (1, reset_n);
	 (* haps_force *) $dumpvars (1, reset_n1);
	 (* haps_force *) $dumpvars (1, reset_n2);
	 (* haps_force *) $dumpvars (1, reset_n3);
	 (* haps_force *) $dumpvars (1, reset_n4);
`ifdef ROM_DEMO
	 (* haps_force *) $dumpvars (1, u_rom_demo_1.equal);
	 (* haps_force *) $dumpvars (1, u_rom_demo_1.addr);
	 (* haps_force *) $dumpvars (1, u_rom_demo_1.addrp1);
	 (* haps_force *) $dumpvars (1, u_rom_demo_1.dout);
	 (* haps_force *) $dumpvars (1, u_rom_demo_1.dout1);
`endif
end
