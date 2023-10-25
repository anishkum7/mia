import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import Timer

@cocotb.test()
async def test_cmult_simple(dut):
    dut.rst.value=1
    dut.input_a_real.value= 10
    dut.input_a_imag.value=-10
    dut.input_b_real.value= -10
    dut.input_b_imag.value= 10

    dut.clk.value = 0
    await Timer(10, units="ps")
    dut.clk.value=1
    await Timer(10, units="ps")
    dut.clk.value = 0
    await Timer(10, units="ps")
    dut.clk.value=1
    await Timer(10, units="ps")

    dut.rst.value = 0

    for cycle in range(1000):
        dut.clk.value = 0
        await Timer(10, units="ps")
        dut.clk.value = 1
        await Timer(10, units="ps")
    dut._log.info("Value of A = %s+j%s\n", dut.input_a_real.value,dut.input_a_imag)
    dut._log.info("Value of B = %s+j%s\n", dut.input_b_real.value,dut.input_b_imag)
    
    dut._log.info("Value of Intermediary products = %s, %s, %s, %s \n", dut.real_product_1,dut.real_product_2,dut.imag_product_1,dut.imag_product_2)
    dut._log.info("Value of Z = %s+j%s\n", dut.output_z_real.value,dut.output_z_imag)



