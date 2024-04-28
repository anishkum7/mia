`timescale 1ns/1ns
//`define USER_DTD_RESET 
//`define CLK_CNTRL_ENBL

module cnt_demo_top (
                     osc,
                     reset_n,
                     reset_n1,
                     reset_n2,
                     reset_n3,
                     reset_n4,
                     reset_n5,
                     reset_n6,
                     reset_n7,
                     reset_n8,
 //                    trigger_in,
`ifdef USER_DTD_RESET
                     dtd2_reset_global_in,
                     dtd2_reset_global_out,
`endif
                     gpio_1,
                     gpio_2,
                     gpio_3,
                     gpio_4,
                     gpio_5,
                     gpio_6,
                     gpio_7,
                     gpio_8,
                     gpio_9,
                     gpio_10,
                     gpio_11,
                     gpio_12,
                     gpio_13,
                     gpio_14,
                     gpio_15,
                     gpio_16,
                     gpio_17,
                     gpio_18,
                     gpio_19,
                     gpio_20,
                     gpio_21,
                     gpio_22,
                     gpio_23,
                     gpio_24, 
                     count_start1, count_start2,
                     count_end1, count_end2
                     );

    parameter USERBIT_WIDTH        = 32; // PZ counter bitwidth
    parameter EXTRA_CNT            = 28; // No. of extra instances of PZ counter.
    parameter SMPL_CLK_RATIO_INST1 = 14; // Number to divide the osc_ext to derive the sampling clock
    parameter SMPL_CLK_RATIO_INST2 = 14; // Number to divide the osc_ext to derive the sampling clock
    parameter SAMPLE_DEPTH         = 268435458; //134217728;//5000000; // Total number of samples to be captured 
    parameter TRIGER_POSITION      = 1071241827; // Posion to mimic the hardware trigger position.
	output count_start1, count_start2, count_end1, count_end2;
    input osc;
    input reset_n;
    input reset_n1, reset_n2, reset_n3, reset_n4, reset_n5, reset_n6, reset_n7, reset_n8;
//    input trigger_in; 
`ifdef USER_DTD_RESET
    input dtd2_reset_global_in;
  
    output dtd2_reset_global_out;
`endif
    output gpio_1;
    output gpio_2;
    output gpio_3;
    output gpio_4;
    output gpio_5;
    output gpio_6;
    output gpio_7;
    output gpio_8;
    output gpio_9;
    output gpio_10;
    output gpio_11;
    output gpio_12;
    output gpio_13;
    output gpio_14;
    output gpio_15;
    output gpio_16;
    output gpio_17;
    output gpio_18;
    output gpio_19;
    output gpio_20;
    output gpio_21;
    output gpio_22;
    output gpio_23;
    output gpio_24;

 reg sync_reset ;

    wire [15:0] cnt_reg1, cnt_reg2, cnt_reg3, cnt_reg4, cnt_reg5, cnt_reg6, cnt_reg7, cnt_reg8;
    wire [15:0] cnt_dly_reg1, cnt_dly_reg2, cnt_dly_reg3, cnt_dly_reg4, cnt_dly_reg5, cnt_dly_reg6, cnt_dly_reg7, cnt_dly_reg8;


`include "force_signal_dumpvars_sprom.v"

`ifdef USER_DTD_RESET
dtd2_reset dtd2reset (.dtd2_reset_global_in(dtd2_reset_global_in),
                      .dtd2_reset_global_out(dtd2_reset_global_out),
                      .mstr_resetN(reset_n),
                      .sampleclock(osc),
                      .dtd2_reset_local(sync_reset));
`else
assign sync_reset = ~reset_n;
`endif

