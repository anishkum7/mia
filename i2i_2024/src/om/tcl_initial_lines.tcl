
package require DF
DFdf_open export_resultssystemtargetsystem.tsd  E021929 uA

# Data check error count
set data_check_error_count 0

# ROM with backdoor access  dut_inst.u_rom_demo_1.rompram[150]
# Write Port Signals
#set rompram_we {dut_inst.u_rom_demo_1.rompram_we}
#set rompram_wd {dut_inst.u_rom_demo_1.rompram_data[150]}
#set rompram_wa {dut_inst.u_rom_demo_1.rompram_waddr[70]}
set rompram_we {dut_inst.rompram_we}
set rompram_wd {dut_inst.rompram_data[310]}
set rompram_wa {dut_inst.rompram_waddr[70]}

# Read Port Signals
#set rompram_rd {cnt_demo_top.u_rom_demo_1.dout[150]}
#set rompram_ra {cnt_demo_top.u_rom_demo_1.addr[70]}

set rompram_rd1 {rom_demo_sp.dout1[310]}
set rompram_rd2 {rom_demo_sp.dout2[310]}
set rompram_rd3 {rom_demo_sp.dout3[310]} 
set rompram_rd4 {rom_demo_sp.dout4[310]}
set rompram_rd5 {rom_demo_sp.dout5[310]} 
set rompram_rd6 {rom_demo_sp.dout6[310]}
set rompram_rd7 {rom_demo_sp.dout7[310]} 
set rompram_rd8 {rom_demo_sp.dout8[310]}
set rompram_rd9 {rom_demo_sp.dout9[310]}
set rompram_rd10 {rom_demo_sp.dout10[310]}
set rompram_rd11 {rom_demo_sp.dout11[310]} 
set rompram_rd12 {rom_demo_sp.dout12[310]} 
set rompram_rd13 {rom_demo_sp.dout13[310]}
set rompram_rd14 {rom_demo_sp.dout14[310]}
set rompram_rd15 {rom_demo_sp.dout15[310]} 
set rompram_rd16 {rom_demo_sp.dout16[310]}
#
set rompram_ra1 {rom_demo_sp.addr1[70]}
set rompram_ra2 {rom_demo_sp.addr2[70]} 
set rompram_ra3 {rom_demo_sp.addr3[70]} 
set rompram_ra4 {rom_demo_sp.addr4[70]}
set rompram_ra5 {rom_demo_sp.addr5[70]}
set rompram_ra6 {rom_demo_sp.addr6[70]} 
set rompram_ra7 {rom_demo_sp.addr7[70]} 
set rompram_ra8 {rom_demo_sp.addr8[70]}
set rompram_ra9 {rom_demo_sp.addr9[70]}
set rompram_ra10 {rom_demo_sp.addr10[70]} 
set rompram_ra11 {rom_demo_sp.addr11[70]} 
set rompram_ra12 {rom_demo_sp.addr12[70]}
set rompram_ra13 {rom_demo_sp.addr13[70]}
set rompram_ra14 {rom_demo_sp.addr14[70]} 
set rompram_ra15 {rom_demo_sp.addr15[70]} 
set rompram_ra16 {rom_demo_sp.addr16[70]}

