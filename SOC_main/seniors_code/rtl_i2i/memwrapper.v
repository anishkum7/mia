module avalon_mem_wrapper(
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

// module ram2port (
// 	clock,
// 	data,
// 	rdaddress,
// 	rden,
// 	wraddress,
// 	wren,
// 	q);

    input              clk;
    input              reset;
    
    input        [11:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input       [63:0] writedata; // 32-bit write data line
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted

    reg [63:0] data;
    reg [11:0] raddress;
    reg [11:0] wraddress;
    reg rden;
    reg wren;
    wire [63:0] q;
    ram2port ramu(clk, data, address, read, wraddress, wren, q);
    assign readdata = q;

    reg [2:0] state;
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
                            data[31:0] <= writedata[31:0];
                        end
                        else if(byteenable == 8'hF0)
                        begin
                            data[63:32] <= writedata[63:32];
                            wren <= 1;
                            wraddress <= address;
                        end
                        state <= 0;
                        waitrequest <= 0;
                    end
                    else if(read == 1 && !waitrequest)
                    begin
                        wren <= 0;
                        waitrequest <= 1;
                        state <= 1;
                    end
		    else 
	            begin
		    	state <= 0;
                wren <= 0;
		    end
                end
                1:
                begin
                    waitrequest <= 0;
                    state <= 0;
                end
            endcase
        end
    end



endmodule
