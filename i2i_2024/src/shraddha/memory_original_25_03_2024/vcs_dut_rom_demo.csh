#!/bin/sh
#mkdir -p work
$VCS_HOME/bin/vlogan -full64 -work work -f add_files_rom_demo.f -override_timescale=1ns/10ps -debug_acc+all
$VCS_HOME/bin/vcs -full64 -top work.cnt_demo_top -hw_top=cnt_demo_top  
