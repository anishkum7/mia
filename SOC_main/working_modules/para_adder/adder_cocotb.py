import cocotb
from cocotb.triggers import Timer

@cocotb.test()

async def my_first_test(dut):

    # Initializing values
    dut.rst.value = 1
    dut.start.value = 1
    dut.start.ready = 1

    dut.a.value = 2000043222212
    dut.b.value = 2000422213123


    dut.clk.value = 0
    await Timer(100, units="ns")
    dut.clk.value=1
    await Timer(100, units="ns")
    dut.clk.value = 0
    await Timer(100, units="ns")
    dut.clk.value=1
    await Timer(100, units="ns")

    dut.rst.value = 0

    for cycle in range(1000):
        dut.clk.value = 0
        await Timer(100, units="ns")
        dut.clk.value = 1
        await Timer(100, units="ns")

        
    dut._log.info("Value of A = %s", dut.a.value)
    dut._log.info("Value of B = %s", dut.b.value)

    # dut._log.info("Value of state = %s", dut.state.value)
    # dut._log.info("Value of c_stb_flag = %s", dut.c_stb_flag.value)
    # dut._log.info("Value of done = %s", dut.done.value)
    # dut._log.info("Value of add_in1 = %s", dut.add_in1.value)

    dut._log.info("Value of C = %s", dut.c.value)
