############# CREATE DATABASE #######################
database load db0 -autocreate -technology HAPS-100

############ SOURCE OPTIONS ########################
source ../set_options.tcl

##CC ############ LAUNCH UC WITH DUMPVARS IN RTL TO PRESERVE FORCE REGISTERS  ############################
launch uc -utf ../run_rom_demo.utf -ucdb ucdb -v 2.0
##CC ########### RUN PC COMPILE WITH DUMMY IDC ################################
run compile -ucdb ucdb -out c0 
##CC ########## RUN PRE-PARTITION NODE ################
run pre_partition -fdc ../syn_con.fdc -tss ../boardgen.tss  -out p0

######### RUN PARTITION WITH REPLICATION SCENARIO ########################
run partition -automatic_replication 1 -pcf ../test.pcf -out a0

######## RUN SYSTEM ROUTE ################################################
run system_route -fdc ../syn_con.fdc -pcf ../test.pcf -out s0

####### RUN SYSTEM GENERATE ##############################################
run system_generate -fdc ../syn_con.fdc -out g0 -path synthesis_files

###### RUN Synthesis + P&R

launch protocompiler -tclcmd {set ENABLE_PAR 1 } -script [database query_state -script]

export runtime -path ./export_results
#
#
###### END OF SCRIPT ##################