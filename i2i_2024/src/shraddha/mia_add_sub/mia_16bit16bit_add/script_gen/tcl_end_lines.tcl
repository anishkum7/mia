
# Read original contetns of ROM (no checking)
read_rom_contents {}
#read_dut_values {}

# Write contents or ROMs
write_rom_contents $data

# Read contents of ROMs and check
read_rom_contents $data
read_dut_values $data

# Write original contents of ROMs
#write_rom_contents $orig_data

# Read again and check
#read_rom_contents $orig_data
#read_dut_values {}
if {$data_check_error_count > 0} {
  puts "ERROR: Data Check FAILED ($data_check_error_count error(s) found)"
} else {
  puts "INFO: Data Check PASSED"
}
