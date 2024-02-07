#!/usr/bin/env bash
# This script was generated automatically by bender.
ROOT="/home/ecegrid/a/595m04/i2i_2024_mia/mia/i2i_2024/cvfpu"

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/clk_rst_gen.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_stream_mst.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_synch_holdable_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_verif_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/signal_highlighter.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/sim_timeout.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/stream_watchdog.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_synch_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-6276fc54dbc1a950/src/rand_stream_slv.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/rtl/tc_sram.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/rtl/tc_sram_impl.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/rtl/tc_clk.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/cluster_pwr_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/generic_memory.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/generic_rom.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/pad_functional.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/pulp_buffer.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/pulp_pwr_cells.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/tc_pwr.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/pulp_clock_gating_async.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/cluster_clk_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-00bf70459055a6f8/src/deprecated/pulp_clk_cells.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/binary_to_gray.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cb_filter_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cc_onehot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_reset_ctrlr_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cf_math_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/clk_int_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/delta_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/ecc_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/edge_propagator_tx.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/exp_backoff.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/fifo_v3.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/gray_to_binary.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/isochronous_4phase_handshake.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/isochronous_spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/lfsr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/lfsr_16bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/lfsr_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/lossy_valid_to_stream.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/mv_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/onehot_to_bin.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/plru_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/popcount.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/rr_arb_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/rstgen_bypass.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/serial_deglitch.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/shift_reg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/shift_reg_gated.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/spill_register_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_demux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_fork.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_intf.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_join_dynamic.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_mux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_throttle.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/sub_per_hash.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/unread.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/read.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/addr_decode_dync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_4phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/clk_int_div_static.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/addr_decode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/addr_decode_napot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/multiaddr_decode.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cb_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_fifo_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/clk_mux_glitch_free.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/ecc_decode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/ecc_encode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/edge_detect.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/lzc.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/max_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/rstgen.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_delay.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_fork_dynamic.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_join.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_reset_ctrlr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_fifo_gray.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/fall_through_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_to_mem.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_arbiter_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_fifo_optimal_wrap.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_xbar.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_fifo_gray_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/cdc_2phase_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/mem_to_banks_detailed.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_arbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/stream_omega_net.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/mem_to_banks.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/sram.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/clock_divider_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/clk_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/find_first_one.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/generic_LFSR_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/generic_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/prioarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/pulp_sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/pulp_sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/rrarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/clock_divider.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/fifo_v2.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/deprecated/fifo_v1.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/edge_propagator_ack.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/edge_propagator.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/src/edge_propagator_rx.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/defs_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/iteration_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/control_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/norm_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/preprocess_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/nrbd_nrsc_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/div_sqrt_top_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-d6857c0cc6d539fe/hdl/div_sqrt_mvp_wrapper.sv" 

vlogan -sverilog -kdb \
    -full64 \
    +define+TARGET_SIMULATION \
    +define+TARGET_VCS \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-6d00fdd50c9845a9/include" \
    "$ROOT/src/fpnew_pkg.sv" \
    "$ROOT/src/fpnew_cast_multi.sv" \
    "$ROOT/src/fpnew_classifier.sv" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/clk/rtl/gated_clk_cell.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ctrl.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ff1.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_pack_single.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_prepare.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_round_single.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_special.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_srt_single.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_top.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_dp.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_frbus.v" \
    "$ROOT/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_src_type.v" \
    "$ROOT/src/fpnew_divsqrt_th_32.sv" \
    "$ROOT/src/fpnew_divsqrt_multi.sv" \
    "$ROOT/src/fpnew_fma.sv" \
    "$ROOT/src/fpnew_fma_multi.sv" \
    "$ROOT/src/fpnew_noncomp.sv" \
    "$ROOT/src/fpnew_opgroup_block.sv" \
    "$ROOT/src/fpnew_opgroup_fmt_slice.sv" \
    "$ROOT/src/fpnew_opgroup_multifmt_slice.sv" \
    "$ROOT/src/fpnew_rounding.sv" \
    "$ROOT/src/fpnew_top.sv"