set rompram_read_a {rom_demo_sp.m0.a[150]}
set rompram_read_b {rom_demo_sp.m0.b[150]}
set rompram_read_c {rom_demo_sp.m0.c[150]}
#
set rompram_read_a1 {rom_demo_sp.m1.a1[150]} 
set rompram_read_a2 {rom_demo_sp.m1.a2[150]} 
set rompram_read_a3 {rom_demo_sp.m1.a3[150]} 
set rompram_read_a4 {rom_demo_sp.m1.a4[150]} 
set rompram_read_a5 {rom_demo_sp.m1.a5[150]}
set rompram_read_a6 {rom_demo_sp.m1.a6[150]} 
set rompram_read_a7 {rom_demo_sp.m1.a7[150]} 
set rompram_read_a8 {rom_demo_sp.m1.a8[150]}
set rompram_read_a9 {rom_demo_sp.m1.a9[150]} 
set rompram_read_a10 {rom_demo_sp.m1.a10[150]}
set rompram_read_a11 {rom_demo_sp.m1.a11[150]} 
set rompram_read_a12 {rom_demo_sp.m1.a12[150]} 
set rompram_read_a13 {rom_demo_sp.m1.a13[150]}
set rompram_read_a14 {rom_demo_sp.m1.a14[150]} 
set rompram_read_a15 {rom_demo_sp.m1.a15[150]} 
set rompram_read_a16 {rom_demo_sp.m1.a16[150]} 
set rompram_read_a17 {rom_demo_sp.m1.a17[150]} 
set rompram_read_a18 {rom_demo_sp.m1.a18[150]} 
set rompram_read_a19 {rom_demo_sp.m1.a19[150]} 
set rompram_read_a20 {rom_demo_sp.m1.a20[150]} 
set rompram_read_a21 {rom_demo_sp.m1.a21[150]}
set rompram_read_a22 {rom_demo_sp.m1.a22[150]} 
set rompram_read_a23 {rom_demo_sp.m1.a23[150]} 
set rompram_read_a24 {rom_demo_sp.m1.a24[150]} 
set rompram_read_a25 {rom_demo_sp.m1.a25[150]} 
set rompram_read_a26 {rom_demo_sp.m1.a26[150]} 
set rompram_read_a27 {rom_demo_sp.m1.a27[150]} 
set rompram_read_a28 {rom_demo_sp.m1.a28[150]} 
set rompram_read_a29 {rom_demo_sp.m1.a29[150]}
set rompram_read_a30 {rom_demo_sp.m1.a30[150]} 
set rompram_read_a31 {rom_demo_sp.m1.a31[150]} 
set rompram_read_a32 {rom_demo_sp.m1.a32[150]}
 
set rompram_read_output_of_add {rom_demo_sp.output_of_add[150]}
set rompram_read_output_of_add_16 {rom_demo_sp.output_of_add_16[2550]}

set rompram_read_rom {rom_demo_sp.rom_inst[150]}
#-------------new


# This comes from the design implementation
set max_addr 255

# Reset lists for original ROM data
set orig_data {}
set orig_data1 {}

