module avalonwrap_matadd
    #(parameter mat_add_gen = 4)(
    clk,
    reset,
    address,
    writedata,
    write,
    read,
    byteenable,
    readdata,
    waitrequest
);
    input              clk;
    input              reset;
    
    input        [20:0] address;    //The address of the regfiles (a and b)
    input       [63:0] writedata; // 64-bit represents the whole word, while the write line is actually 32-bits each time
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest;

    reg [1:0] state;

    reg [63:0] a[0:mat_add_gen - 1];
    reg [63:0] b[0:mat_add_gen - 1 ];
    reg [63:0] c[0:mat_add_gen -1 ];

endmodule