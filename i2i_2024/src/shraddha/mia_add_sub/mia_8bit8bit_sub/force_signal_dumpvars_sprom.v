initial
begin
	 (* haps_force *) $dumpvars (1, rom_demo_sp.equal);

	 (* haps_force *) $dumpvars (1, rom_demo_sp.addr1);
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr2); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr3); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr4); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr5); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr6); //-------         
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr7); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.addr8); //-------
///*
//*/
	 (* haps_force *) $dumpvars (1, rom_demo_sp.dout1);
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout2); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout3); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout4); //-------
	 (* haps_force *) $dumpvars (1, rom_demo_sp.dout5);
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout6); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout7); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.dout8); //-------

//*/
	 (* haps_force *) $dumpvars (1, rom_demo_sp.dout1_prev);
         
         (* haps_force *) $dumpvars (1, rom_demo_sp.m0.a);
         (* haps_force *) $dumpvars (1, rom_demo_sp.m0.b);
         (* haps_force *) $dumpvars (1, rom_demo_sp.m0.c);
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a1); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a2); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a3); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a4); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a5); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a6); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a7); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a8); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a9); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a10); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a11); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a12); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a13); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a14); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a15); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m1.a16); //-------
/*
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a1); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a2); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a3); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a4); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a5); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a6); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a7); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a8); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a9); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a10); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a11); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a12); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a13); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a14); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a15); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a16); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a17); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a18); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a19); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a20); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a21); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a22); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a23); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a24); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a25); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a26); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a27); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a28); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a29); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a30); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a31); //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.m2.a32); //-------
*/
         (* haps_force *) $dumpvars (1, rom_demo_sp.output_of_add);
         (* haps_force *) $dumpvars (1, rom_demo_sp.output_of_add_5);
         (* haps_force *) $dumpvars (1, rom_demo_sp.output_of_add_8);  //-------
         (* haps_force *) $dumpvars (1, rom_demo_sp.rom_inst);
         
end
