
package require DF
DF::df_open "export_results/system/targetsystem.tsd"  E021929 uA

# Data check error count
set data_check_error_count 0

# ROM with backdoor access : dut_inst.u_rom_demo_1.rompram[15:0]
# Write Port Signals
#set rompram_we {dut_inst.u_rom_demo_1.rompram_we}
#set rompram_wd {dut_inst.u_rom_demo_1.rompram_data[15:0]}
#set rompram_wa {dut_inst.u_rom_demo_1.rompram_waddr[7:0]}
set rompram_we {dut_inst.rompram_we}
set rompram_wd {dut_inst.rompram_data[31:0]}
set rompram_wa {dut_inst.rompram_waddr[7:0]}

# Read Port Signals
#set rompram_rd {cnt_demo_top.u_rom_demo_1.dout[15:0]}
#set rompram_ra {cnt_demo_top.u_rom_demo_1.addr[7:0]}

set rompram_rd1 {rom_demo_sp.dout1[31:0]}
set rompram_rd2 {rom_demo_sp.dout2[31:0]}
set rompram_rd3 {rom_demo_sp.dout3[31:0]} 
set rompram_rd4 {rom_demo_sp.dout4[31:0]}
set rompram_rd5 {rom_demo_sp.dout5[31:0]} 
set rompram_rd6 {rom_demo_sp.dout6[31:0]}
set rompram_rd7 {rom_demo_sp.dout7[31:0]} 
set rompram_rd8 {rom_demo_sp.dout8[31:0]}
#
set rompram_ra1 {rom_demo_sp.addr1[7:0]}
set rompram_ra2 {rom_demo_sp.addr2[7:0]} 
set rompram_ra3 {rom_demo_sp.addr3[7:0]} 
set rompram_ra4 {rom_demo_sp.addr4[7:0]}
set rompram_ra5 {rom_demo_sp.addr5[7:0]}
set rompram_ra6 {rom_demo_sp.addr6[7:0]} 
set rompram_ra7 {rom_demo_sp.addr7[7:0]} 
set rompram_ra8 {rom_demo_sp.addr8[7:0]}

set rompram_read_a {rom_demo_sp.m0.a[15:0]}
set rompram_read_b {rom_demo_sp.m0.b[15:0]}
set rompram_read_c {rom_demo_sp.m0.c[15:0]}
#
set rompram_read_a1 {rom_demo_sp.m1.a1[15:0]} 
set rompram_read_a2 {rom_demo_sp.m1.a2[15:0]} 
set rompram_read_a3 {rom_demo_sp.m1.a3[15:0]} 
set rompram_read_a4 {rom_demo_sp.m1.a4[15:0]} 
set rompram_read_a5 {rom_demo_sp.m1.a5[15:0]}
set rompram_read_a6 {rom_demo_sp.m1.a6[15:0]} 
set rompram_read_a7 {rom_demo_sp.m1.a7[15:0]} 
set rompram_read_a8 {rom_demo_sp.m1.a8[15:0]}
set rompram_read_a9 {rom_demo_sp.m1.a9[15:0]} 
set rompram_read_a10 {rom_demo_sp.m1.a10[15:0]}
set rompram_read_a11 {rom_demo_sp.m1.a11[15:0]} 
set rompram_read_a12 {rom_demo_sp.m1.a12[15:0]} 
set rompram_read_a13 {rom_demo_sp.m1.a13[15:0]}
set rompram_read_a14 {rom_demo_sp.m1.a14[15:0]} 
set rompram_read_a15 {rom_demo_sp.m1.a15[15:0]} 
set rompram_read_a16 {rom_demo_sp.m1.a16[15:0]}
 
set rompram_read_output_of_add {rom_demo_sp.output_of_add[15:0]}
set rompram_read_output_of_add_8 {rom_demo_sp.output_of_add_8[127:0]}

