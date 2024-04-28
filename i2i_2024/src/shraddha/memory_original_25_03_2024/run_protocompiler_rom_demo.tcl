############# CREATE DATABASE #######################
database load db0 -autocreate -technology HAPS-100

############ SOURCE OPTIONS ########################
source ../set_options.tcl

############ LAUNCH UC WITH DUMPVARS IN RTL TO PRESERVE FORCE REGISTERS  ############################
launch uc -utf ../run_rom_demo.utf -ucdb ucdb -v 2.0

########### RUN PC COMPILE WITH DUMMY IDC ################################
run compile -ucdb ucdb -idc ../dummy_rom_demo.idc -out c0 
########## RUN PRE-PARTITION NODE ################
run pre_partition -fdc ../syn_con.fdc -tss ../boardgen.tcl  -out p0

######### RUN PARTITION WITH REPLICATION SCENARIO ########################
run partition -automatic_replication 1 -pcf ../test.pcf -out a0

######## RUN SYSTEM ROUTE ################################################
run system_route -fdc ../syn_con.fdc -pcf ../test.pcf -out s0

####### RUN SYSTEM GENERATE ##############################################
run system_generate -fdc ../syn_con.fdc -out g0 -path synthesis_files

###### RUN Synthesis + P&R
#
launch protocompiler -tclcmd {set ENABLE_PAR 1 ; } -script synthesis_files/mb1_uA/mb1_uA_srs.tcl -tclcmd {set ENABLE_PAR 1 ; } -script synthesis_files/mb1_uB/mb1_uB_srs.tcl
export runtime -path ./export_results
#
#
###### END OF SCRIPT ##################
