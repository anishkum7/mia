module fpu_adder_avalon(
                clk,
                reset,
                address,
                writedata,
                write,
                read,
                readdata,
                waitrequest);

    input     clk;
    input     reset;

    input [2:0] address;    // 3-bit address coming from the Avalon bus (need only 3 bits to address 8 memory-mapped registers)
    input [31:0] writedata; // 32-bit write data line
    input write;            // write request from the Avalon bus
    input read;             // read request from the Avalon bus
    output reg [31:0] readdata; // 32-bit data line read by the Avalon bus
    output reg waitrequest; // tells the Avalon bus to perform read/write after waitrequest is deasserted

    //Memory mapped registers
    //TODO Sarang - Make this memory bank bigger?
    reg       [31:0] input_a;
    reg       [31:0] input_b;
    wire      [31:0] output_z;

    reg              input_a_stb;
    reg              input_b_stb;
    reg              output_z_ack;

    wire             input_a_ack;
    wire             input_b_ack;
    wire             output_z_stb;


    adder adder_inst(input_a, input_b, input_a_stb, input_b_stb, output_z_ack, clk, reset, output_z, output_z_stb, input_a_ack, input_b_ack);

    always @ (posedge clk)
    begin
        if (reset == 1'b1)
        begin 
            input_a <= 0;
            input_b <= 0;
            input_a_stb <= 0;
            input_b_stb <= 0;
            output_z_ack <= 0;
            waitrequest <= 0;
        end
        else
        begin 
            if(write == 1'b1)
            begin
                case(address) 
                    3'h0: begin input_a <= writedata; input_a_stb <= 1; end
                    3'h1: begin input_b <= writedata; input_b_stb <= 1; end
                endcase
            end
            if (input_a_stb && input_a_ack) begin
                input_a_stb <= 0;
            end
            if (input_b_stb && input_b_ack) begin
                input_b_stb <= 0;
                output_z_ack <= 1;
                waitrequest <= 1;
            end
            if (output_z_ack && output_z_stb) begin
                output_z_ack <= 0;
                waitrequest <= 0;
            end
            if(read == 1'b1) 
            begin
                readdata = output_z;
            end
        end
    end
endmodule
