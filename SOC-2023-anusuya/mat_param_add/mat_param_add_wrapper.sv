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
    
    input        [3:0] address;    //The address of the regfiles (a and b)
    input       [63:0] writedata; // 64-bit represents the whole word, while the write line is actually 32-bits each time
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    input       [7:0]  byteenable;             // byte enable
    output [63:0] readdata; // 32-bit data line read by the Avalon bus
    output reg  waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted


    reg [1:0] state;

    reg [63:0] a[0:mat_add_gen - 1];
    reg [63:0] b[0:mat_add_gen - 1 ];
    reg [63:0] c[0:mat_add_gen -1 ];

    // reg [10:0] cntxa;

    reg sel;
    reg start;
    reg [mat_add_gen * 64 -1 : 0] inpa;
    reg [mat_add_gen * 64 -1 : 0] inpb;
    wire [mat_add_gen * 64 -1 : 0] outc;
    wire done;
    integer j;

    mat_param_add  #(.mat_add_gen(mat_add_gen)) u0(.clk(clk),
                                                    .rst(reset),
                                                    .a(inpa),
                                                    .b(inpb),
                                                    .start(start),
                                                    .c(outc),
                                                    .done(done));


    assign readdata = read ? c[address]:0; 
    always@(posedge clk)
    begin
        if(reset == 1)
        begin
            state <= 0;
            waitrequest <= 0;
            // cntxa <= 0;
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
                        if(address != 2 * mat_add_gen) 
                        begin 
                            if(write == 1 && address < mat_add_gen)
                            begin 
                                if(byteenable == 8'h0F)
                                begin 
                                    a[address][31:0] <= writedata[31:0];
                                end
                                else if(byteenable == 8'hF0)
                                begin 
                                    a[address][64:32] <= writedata[63:32];
                                end
                                state <= 0;
                            end
                        //Writing to b matrix
                        else if(write == 1 && address >= 2*mat_add_gen)
                        begin 
                            if(byteenable == 8'h0F)
                            begin 
                                b[address - mat_add_gen][31:0] <= writedata[31:0];
                            end
                            else if (byteenable == 8'hF0)
                            begin 
                                 b[address - mat_add_gen][63:32] <= writedata[63:32];
                            end
                            state <= 0;
                        end
                        end
                        else if (address == 2 * mat_add_gen)
                            begin 
                                state <= 1;
                                waitrequest <= 1;
                            end
                    end
                1:
                    begin

                        for(j = 0; j < mat_add_gen; j++) begin
                            inpa [64 * j +: 64] <= a[j];
                            inpb [64 * j +: 64] <= b[j];
                        end

                        start <= 1;
                        if(done == 1) begin 
                            state <= 2;
                        end
                    end
                2:
                begin
                    for(j = 0; j < mat_add_gen; j++) begin 
                        c[j] <= outc[64 * j +: 64];
                    end
                    state <= 0;
                    waitrequest <= 0;
                 end


            endcase
        end
    end



endmodule