# Proc to read the contents of the ROMs, and optionally compare with expected data (if required)
# If expected data lists passed as arguments are empty, then no data is compared
proc read_rom_contents {expected_data} {
  # The following global variables are defined outside this proc
  global max_addr
  #global rompram_ra1
  #global rompram_rd1
  global rompram_ra2
  global rompram_rd2
  #global rompram_ra3
  #global rompram_rd3
  #global rompram_ra4
  #global rompram_rd4
  #global rompram_ra5
  #global rompram_rd5
  #global rompram_ra6
  #global rompram_rd6
  #global rompram_ra7
  #global rompram_rd7
  #global rompram_ra8
  #global rompram_rd8
  #global rompram_ra9
  #global rompram_rd9
  #global rompram_ra10
  #global rompram_rd10
  #global rompram_ra11
  #global rompram_rd11
  #global rompram_ra12
  #global rompram_rd12
  #global rompram_ra13
  #global rompram_rd13
  #global rompram_ra14
  #global rompram_rd14
  #global rompram_ra15
  #global rompram_rd15
  #global rompram_ra16
  #global rompram_rd16


  global orig_data
  global data_check_error_count
  global rompram_read_a
  global rompram_read_b 
  global rompram_read_c
  global rompram_read_output_of_add
  global rompram_read_rom

  # Skip data comparison if lists passed as arguments are empty
  if {[llength $expected_data]  0} {
    set check_data 1
  } else {
    set check_data 0
  }

  puts READ ROM CONTENTS

  # Read ROM contents
  for {set jj 0} {$jj = $max_addr} {incr jj} {
    # Set the address in hex format by using the force command on the relevant bus (address read for rom)
    
    #force $rompram_ra1 'h[format %X $jj]
    force $rompram_ra2 'h[format %X $jj]
    #force $rompram_ra3 'h[format %X $jj]
    #force $rompram_ra4 'h[format %X $jj]
    #force $rompram_ra5 'h[format %X $jj]
    #force $rompram_ra6 'h[format %X $jj]
    #force $rompram_ra7 'h[format %X $jj]
    #force $rompram_ra8 'h[format %X $jj]
    #force $rompram_ra9 'h[format %X $jj]
    #force $rompram_ra10 'h[format %X $jj]
    #force $rompram_ra11 'h[format %X $jj]
    #force $rompram_ra12 'h[format %X $jj]
    #force $rompram_ra13 'h[format %X $jj]
    #force $rompram_ra14 'h[format %X $jj]
    #force $rompram_ra15 'h[format %X $jj]
    #force $rompram_ra16 'h[format %X $jj]

    # Read the data from the data bus for rom

    #set read_data [value $rompram_rd1]
    set read_data [value $rompram_rd2]
    #set read_data [value $rompram_rd3]
    #set read_data [value $rompram_rd4]
    #set read_data [value $rompram_rd5]
    #set read_data [value $rompram_rd6]
    #set read_data [value $rompram_rd7]
    #set read_data [value $rompram_rd8]
    #set read_data [value $rompram_rd9]
    #set read_data [value $rompram_rd10]
    #set read_data [value $rompram_rd11]
    #set read_data [value $rompram_rd12]
    #set read_data [value $rompram_rd13]
    #set read_data [value $rompram_rd14]
    #set read_data [value $rompram_rd15]
    #set read_data [value $rompram_rd16]


    # If the original values in ROM have not yet been captured, then capture them now
    if {[llength $orig_data] = $max_addr} {
      lappend orig_data $read_data
    }

    if {[llength $expected_data]  0} {
      puts -nonewline $rompram_rd2[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]] 0x[format %04X [expr 0x[lindex $expected_data $jj] + 0x0]]
    } else {
      puts -nonewline $rompram_rd2[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]] 0x[format %04X [expr 0x$read_data + 0x0]]
    }
    # Print out read result
    #puts -nonewline $rompram_rd2[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]] 0x[format %04X [expr 0x$read_data + 0x0]]
    
    
    # Check read data if relevant
    #if $check_data {
    #  puts -nonewline  - 0x[format %04X [expr 0x[lindex $expected_data $jj] + 0x0]]
    #  if {[expr 0x$read_data + 0x0] == [expr 0x[lindex $expected_data $jj] + 0x0]} {
    #    puts -nonewline  - OK
    #  } else {
    #    puts -nonewline  - MISMATCH
    #    incr data_check_error_count
    #  }
    #}
    force -release $rompram_ra2
    
    puts 
  }
  puts 
}

