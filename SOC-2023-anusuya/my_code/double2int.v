module double2int(
    input clk,
    input rst,
    input [63:0] vin,
    output reg [52:0] vout,
    output reg done,
    output reg error
    );

    wire sign = vin[63];
    wire [10:0] exponent = vin[62:52];
    wire [51:0] binaryfraction = vin[51:0];
    wire [52:0] mantissa = {1'b1,binaryfraction};

    reg [5:0] cnt;
    reg start = 1'b0;
    reg round;
    always @(posedge clk) begin
        if (rst) begin
            if (sign==1'b0 && exponent >= 11'd1023 && exponent <= 11'd1075) begin
            // only convert positive numbers between 0 and 2^52
                cnt <= 52 - (exponent - 11'd1023); // how many bits to discard from mantissa
                {vout,round} <= {mantissa,1'b0};
                start <= 1'b1;
                done <= 1'b0;
                error <= 1'b0;
            end
            else begin
                start <= 1'b0;
                error <= 1'b1;
            end
        end
        else if (start) begin
            if (cnt != 0) begin  // not finished yet?
                cnt <= cnt - 1;  // count one bit to discard
                {vout,round} <= {1'b0, vout[52:0]}; // and discard it (bit just discarded goes into "round")
            end
            else begin  // finished discarding bits then?
                if (round)  // if last bit discarded was high, increment vout
                    vout <= vout + 1;
                start <= 1'b0;
                done <= 1'b1; // signal we're done
            end
        end
    end
endmodule