module avalonwrap_matadd(
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
    
    input        [9:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input       [63:0] writedata; // 32-bit write data line
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted


    reg [1:0] state;

    reg [63:0] a[0:255];
    reg [63:0] b[0:255];
    reg [63:0] c[0:255];

    reg [10:0] cntxa;
    // reg [5:0] cntya;

    // reg [5:0] cntxb;
    // reg [2:0] cntyb;

    

//     module contractor(
//     input clk,
//     input rst,
//     input sel,
// //    input valid,
//     input start,
//     input [1023:0] inpa,
//     input [1023:0] inpb,
//     output reg [1023:0] c,
//     output reg done
// );
    reg sel;
    reg start;
    reg [1023:0] inpa;
    reg [1023:0] inpb;
    wire [1023:0] outc;
    wire done;
    subtractor matadder(clk, reset, sel, start, inpa, inpb, outc, done);

    assign readdata = read ? c[address]:0; 
    always@(posedge clk)
    begin
        if(reset == 1)
        begin
            state <= 0;
            waitrequest <= 0;
            cntxa <= 0;
           //cntxb <= 0;
           //cntya <= 0;
           //cntyb <= 0;
            sel <= 0;
            start <= 0;
            inpa <= 0;
            inpb <= 0;
        end
        else
        begin
            case(state)
                0:
                begin  
                    if(address != 512)
                    begin  
                        if(write == 1 && address <256)
                        begin
                            if(byteenable == 8'h0F)
                            begin
                                a[address][31:0] <= writedata[31:0];
                            end
                            else if(byteenable == 8'hF0)
                            begin
                                a[address][63:32] <= writedata[63:32];
                            end
                            state <= 0;
                        end
                        else if(write == 1 && address >= 256)
                        begin
                            if(byteenable == 8'h0F)
                            begin
                                b[address-256][31:0] <= writedata[31:0];
                            end
                            else if(byteenable == 8'hF0)
                            begin
                                b[address-256][63:32] <= writedata[63:32];
                            end
                            state <= 0;
                        end
                    end
                    else if(address == 512 && write == 1)
                    begin
                        state <= 1;
                        waitrequest <= 1;
                    end
		        end
                1:
                begin
                    inpa <= {a[cntxa+15], a[cntxa+14], a[cntxa+13], a[cntxa+12], a[cntxa+11], a[cntxa+10], a[cntxa+9], a[cntxa+8], a[cntxa+7], a[cntxa+6], a[cntxa+5], a[cntxa+4], a[cntxa+3], a[cntxa+2], a[cntxa+1], a[cntxa]};
                    inpb <= {b[cntxa+15], b[cntxa+14], b[cntxa+13], b[cntxa+12], b[cntxa+11], b[cntxa+10], b[cntxa+9], b[cntxa+8], b[cntxa+7], b[cntxa+6], b[cntxa+5], b[cntxa+4], b[cntxa+3], b[cntxa+2], b[cntxa+1], b[cntxa]};
                    start <= 1;
                    if(done == 1)
                    begin
                        state <= 2;
                    end
                end
                2:
                begin
		    start <= 0;
                    {c[cntxa+15], c[cntxa+14], c[cntxa+13], c[cntxa+12], c[cntxa+11], c[cntxa+10], c[cntxa+9], c[cntxa+8], c[cntxa+7], c[cntxa+6], c[cntxa+5], c[cntxa+4], c[cntxa+3], c[cntxa+2], c[cntxa+1], c[cntxa]} <= outc;
                    if(cntxa == 240)
                    begin
                        state <= 0;
                        cntxa <= 0;
                        waitrequest <= 0;
                    end
                    else
                    begin
                        state <= 1;
                        cntxa <= cntxa + 16;
                    end
                end

            endcase
        end
    end



endmodule
