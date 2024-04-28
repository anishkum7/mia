# Mode and uc_groups are set to the recommended values. Ensure to check help docs and change them accordingly.
iice new {IICE_0} -type regular
iice controller -iice {IICE_0} none
iice sampler -iice {IICE_0} -depth 128
iice clock -iice {IICE_0} -edge positive {SRS.osc}
signals add -iice {IICE_0} -silent -sample -trigger {SRS.u_cnt_demo_inst1.capture_cnt[15:0]}\
{SRS.u_cnt_demo_inst4.capture_cnt[15:0]}\
{SRS.u_cnt_demo_inst4.capture_cnt_dly[15:0]}\
{SRS.u_cnt_demo_inst1.capture_cnt_dly[15:0]}

