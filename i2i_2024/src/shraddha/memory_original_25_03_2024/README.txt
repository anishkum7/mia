INSTRUCTIONS

Design cnt_demo_top (cnt_demo_top.v) with instance u_rom_demo_1 of module rom_demo (rom_demo.v), implements a
single dual-port ROM (by default set at 256 words of 16 bits each), initialized with the contents of rom_init_hex.dat.
The flow implements backdoor write access to the ROM, allowing the user to overwrite its contents.
The runtime script provided shows how to access the ROM contents.

Compile
1. % mkdir <IMPLEMENTATION_SUB_DIRECTORY>
2. % cd <IMPLEMENTATION_SUB_DIRECTORY>
3. % ln -s ../rom_init_hex.dat .
4. % protocompiler100 -batch -tcl ../run_protocompiler_rom_demo.tcl

Runtime (on runtime host)
1. Program HAPS-100 System with results from <IMPLEMENTATION_SUB_DIRECTORY>/export_results
2. % cd <IMPLEMENTATION_SUB_DIRECTORY>
3. % confprosh ../dynamic_rom_sp.tcl
