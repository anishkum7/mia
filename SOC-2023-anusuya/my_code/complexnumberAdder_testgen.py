import numpy as np
import subprocess
import os
import math
import random
import struct

# define double_to_hex (or float_to_hex)
def double_to_hex(f):
    return hex(struct.unpack('<Q', struct.pack('<d', f))[0])


a_real_part= random.uniform(0,1000)
a_complex_part = random.uniform(0,1000)
b_real_part= random.uniform(0,1000)
b_complex_part = random.uniform(0,1000)
a_real_hex= double_to_hex(a_real_part)
a_complex_hex = double_to_hex(a_complex_part)
b_real_hex= double_to_hex(b_real_part)
b_complex_hex = double_to_hex(b_complex_part)
with open("input.txt","w+") as ip:
    ip.write(a_real_hex[2:]+"\n")
    ip.write(a_complex_hex[2:] + "\n")
    ip.write(b_real_hex[2:] + "\n")
    ip.write(b_complex_hex[2:] + "\n")
os.system("iverilog -o mac_manual.vvp tb_complex_number_adder.sv dfpu_complex_adder.sv dfpu_adder.sv")
# os.system("vvp mac_manual.vvp ")