cnt_demo  #(.USERBIT_WIDTH(USERBIT_WIDTH),
            .EXTRA_CNT(EXTRA_CNT),
            .SMPL_CLK_RATIO(SMPL_CLK_RATIO_INST1),
            .SAMPLE_DEPTH(SAMPLE_DEPTH),
            .TRIGER_POSITION(TRIGER_POSITION)) u_cnt_demo_inst1
                           (
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk0),
                            `else
                            .osc_ext(osc), 
                            `endif 
                            .reset_n(~sync_reset),
                            .hundred(gpio_1),
			    .cnt_out (cnt_reg1),
			    .cnt_dly_out (cnt_dly_reg1),
                            .one_fifty(gpio_2),
                            .toggle(gpio_3));
                            
cnt_demo #(.USERBIT_WIDTH(USERBIT_WIDTH),
             .EXTRA_CNT(EXTRA_CNT),
             .SMPL_CLK_RATIO(SMPL_CLK_RATIO_INST2),
             .SAMPLE_DEPTH(SAMPLE_DEPTH),
             .TRIGER_POSITION(TRIGER_POSITION)) u_cnt_demo_inst2 
                           (
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk1),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(reset_n1),
			    .cnt_out (cnt_reg2),
			    .cnt_dly_out (cnt_dly_reg2),
                            .hundred(gpio_4),
                            .one_fifty(gpio_5),
                            .toggle(gpio_6));

cnt_demo #(.USERBIT_WIDTH(USERBIT_WIDTH),
             .EXTRA_CNT(EXTRA_CNT),
             .SMPL_CLK_RATIO(SMPL_CLK_RATIO_INST1),
             .SAMPLE_DEPTH(SAMPLE_DEPTH),
             .TRIGER_POSITION(TRIGER_POSITION)) u_cnt_demo_inst3
                           (
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk2),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(reset_n2),
			    .cnt_out (cnt_reg3),
			    .cnt_dly_out (cnt_dly_reg3),
                            .hundred(gpio_7),
                            .one_fifty(gpio_8),
                            .toggle(gpio_9));

cnt_demo #(.USERBIT_WIDTH(USERBIT_WIDTH),
             .EXTRA_CNT(EXTRA_CNT),
             .SMPL_CLK_RATIO(SMPL_CLK_RATIO_INST2),
             .SAMPLE_DEPTH(SAMPLE_DEPTH),
             .TRIGER_POSITION(TRIGER_POSITION)) u_cnt_demo_inst4
                           (
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk3),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(reset_n3),
			    .cnt_out (cnt_reg4),
			    .cnt_dly_out (cnt_dly_reg4),
                            .hundred(gpio_10),
                            .one_fifty(gpio_11),
                            .toggle(gpio_12));


cnt_start_check u_cnt_start_check1
	(
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk3),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(~sync_reset),
			    .cnt_reg (cnt_reg1),
			    .cnt_dly_reg (cnt_dly_reg1),
			    .start_flag (count_start1));

cnt_start_check u_cnt_start_check2
	(
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk3),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(~sync_reset),
			    .cnt_reg (cnt_reg4),
			    .cnt_dly_reg (cnt_dly_reg4),
			    .start_flag (count_start2));
cnt_end_check u_cnt_end_check1
	(
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk3),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(~sync_reset),
			    .cnt_reg (cnt_reg1),
			    .cnt_dly_reg (cnt_dly_reg1),
			    
			    .end_flag (count_end1));
 cnt_end_check u_cnt_end_check2
	(
                            `ifdef CLK_CNTRL_ENBL
                            .osc_ext(clk3),
                            `else
                            .osc_ext(osc),
                            `endif 
                            .reset_n(~sync_reset),
			    .cnt_reg (cnt_reg4),
			    .cnt_dly_reg (cnt_dly_reg4),
			    
			    .end_flag (count_end2));

`ifdef ROM_DEMO
  rom_demo_sp #(
    .DATA_WIDTH(16),
    .ROM_DEPTH(256)
  ) u_rom_demo_1 (
    .clk     (osc),
    .reset_n (reset_n),
    .equal_out(gpio_24)
  );
`endif

endmodule
