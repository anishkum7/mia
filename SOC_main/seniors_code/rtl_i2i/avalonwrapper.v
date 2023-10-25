/*

Avalon Wrapper for RAM operations



*/
`timescale 1ns / 1ps
module avalonwrap(
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
    
    input        [11:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input       [63:0] writedata; // 32-bit write data line
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted

    // reg [11:0] addr;
    reg [63:0] data;
    reg [11:0] raddress;
    reg [11:0] wraddress;
    reg rden;
    reg wren;
    wire [63:0] q;
    ram2port ramu(clk, ram_data, ram_raddress, ram_rden, ram_wraddress, ram_wren, ram_q);
   

    reg [2:0] state;

    matmult multobj(clk, reset, valid, start, addra, inpa, addrb, inpb, c, done);

    reg valid;
    reg start;
    reg [2:0] addra;
    reg [63:0] inpa;
    reg [2:0] addrb;
    reg [63:0] inpb;
    wire [255:0] c;
    wire done;

    wire [63:0] ram_q;
    wire [11:0] ram_raddress;
    wire ram_rden;
    wire [63:0] ram_data;    
    wire [11:0] ram_waddress;
    wire ram_wren;

    reg [63:0] int_q;
    reg [11:0] int_raddress;
    reg int_rden;
    reg [63:0] int_data;    
    reg [11:0] int_waddress;
    reg int_wren;

    reg wrap_en;

    assign ram_wren = wrap_en ? wren: int_wren;
    assign ram_rden = wrap_en ? read: int_rden;
    assign ram_waddress = wrap_en ? wraddress : int_waddress;
    assign ram_raddress = wrap_en ? address : int_raddress;
    assign readdata = wrap_en ? q : 64'h0;

    //handle read out from syncram to internal compute in the statemachine 
    


    


    always@(posedge clk)
    begin
        if(reset == 1)
        begin
            state <= 0;
            waitrequest <= 0;
            wren <= 0;
            rden <= 0;
            data <= 0;
            raddress <= 0;
            wraddress <= 0;
            cnt_row <= 0;
            cnt_col <= 0;
            wrap_en <= 1;
        end
        else
        begin
            case(state)
                0:
                begin    
                    
                    if(write == 1 && !waitrequest)
                    begin
                        rden <= 0;
                        if(byteenable == 8'h0F)
                        begin
                            ram_data[31:0] <= writedata[31:0];
                        end
                        else if(byteenable == 8'hF0)
                        begin
                            ram_data[63:32] <= writedata[63:32];
                            wren <= 1;
                            wraddress <= address;
                        end
                        state <= 0;
                        waitrequest <= 0;
                    end
                    else if(address == 'd4096)
                    begin
                        state <= 1;
                    end
                    else 
                        begin
                        state <= 0;
                    end
                end
                1:
                begin
                    
                end
            endcase
        end
    end


endmodule
