
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
set rompram_wd {dut_inst.rompram_data[15:0]}
set rompram_wa {dut_inst.rompram_waddr[7:0]}

# Read Port Signals
#set rompram_rd {cnt_demo_top.u_rom_demo_1.dout[15:0]}
#set rompram_ra {cnt_demo_top.u_rom_demo_1.addr[7:0]}
set rompram_rd {rom_demo_sp.dout[15:0]}
set rompram_ra {rom_demo_sp.addr[7:0]}


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
  global rompram_ra
  global rompram_rd
  global orig_data
  global data_check_error_count

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
    force $rompram_ra 'h[format %X $jj]
    # Read the data from the data bus for rom
    set read_data [value $rompram_rd]

    # If the original values in ROM have not yet been captured, then capture them now
    if {[llength $orig_data] <= $max_addr} {
      lappend orig_data $read_data
    }

    # Print out read result
    puts -nonewline "$rompram_rd\[0x[format %02X [expr 0x[value $rompram_ra] + 0x0]]\]: 0x[format %04X [expr 0x$read_data + 0x0]]"

    # Check read data if relevant
    if $check_data {
      puts -nonewline " - 0x[format %04X [expr 0x[lindex $expected_data $jj] + 0x0]]"
      if {[expr 0x$read_data + 0x0] == [expr 0x[lindex $expected_data $jj] + 0x0]} {
        puts -nonewline " - OK"
      } else {
        puts -nonewline " - MISMATCH"
        incr data_check_error_count
      }
    }
    puts ""
  }

  puts ""
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
lappend data "000D"
lappend data "100D"
lappend data "200D"
lappend data "300D"
lappend data "400D"
lappend data "500D"
lappend data "600D"
lappend data "700D"
lappend data "800D"
lappend data "900D"
lappend data "A00D"
lappend data "B00D"
lappend data "C00D"
lappend data "D00D"
lappend data "E00D"
lappend data "F00D"
lappend data "010D"
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
lappend data "AF0D"
lappend data "BF0D"
lappend data "CF0D"
lappend data "DF0D"
lappend data "EF0D"
lappend data "FF0D"


# Read original contetns of ROM (no checking)
read_rom_contents {}

# Write contents or ROMs
write_rom_contents $data

# Read contents of ROMs and check
read_rom_contents $data

# Write original contents of ROMs
write_rom_contents $orig_data

# Read again and check
read_rom_contents $orig_data

if {$data_check_error_count > 0} {
  puts "ERROR: Data Check FAILED ($data_check_error_count error(s) found)"
} else {
  puts "INFO: Data Check PASSED"
}
