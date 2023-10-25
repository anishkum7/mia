`timescale 1ns / 1ps
module multpe(
    input clk,
    // input [1:0] addr,
    input [63:0] inpa,
    input [63:0] inpb1,
    input [63:0] inpb2,
    input rst,
    input valid,
    input start,
    input outack,
    output reg done,
    output reg [127:0] c
);

    reg [1:0] state;
    reg [1:0] next_state;

    reg [63:0] mult_b;
    reg [63:0] mult_a;
    reg [63:0] a;
    reg [127:0] b;
    wire a_ack;
    wire b_ack;
    wire c_stb;
    reg c_ack;
    reg a_stb;
    reg b_stb;
    // reg [127:0] c;
    wire [63:0] z;
    reg cnt;

    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            mult_a <= 0;
            mult_b <= 0;
            cnt <= 0;
            c_ack <= 0;
            done <= 0;
            state <= 0;
            c <= 0;
            // outack <= 0;
        end
        case(state)
            2'd0:
            begin
                cnt <= 0;
                if(rst == 1'b1)
                begin
                    mult_a <= 0;
                    mult_b <= 0;
                    cnt <= 0;
                    c_ack <= 0;
                    done <= 0;
                    c <= 0;
                end
                else
                begin
                    done <= 0;
                    if(valid == 1'b1)
                    begin
                        a <= inpa;
                        b[127:64] <= inpb2;
                        b[63:0] <= inpb1;
                    end
                end 
                if(start != 1'b1)
                begin
                    state <= 0;
                end
                else
                begin
                    state <= 1;
                end
            end    
            2'd1:
            begin
                mult_a <= a;
                mult_b <= b[cnt*64+:64];
                a_stb <= 1;
                b_stb <= 1;
                if(c_stb == 0)
                begin
                    state <= 1;
                end
                else
                begin
                    c[cnt*64+:64] <= z;
                    state <= 2;
                end
            end
            2'd2:
            begin
                c_ack <= 1;
                a_stb <= 0;
                b_stb <= 0;
                if(c_stb == 1)
                begin
                    state <= 2;
                end
                else if(cnt == 0)
                begin
                    cnt <= 1;
                    state <= 1;
                end
                else if(cnt == 1)
                begin
                    // cnt <= 0;
                    done <= 1;
                    if(outack == 0)
                    begin
                        state <= 2;
                    end
                    else
                    begin
                        state <= 0;
                    end
                end
            end
        endcase
    end

    double_multiplier mult(mult_a, mult_b, a_stb, b_stb, c_ack, clk, rst, z, c_stb, a_ack, b_ack);
    
    // assign out = c;

endmodule