proc read_dut_values {expected_data} {
  # The following global variables are defined outside this proc
  
  global rompram_ra1
  global rompram_ra2
  global rompram_ra3
  global rompram_ra4
  global rompram_ra5
  global rompram_ra6
  global rompram_ra7
  global rompram_ra8
  global rompram_ra9
  global rompram_ra10
  global rompram_ra11
  global rompram_ra12
  global rompram_ra13
  global rompram_ra14
  global rompram_ra15
  global rompram_ra16

  global rompram_rd1
  global rompram_rd2
  global rompram_rd3
  global rompram_rd4
  global rompram_rd5
  global rompram_rd6
  global rompram_rd7
  global rompram_rd8
  global rompram_rd9
  global rompram_rd10
  global rompram_rd11
  global rompram_rd12
  global rompram_rd13
  global rompram_rd14
  global rompram_rd15
  global rompram_rd16

  global rompram_read_a
  global rompram_read_b 
  global rompram_read_c
  #
  global rompram_read_a1
  global rompram_read_a2
  global rompram_read_a3
  global rompram_read_a4
  global rompram_read_a5
  global rompram_read_a6
  global rompram_read_a7
  global rompram_read_a8
  global rompram_read_a9
  global rompram_read_a10
  global rompram_read_a11
  global rompram_read_a12
  global rompram_read_a13
  global rompram_read_a14
  global rompram_read_a15
  global rompram_read_a16
  global rompram_read_a17
  global rompram_read_a18
  global rompram_read_a19
  global rompram_read_a20
  global rompram_read_a21
  global rompram_read_a22
  global rompram_read_a23
  global rompram_read_a24
  global rompram_read_a25
  global rompram_read_a26
  global rompram_read_a27
  global rompram_read_a28
  global rompram_read_a29
  global rompram_read_a30
  global rompram_read_a31
  global rompram_read_a32

  global rompram_read_output_of_add
  #
  global rompram_read_output_of_add_16

  global rompram_read_rom

  puts READ DUT CONTENTS
  
  puts --------------------------------------------------------------------------------------------

  
  set i 0
  set hex_value [format 0x%X $i]
  for {set ii 0} {$ii = 255} {incr ii 16} {

    puts --------------------------------------------------------------------------------------------
    
    incr hex_value
    puts Column i $hex_value

    set kk $ii
    force $rompram_ra15 'h[format %X $kk]
    set read_addr1 [value $rompram_ra15]
    #puts addr1 $read_addr1
    set read_data1 [value $rompram_rd15]
    force $rompram_rd1 [expr 0x[lindex $expected_data $kk]]
    set read_dout1 [value $rompram_rd1]
    #puts dout1 $read_dout1

    set kk [expr {$ii + 1}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr2 [value $rompram_ra15]
    #puts addr2 $read_addr2
    set read_data2 [value $rompram_rd15]
    force $rompram_rd2 [expr 0x[lindex $expected_data $kk]]
    set read_dout2 [value $rompram_rd2]
    #puts dout2 $read_dout2
 
    set kk [expr {$ii + 2}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr3 [value $rompram_ra15]
    #puts addr3 $read_addr3
    set read_data3 [value $rompram_rd15]
    force $rompram_rd3 [expr 0x[lindex $expected_data $kk]]
    set read_dout3 [value $rompram_rd3]
    #puts dout3 $read_dout3

    set kk [expr {$ii + 3}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr4 [value $rompram_ra15]
    #puts addr4 $read_addr4
    set read_data4 [value $rompram_rd15]
    force $rompram_rd4 [expr 0x[lindex $expected_data $kk]]
    set read_dout4 [value $rompram_rd4]
    #puts dout4 $read_dout4

    set kk [expr {$ii + 4}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr5 [value $rompram_ra15]
    #puts addr5 $read_addr5
    set read_data5 [value $rompram_rd15]
    force $rompram_rd5 [expr 0x[lindex $expected_data $kk]]
    set read_dout5 [value $rompram_rd5]
    #puts dout5 $read_dout5

    set kk [expr {$ii + 5}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr6 [value $rompram_ra15]
    #puts addr6 $read_addr6
    set read_data6 [value $rompram_rd15]
    force $rompram_rd6 [expr 0x[lindex $expected_data $kk]]
    set read_dout6 [value $rompram_rd6]
    #puts dout6 $read_dout6
  
    set kk [expr {$ii + 6}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr7 [value $rompram_ra15]
    #puts addr7 $read_addr7
    set read_data7 [value $rompram_rd15]
    force $rompram_rd7 [expr 0x[lindex $expected_data $kk]]
    set read_dout7 [value $rompram_rd7] 
    #puts dout7 $read_dout7
 
    set kk [expr {$ii + 7}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr8 [value $rompram_ra15]
    #puts addr8 $read_addr8
    set read_data8 [value $rompram_rd15]
    force $rompram_rd8 [expr 0x[lindex $expected_data $kk]]
    set read_dout8 [value $rompram_rd8]
    #puts dout8 $read_dout8

    set kk [expr {$ii + 8}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr9 [value $rompram_ra15]
    #puts addr9 $read_addr9
    set read_data9 [value $rompram_rd15]
    force $rompram_rd9 [expr 0x[lindex $expected_data $kk]]
    set read_dout9 [value $rompram_rd9]
    #puts dout9 $read_dout9

    set kk [expr {$ii + 9}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr10 [value $rompram_ra15]
    #puts addr10 $read_addr10
    set read_data10 [value $rompram_rd15]
    force $rompram_rd10 [expr 0x[lindex $expected_data $kk]]
    set read_dout10 [value $rompram_rd10]
    #puts dout10 $read_dout10 

    set kk [expr {$ii + 10}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr11 [value $rompram_ra15]
    #puts addr11 $read_addr11
    set read_data11 [value $rompram_rd15]
    force $rompram_rd11 [expr 0x[lindex $expected_data $kk]]
    set read_dout11 [value $rompram_rd11]
    #puts dout11 $read_dout11 

    set kk [expr {$ii + 11}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr12 [value $rompram_ra15]
    #puts addr12 $read_addr12
    set read_data12 [value $rompram_rd15]
    force $rompram_rd12 [expr 0x[lindex $expected_data $kk]]
    set read_dout12 [value $rompram_rd12]
    #puts dout12 $read_dout12

    set kk [expr {$ii + 12}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr13 [value $rompram_ra15]
    #puts addr13 $read_addr13
    set read_data13 [value $rompram_rd15]
    force $rompram_rd13 [expr 0x[lindex $expected_data $kk]]
    set read_dout13 [value $rompram_rd13]
    #puts dout13 $read_dout13

    set kk [expr {$ii + 13}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr14 [value $rompram_ra15]
    #puts addr14 $read_addr14
    set read_data14 [value $rompram_rd15]
    force $rompram_rd14 [expr 0x[lindex $expected_data $kk]]
    set read_dout14 [value $rompram_rd14]
    #puts dout14 $read_dout14

    set kk [expr {$ii + 14}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr15 [value $rompram_ra15]
    #puts addr15 $read_addr15
    set read_data15 [value $rompram_rd15]
    force $rompram_rd15 [expr 0x[lindex $expected_data $kk]]
    set read_dout15 [value $rompram_rd15]
    #puts dout15 $read_dout15

    set kk [expr {$ii + 15}]
    force $rompram_ra15 'h[format %X $kk]
    set read_addr16 [value $rompram_ra15]
    #puts addr16 $read_addr16
    set read_data15 [value $rompram_rd15]
    force $rompram_rd16 [expr 0x[lindex $expected_data $kk]]
    set read_dout16 [value $rompram_rd16]
    #puts dout16 $read_dout16

    set output_1 {rom_demo_sp.output_of_add_16[255240]}
    set output [value $output_1]

    set read_a1 [value $rompram_read_a1]
    set read_a2 [value $rompram_read_a2]
    puts Matrix1[1] $read_a1 ,   Matrix2[1] $read_a2 ,   Ouput $output

    set output_2 {rom_demo_sp.output_of_add_16[239224]}
    set output [value $output_2]

    set read_a3 [value $rompram_read_a3]
    set read_a4 [value $rompram_read_a4]
    puts Matrix1[2] $read_a3 ,   Matrix2[2] $read_a4 ,   Ouput $output

    set output_3 {rom_demo_sp.output_of_add_16[223208]}
    set output [value $output_3]

    set read_a5 [value $rompram_read_a5]
    set read_a6 [value $rompram_read_a6]
    puts Matrix1[3] $read_a5 ,   Matrix2[3] $read_a6 ,   Ouput $output

    set output_4 {rom_demo_sp.output_of_add_16[207192]}
    set output [value $output_4]

    set read_a7 [value $rompram_read_a7]
    set read_a8 [value $rompram_read_a8]
    puts Matrix1[4] $read_a7 ,   Matrix2[4] $read_a8 ,   Ouput $output

    set output_5 {rom_demo_sp.output_of_add_16[191176]}
    set output [value $output_5]

    set read_a9 [value $rompram_read_a9]
    set read_a10 [value $rompram_read_a10]
    puts Matrix1[5] $read_a9 ,   Matrix2[5] $read_a10 ,   Ouput $output

    set output_6 {rom_demo_sp.output_of_add_16[175160]}
    set output [value $output_6]

    set read_a11 [value $rompram_read_a11]
    set read_a12 [value $rompram_read_a12]
    puts Matrix1[6] $read_a11 ,   Matrix2[6] $read_a12 ,   Ouput $output

    set output_7 {rom_demo_sp.output_of_add_16[159144]}
    set output [value $output_7]

    set read_a13 [value $rompram_read_a13]
    set read_a14 [value $rompram_read_a14]
    puts Matrix1[7] $read_a13 ,   Matrix2[7] $read_a14 ,   Ouput $output

    set output_8 {rom_demo_sp.output_of_add_16[143128]}
    set output [value $output_8]

    set read_a15 [value $rompram_read_a15]
    set read_a16 [value $rompram_read_a16]
    puts Matrix1[8] $read_a15 ,   Matrix2[8] $read_a16 ,   Ouput $output

    set output_9 {rom_demo_sp.output_of_add_16[127112]}
    set output [value $output_9]

    set read_a17 [value $rompram_read_a17]
    set read_a18 [value $rompram_read_a18]
    puts Matrix1[9] $read_a17 ,   Matrix2[9] $read_a18 ,   Ouput $output

    set output_10 {rom_demo_sp.output_of_add_16[11196]}
    set output [value $output_10]

    set read_a19 [value $rompram_read_a19]
    set read_a20 [value $rompram_read_a20]
    puts Matrix1[10] $read_a19 ,   Matrix2[10] $read_a20 ,   Ouput $output

    set output_11 {rom_demo_sp.output_of_add_16[9580]}
    set output [value $output_11]

    set read_a21 [value $rompram_read_a21]
    set read_a22 [value $rompram_read_a22]
    puts Matrix1[11] $read_a21 ,   Matrix2[11] $read_a22 ,   Ouput $output

    set output_12 {rom_demo_sp.output_of_add_16[7964]}
    set output [value $output_12]

    set read_a23 [value $rompram_read_a23]
    set read_a24 [value $rompram_read_a24]
    puts Matrix1[12] $read_a23 ,   Matrix2[12] $read_a24 ,   Ouput $output

    set output_13 {rom_demo_sp.output_of_add_16[6348]}
    set output [value $output_13]

    set read_a25 [value $rompram_read_a25]
    set read_a26 [value $rompram_read_a26]
    puts Matrix1[13] $read_a25 ,   Matrix2[13] $read_a26 ,   Ouput $output

    set output_14 {rom_demo_sp.output_of_add_16[4732]}
    set output [value $output_14]

    set read_a27 [value $rompram_read_a27]
    set read_a28 [value $rompram_read_a28]
    puts Matrix1[14] $read_a27 ,   Matrix2[14] $read_a28 ,   Ouput $output

    set output_15 {rom_demo_sp.output_of_add_16[3116]}
    set output [value $output_15]

    set read_a29 [value $rompram_read_a29]
    set read_a30 [value $rompram_read_a30]
    puts Matrix1[15] $read_a29 ,   Matrix2[15] $read_a30 ,   Ouput $output

    set output_16 {rom_demo_sp.output_of_add_16[150]}
    set output [value $output_16]

    set read_a31 [value $rompram_read_a31]
    set read_a32 [value $rompram_read_a32]
    puts Matrix1[16] $read_a31 ,   Matrix2[16] $read_a32 ,   Ouput $output

    #set read_output_of_add [value $rompram_read_output_of_add]
    #puts output_of_add $read_output_of_add
    #
    set read_output_of_add_16 [value $rompram_read_output_of_add_16]
    puts output_of_add $read_output_of_add_16
    puts --------------------------------------------------------------------------------------------
  
   
 
  }


}



# Proc to write contents of the ROMs
proc write_rom_contents {data} {
  # The following global variables are defined outside this proc
  global max_addr
  global rompram_wa
  global rompram_wd
  global rompram_we

  puts WRITE ROM CONTENTS

  # ROM
  for {set jj 0} {$jj = $max_addr} {incr jj} {
    # Force the write address bus
    force $rompram_wa 'h[format %X $jj]
    set check_force [value $rompram_wa]
    # Force the write data bus
    force $rompram_wd 'h[lindex $data $jj]
    set check_force [value $rompram_wd]
    # Force the Write enable bus (write)
    force $rompram_we 1
    # Force the Write enable bus (no-write don't want this enabled when other write buses are changing)
    force $rompram_we 0
    #puts $rompram_wd[[format %02X $jj]] 0x[format %04X [expr 0x[lindex $data $jj] + 0x0]]
  }
  puts 

}


# Data to be written to ROM
set data {}