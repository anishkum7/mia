#!/bin/sh
#mkdir -p work
##CC $VCS_HOME/bin/
vlogan -full64 -work work -f add_files_rom_demo.f -override_timescale=1ns/10ps -debug_acc+all
##CC $VCS_HOME/bin/
vcs -full64 -top work.rom_demo_sp -hw_top=rom_demo_sp
