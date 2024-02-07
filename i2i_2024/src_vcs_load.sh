#!/usr/bin/env bash
# This script was generated automatically by bender.
ROOT="/home/ecegrid/a/595m04/i2i_2024_mia/mia/i2i_2024/src"

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/add.sv"\
    "$ROOT/tb.sv" 
