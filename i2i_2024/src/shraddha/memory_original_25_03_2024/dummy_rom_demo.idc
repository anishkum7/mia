device jtagport umrbus3
device umr_pipe 1
device prepare_incremental 1
iice new {IICE} -type regular -mode {none}
iice controller -iice {IICE} none
iice sampler -iice {IICE} -depth 1000
iice sampler -iice {IICE} -pipe 3

signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.reset_n}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.reset_n1}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.reset_n2}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.reset_n3}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.reset_n4}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_demo_inst1.capture_cnt[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_demo_inst1.capture_cnt_dly[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_demo_inst4.capture_cnt[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_demo_inst4.capture_cnt_dly[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_end_check1.cnt_dly_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_end_check1.cnt_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_end_check2.cnt_dly_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_end_check2.cnt_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_start_check1.cnt_dly_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_start_check1.cnt_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_cnt_start_check2.cnt_dly_reg[15:0]}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_rom_demo_1.reset_n}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_rom_demo_1.addr}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_rom_demo_1.addrp1}
signals add -iice {IICE} -silent -trigger -sample {cnt_demo_top.u_rom_demo_1.equal}

iice clock -iice {IICE} -edge positive {cnt_demo_top.osc}