set rompram_read_rom {rom_demo_sp.rom_inst[15:0]}
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
  if {[llength $expected_data] > 0} {
    set check_data 1
  } else {
    set check_data 0
  }

  puts "READ ROM CONTENTS"

  # Read ROM contents
  for {set jj 0} {$jj <= $max_addr} {incr jj} {
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
    if {[llength $orig_data] <= $max_addr} {
      lappend orig_data $read_data
    }

    if {[llength $expected_data] > 0} {
      puts -nonewline "$rompram_rd2\[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]\]: 0x[format %04X [expr 0x[lindex $expected_data $jj] + 0x0]]"
    } else {
      puts -nonewline "$rompram_rd2\[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]\]: 0x[format %04X [expr 0x$read_data + 0x0]]"
    }
    # Print out read result
    #puts -nonewline "$rompram_rd2\[0x[format %02X [expr 0x[value $rompram_ra2] + 0x0]]\]: 0x[format %04X [expr 0x$read_data + 0x0]]"
    
    
    # Check read data if relevant
    #if $check_data {
    #  puts -nonewline " - 0x[format %04X [expr 0x[lindex $expected_data $jj] + 0x0]]"
    #  if {[expr 0x$read_data + 0x0] == [expr 0x[lindex $expected_data $jj] + 0x0]} {
    #    puts -nonewline " - OK"
    #  } else {
    #    puts -nonewline " - MISMATCH"
    #    incr data_check_error_count
    #  }
    #}
    force -release $rompram_ra2
    
    puts ""
  }
  puts ""
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

  global rompram_rd1
  global rompram_rd2
  global rompram_rd3
  global rompram_rd4
  global rompram_rd5
  global rompram_rd6
  global rompram_rd7
  global rompram_rd8

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

  global rompram_read_output_of_add
  #
  global rompram_read_output_of_add_8

  global rompram_read_rom

  puts "READ DUT CONTENTS"
  
  puts "--------------------------------------------------------------------------------------------"

  
  set i 0
  set hex_value [format "0x%X" $i]
  for {set ii 0} {$ii <= 63} {incr ii 8} {

    puts "--------------------------------------------------------------------------------------------"
    
    incr hex_value
    puts "Column i: $hex_value"

    set kk $ii
    force $rompram_ra8 'h[format %X $kk]
    set read_addr1 [value $rompram_ra8]
    #puts "addr1: $read_addr1"
    set read_data1 [value $rompram_rd8]
    force $rompram_rd1 [expr 0x[lindex $expected_data $kk]]
    set read_dout1 [value $rompram_rd1]
    #puts "dout1: $read_dout1"

    set kk [expr {$ii + 1}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr2 [value $rompram_ra8]
    #puts "addr2: $read_addr2"
    set read_data2 [value $rompram_rd8]
    force $rompram_rd2 [expr 0x[lindex $expected_data $kk]]
    set read_dout2 [value $rompram_rd2]
    #puts "dout2: $read_dout2"
 
    set kk [expr {$ii + 2}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr3 [value $rompram_ra8]
    #puts "addr3: $read_addr3"
    set read_data3 [value $rompram_rd8]
    force $rompram_rd3 [expr 0x[lindex $expected_data $kk]]
    set read_dout3 [value $rompram_rd3]
    #puts "dout3: $read_dout3"

    set kk [expr {$ii + 3}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr4 [value $rompram_ra8]
    #puts "addr4: $read_addr4"
    set read_data4 [value $rompram_rd8]
    force $rompram_rd4 [expr 0x[lindex $expected_data $kk]]
    set read_dout4 [value $rompram_rd4]
    #puts "dout4: $read_dout4"

    set kk [expr {$ii + 4}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr5 [value $rompram_ra8]
    #puts "addr5: $read_addr5"
    set read_data5 [value $rompram_rd8]
    force $rompram_rd5 [expr 0x[lindex $expected_data $kk]]
    set read_dout5 [value $rompram_rd5]
    #puts "dout5: $read_dout5"

    set kk [expr {$ii + 5}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr6 [value $rompram_ra8]
    #puts "addr6: $read_addr6"
    set read_data6 [value $rompram_rd8]
    force $rompram_rd6 [expr 0x[lindex $expected_data $kk]]
    set read_dout6 [value $rompram_rd6]
    #puts "dout6: $read_dout6"
  
    set kk [expr {$ii + 6}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr7 [value $rompram_ra8]
    #puts "addr7: $read_addr7"
    set read_data7 [value $rompram_rd8]
    force $rompram_rd7 [expr 0x[lindex $expected_data $kk]]
    set read_dout7 [value $rompram_rd7] 
    #puts "dout7: $read_dout7"
 
    set kk [expr {$ii + 7}]
    force $rompram_ra8 'h[format %X $kk]
    set read_addr8 [value $rompram_ra8]
    #puts "addr8: $read_addr8"
    set read_data8 [value $rompram_rd8]
    force $rompram_rd8 [expr 0x[lindex $expected_data $kk]]
    set read_dout8 [value $rompram_rd8]
    #puts "dout8: $read_dout8"

    
    set output_1 {rom_demo_sp.output_of_add_8[127:112]}
    set output [value $output_1]

    set read_a1 [value $rompram_read_a1]
    set read_a2 [value $rompram_read_a2]
    puts "Matrix1\[1\]: $read_a1 ,   Matrix2\[1\]: $read_a2 ,   Ouput: $output"

    set output_2 {rom_demo_sp.output_of_add_8[111:96]}
    set output [value $output_2]

    set read_a3 [value $rompram_read_a3]
    set read_a4 [value $rompram_read_a4]
    puts "Matrix1\[2\]: $read_a3 ,   Matrix2\[2\]: $read_a4 ,   Ouput: $output"

    set output_3 {rom_demo_sp.output_of_add_8[95:80]}
    set output [value $output_3]

    set read_a5 [value $rompram_read_a5]
    set read_a6 [value $rompram_read_a6]
    puts "Matrix1\[3\]: $read_a5 ,   Matrix2\[3\]: $read_a6 ,   Ouput: $output"

    set output_4 {rom_demo_sp.output_of_add_8[79:64]}
    set output [value $output_4]

    set read_a7 [value $rompram_read_a7]
    set read_a8 [value $rompram_read_a8]
    puts "Matrix1\[4\]: $read_a7 ,   Matrix2\[4\]: $read_a8 ,   Ouput: $output"

    set output_5 {rom_demo_sp.output_of_add_8[63:48]}
    set output [value $output_5]

    set read_a9 [value $rompram_read_a9]
    set read_a10 [value $rompram_read_a10]
    puts "Matrix1\[5\]: $read_a9 ,   Matrix2\[5\]: $read_a10 ,   Ouput: $output"

    set output_6 {rom_demo_sp.output_of_add_8[47:32]}
    set output [value $output_6]

    set read_a11 [value $rompram_read_a11]
    set read_a12 [value $rompram_read_a12]
    puts "Matrix1\[6\]: $read_a11 ,   Matrix2\[6\]: $read_a12 ,   Ouput: $output"

    set output_7 {rom_demo_sp.output_of_add_8[31:16]}
    set output [value $output_7]

    set read_a13 [value $rompram_read_a13]
    set read_a14 [value $rompram_read_a14]
    puts "Matrix1\[7\]: $read_a13 ,   Matrix2\[7\]: $read_a14 ,   Ouput: $output"

    set output_8 {rom_demo_sp.output_of_add_8[15:0]}
    set output [value $output_8]

    set read_a15 [value $rompram_read_a15]
    set read_a16 [value $rompram_read_a16]
    puts "Matrix1\[8\]: $read_a15 ,   Matrix2\[8\]: $read_a16 ,   Ouput: $output"

    #set read_output_of_add [value $rompram_read_output_of_add]
    #puts "output_of_add: $read_output_of_add"
    #
    set read_output_of_add_8 [value $rompram_read_output_of_add_8]
    puts "output_of_add: $read_output_of_add_8"
    puts "--------------------------------------------------------------------------------------------"
  
   
 
  }


}



# Proc to write contents of the ROMs
proc write_rom_contents {data} {
  # The following global variables are defined outside this proc
  global max_addr
  global rompram_wa
  global rompram_wd
  global rompram_we

  puts "WRITE ROM CONTENTS"

  # ROM
  for {set jj 0} {$jj <= $max_addr} {incr jj} {
    # Force the write address bus
    force $rompram_wa 'h[format %X $jj]
    set check_force [value $rompram_wa]
    # Force the write data bus
    force $rompram_wd 'h[lindex $data $jj]
    set check_force [value $rompram_wd]
    # Force the Write enable bus (write)
    force $rompram_we 1
    # Force the Write enable bus (no-write: don't want this enabled when other write buses are changing)
    force $rompram_we 0
    #puts "$rompram_wd\[[format %02X $jj]\]: 0x[format %04X [expr 0x[lindex $data $jj] + 0x0]]"
  }
  puts ""

}


# Data to be written to ROM
set data {}
lappend data "50003ff0"
lappend data "5000100D"
lappend data "5000200D"
lappend data "300D4ABC"
lappend data "400D2345"
lappend data "500D3245"
lappend data "600D4387"
lappend data "700D4343"
lappend data "800D4343"
lappend data "900D5555"
lappend data "A00D0989"
lappend data "B00D5343"
lappend data "C00D4343"
lappend data "D00D2222"
lappend data "E00D3439"
lappend data "F00D0877"
lappend data "010DE656"
lappend data "110D"
lappend data "210D"
lappend data "310D"
lappend data "410D"
lappend data "510D"
lappend data "610D"
lappend data "710D"
lappend data "810D"
lappend data "910D"
lappend data "A10D"
lappend data "B10D"
lappend data "C10D"
lappend data "D10D"
lappend data "E10D"
lappend data "F10D"
lappend data "020D"
lappend data "120D"
lappend data "220D"
lappend data "320D"
lappend data "420D"
lappend data "520D"
lappend data "620D"
lappend data "720D"
lappend data "820D"
lappend data "920D"
lappend data "A20D"
lappend data "B20D"
lappend data "C20D"
lappend data "D20D"
lappend data "E20D"
lappend data "F20D"
lappend data "030D"
lappend data "130D"
lappend data "230D"
lappend data "330D"
lappend data "430D"
lappend data "530D"
lappend data "630D"
lappend data "730D"
lappend data "830D"
lappend data "930D"
lappend data "A30D"
lappend data "B30D"
lappend data "C30D"
lappend data "D30D"
lappend data "E30D"
lappend data "F30D"
lappend data "040D"
lappend data "140D"
lappend data "240D"
lappend data "340D"
lappend data "440D"
lappend data "540D"
lappend data "640D"
lappend data "740D"
lappend data "840D"
lappend data "940D"
lappend data "A40D"
lappend data "B40D"
lappend data "C40D"
lappend data "D40D"
lappend data "E40D"
lappend data "F40D"
lappend data "050D"
lappend data "150D"
lappend data "250D"
lappend data "350D"
lappend data "450D"
lappend data "550D"
lappend data "650D"
lappend data "750D"
lappend data "850D"
lappend data "950D"
lappend data "A50D"
lappend data "B50D"
lappend data "C50D"
lappend data "D50D"
lappend data "E50D"
lappend data "F50D"
lappend data "060D"
lappend data "160D"
lappend data "260D"
lappend data "360D"
lappend data "460D"
lappend data "560D"
lappend data "660D"
lappend data "760D"
lappend data "860D"
lappend data "960D"
lappend data "A60D"
lappend data "B60D"
lappend data "C60D"
lappend data "D60D"
lappend data "E60D"
lappend data "F60D"
lappend data "070D"
lappend data "170D"
lappend data "270D"
lappend data "370D"
lappend data "470D"
lappend data "570D"
lappend data "670D"
lappend data "770D"
lappend data "870D"
lappend data "970D"
lappend data "A70D"
lappend data "B70D"
lappend data "C70D"
lappend data "D70D"
lappend data "E70D"
lappend data "F70D"
lappend data "080D"
lappend data "180D"
lappend data "280D"
lappend data "380D"
lappend data "480D"
lappend data "580D"
lappend data "680D"
lappend data "780D"
lappend data "880D"
lappend data "980D"
lappend data "A80D"
lappend data "B80D"
lappend data "C80D"
lappend data "D80D"
lappend data "E80D"
lappend data "F80D"
lappend data "090D"
lappend data "190D"
lappend data "290D"
lappend data "390D"
lappend data "490D"
lappend data "590D"
lappend data "690D"
lappend data "790D"
lappend data "890D"
lappend data "990D"
lappend data "A90D"
lappend data "B90D"
lappend data "C90D"
lappend data "D90D"
lappend data "E90D"
lappend data "F90D"
lappend data "0A0D"
lappend data "1A0D"
lappend data "2A0D"
lappend data "3A0D"
lappend data "4A0D"
lappend data "5A0D"
lappend data "6A0D"
lappend data "7A0D"
lappend data "8A0D"
lappend data "9A0D"
lappend data "AA0D"
lappend data "BA0D"
lappend data "CA0D"
lappend data "DA0D"
lappend data "EA0D"
lappend data "FA0D"
lappend data "0B0D"
lappend data "1B0D"
lappend data "2B0D"
lappend data "3B0D"
lappend data "4B0D"
lappend data "5B0D"
lappend data "6B0D"
lappend data "7B0D"
lappend data "8B0D"
lappend data "9B0D"
lappend data "AB0D"
lappend data "BB0D"
lappend data "CB0D"
lappend data "DB0D"
lappend data "EB0D"
lappend data "FB0D"
lappend data "0C0D"
lappend data "1C0D"
lappend data "2C0D"
lappend data "3C0D"
lappend data "4C0D"
lappend data "5C0D"
lappend data "6C0D"
lappend data "7C0D"
lappend data "8C0D"
lappend data "9C0D"
lappend data "AC0D"
lappend data "BC0D"
lappend data "CC0D"
lappend data "DC0D"
lappend data "EC0D"
lappend data "FC0D"
lappend data "0D0D"
lappend data "1D0D"
lappend data "2D0D"
lappend data "3D0D"
lappend data "4D0D"
lappend data "5D0D"
lappend data "6D0D"
lappend data "7D0D"
lappend data "8D0D"
lappend data "9D0D"
lappend data "AD0D"
lappend data "BD0D"
lappend data "CD0D"
lappend data "DD0D"
lappend data "ED0D"
lappend data "FD0D"
lappend data "0E0D"
lappend data "1E0D"
lappend data "2E0D"
lappend data "3E0D"
lappend data "4E0D"
lappend data "5E0D"
lappend data "6E0D"
lappend data "7E0D"
lappend data "8E0D"
lappend data "9E0D"
lappend data "AE0D"
lappend data "BE0D"
lappend data "CE0D"
lappend data "DE0D"
lappend data "EE0D"
lappend data "FE0D"
lappend data "0F0D"
lappend data "1F0D"
lappend data "2F0D"
lappend data "3F0D"
lappend data "4F0D"
lappend data "5F0D"
lappend data "6F0D"
lappend data "7F0D"
lappend data "8F0D"
lappend data "9F0D"
lappend data "3ff0"
lappend data "3ff0"
lappend data "3ff0"
lappend data "3ff0"
lappend data "3ff0"
lappend data "3ff0"


# Read original contetns of ROM (no checking)
read_rom_contents {}
#read_dut_values {}

# Write contents or ROMs
write_rom_contents $data

# Read contents of ROMs and check
read_rom_contents $data
read_dut_values $data

# Write original contents of ROMs
write_rom_contents $orig_data

# Read again and check
read_rom_contents $orig_data
#read_dut_values {}
if {$data_check_error_count > 0} {
  puts "ERROR: Data Check FAILED ($data_check_error_count error(s) found)"
} else {
  puts "INFO: Data Check PASSED"
}
