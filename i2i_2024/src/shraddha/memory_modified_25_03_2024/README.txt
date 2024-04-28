Design rom_demo_sp (rom_demo_sp.v) with instance u_rom_demo_1 of module rom_demo (rom_demo.v), implements a
single dual-port ROM (by default set at 256 words of 16 bits each), initialized with the contents of rom_init_hex.dat.
The flow implements backdoor write access to the ROM, allowing the user to overwrite its contents.
The runtime script provided shows how to access the ROM contents.


Versions used:  ProtoCompiler 2023.12
                VCS 2023.03-SP2
                Vivado 2022.1-ep11

 
Steps to run on host machine:

1. cd <path to your directory where the design was unzipped>
1. mkdir implementation_dir
2. cd implementation_dir
3. ln -s ../rom_init_hex.dat .
4. protocompiler100 -batch -tcl ../run_protocompiler_rom_demo.tcl
5. % confprosh
6. % cfg_scan
7. % set handle [cfg_open mod-E021929]
8. % cfg_project_configure $handle export_results/system/targetsystem.tsd
9. % cfg_reset_set $handle FB1.uA 0
10. % cfg_reset_set $handle FB1.uA 1
11. % source ../dynamic_rom_sp.tcl
