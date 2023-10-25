module fpu_mac_avalon_fordma(
                clk,
                reset,
                address,
                writedata,
                write,
                read,
                readdata,
                waitrequest);

    input              clk;
    input              reset;

    input        [7:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input       [31:0] writedata; // 32-bit write data line
    input              write;            // write request from the Avalon bus
    input              read;             // read request from the Avalon bus
    output      [31:0] readdata; // 32-bit data line read by the Avalon bus
    output reg         waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted

    //Memory mapped registers
    //TODO Sarang - Make this memory bank bigger?
    reg         [31:0] input_a;
    reg         [31:0] input_b;
    reg                reset_2;
    wire        [31:0] add_output_z;

    reg                input_a_stb;
    reg                input_b_stb;
    reg                add_output_z_ack;

    wire               input_a_ack;
    wire               input_b_ack;
    wire               add_output_z_stb;

    wire               mult_output_z_ack;
    wire        [31:0] mult_output_z;
    wire               mult_output_z_stb;

    reg         [31:0] mult_output_z_q;
    reg                mult_output_z_stb_q;
    reg         [31:0] add_output_z_q;
    reg                add_output_z_stb_q;

    //new additions for dma
    reg [31:0] fifoa[0:63];
    reg [31:0] fifob[0:63];
    reg [31:0] cnt_reg;
    reg [31:0] cnt;
    reg [31:0] stb_cnt;
    reg start;




    //input_a of adder is flopped output_z of multiplier, input_b of adder is flopped output_z of adder 
    multiplier  multiplier_inst(input_a, input_b, input_a_stb, input_b_stb, /*output_z_ack*/ mult_output_z_ack, clk, reset || reset_2, /*output_z*/ mult_output_z, /*output_z_stb*/ mult_output_z_stb, input_a_ack, input_b_ack);

    adder       adder_inst(/*input_a*/ mult_output_z_q, /*input_b*/ add_output_z_q, /*input_a_stb*/ mult_output_z_stb_q, /*input_b_stb*/ add_output_z_stb_q, /*output_z_ack*/ add_output_z_ack, clk, reset || reset_2, /*output_z*/ add_output_z, /*output_z_stb*/ add_output_z_stb, /*input_a_ack*/ mult_output_z_ack, /*input_b_ack*/ add_output_z_q_ack);

    always @ (posedge clk)
    begin
        if (reset == 1'b1 || reset_2 == 1'b1)
        begin 
            input_a             <= 0;
            input_b             <= 0;
            input_a_stb         <= 0;
            input_b_stb         <= 0;
            waitrequest         <= 0;
            //Reset value of flop after multiplier
            mult_output_z_q     <= 0;
            mult_output_z_stb_q <= 0;
            //Reset value of flop after adder
            add_output_z_q      <= 0;
            add_output_z_stb_q  <= 1;
            //Permanently tying output_z_ack to 1
            add_output_z_ack    <= 1;
            //Making readdata 0 on reset
            reset_2             <= 0;
            cnt <= 0;
            stb_cnt <= 0;
            cnt_reg <= 32'd64;
        end
        else
        begin 
            // if (input_b_stb) begin
            //     waitrequest = 1;
            // end
            // if (mult_output_z_ack && mult_output_z_stb) begin
            //     waitrequest = 0;
            // end

            if(write == 1'b1 && !waitrequest)
            begin
                case(address) 
                    8'd129: begin
                        cnt_reg <= writedata;
                    end 
                    8'd128: begin
                        reset_2 <= 1;
                        cnt <= 0;
                    end 
                    8'd130: begin
                        start <= 1;
                        cnt <= 0;
                        stb_cnt <= 0;
                        waitrequest <= 1;
                    end
                    default: begin
                        if(address >= 8'd64)
                        begin
                            fifob[address - 8'd64] <= writedata;
                        end
                        else
                        begin
                            fifoa[address] <= writedata;
                        end
                    end
                    // 3'h0: begin 
                    //         input_a     <= writedata; 
                    //         input_a_stb <= 1; 
                    //       end
                    // 3'h1: begin 
                    //         input_b     <= writedata; 
                    //         input_b_stb <= 1; 
                    //       end
                    // 3'h2: begin
                    //         reset_2     <= 1;
                    //       end
                endcase
            end

            if(start) begin
                if(mult_output_z_stb) begin
                    stb_cnt <= stb_cnt + 1;
                end
                if(stb_cnt == cnt_reg) begin
                    waitrequest <= 0;
                    start <= 0;
                end
                if(cnt == cnt_reg) begin
                    // waitrequest <= 0;
                    // start <= 0;
                    if(input_a_stb && input_a_ack) begin
                        input_a_stb <= 0;
                    end
                    if(input_b_stb && input_b_ack) begin
                        input_b_stb <= 0;
                        // waitrequest <= 0;
                        // start <= 0;
                    end
                end
                else begin
                    if(input_a_stb && input_a_ack) begin
                        input_a_stb <= 0;
                    end
                    else if(input_a_stb == 0) begin
                        input_a <= fifoa[cnt];
                        input_a_stb <= 1;
                    end
                    if(input_b_stb && input_b_ack) begin
                        input_b_stb <= 0;
                    end
                    else if(input_b_stb == 0) begin
                        input_b <= fifob[cnt];
                        input_b_stb <= 1;
                        cnt <= cnt + 1;
                    end
                end
            end

            // if (input_a_stb && input_a_ack) begin
            //     input_a_stb <= 0;
            // end
            // if (input_b_stb && input_b_ack) begin
            //     input_b_stb <= 0;
            // end

            //Flop stages
            mult_output_z_q     <= mult_output_z;
            mult_output_z_stb_q <= mult_output_z_stb;
            add_output_z_q      <= add_output_z;
            //add_output_z_stb_q  <= add_output_z_stb;
        end
    end
    assign readdata = read ? (!waitrequest ? add_output_z : 0) : 0;
endmodule
