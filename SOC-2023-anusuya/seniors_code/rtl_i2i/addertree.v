`timescale 1ns / 1ps
module addertree(
    input clk,
    input rst,
    input [1023:0] tempc,
    input [7:0] pedone,
    output reg tempc_ack,
    output reg [255:0] c,
    output reg done
);

    reg [63:0] adderinp [0:3];

    
    reg add1_a_stb;
    reg add1_b_stb;
    reg c1_ack;
    wire [63:0] c1;
    wire c1_stb;
    wire add1_a_ack;
    wire add1_b_ack;

    reg add2_a_stb;
    reg add2_b_stb;
    reg c2_ack;
    wire [63:0] c2;
    wire c2_stb;
    wire add2_a_ack;
    wire add2_b_ack;

    reg add3_a_stb;
    reg add3_b_stb;
    reg c3_ack;
    wire [63:0] c3;
    wire c3_stb;
    wire add3_a_ack;
    wire add3_b_ack;
    reg [63:0] c1_z;
    reg [63:0] c2_z;

    
    
    double_adder adder1(adderinp[0], adderinp[1], add1_a_stb, add1_b_stb, c1_ack, 
                        clk, rst, c1, c1_stb, add1_a_ack, add1_b_ack);
    double_adder adder2(adderinp[2], adderinp[3], add2_a_stb, add2_b_stb, c2_ack, 
                        clk, rst, c2, c2_stb, add2_a_ack, add2_b_ack);

    double_adder adder3(c1_z, c2_z, add3_a_stb, add3_b_stb, c3_ack, 
                        clk, rst, c3, c3_stb, add3_a_ack, add3_b_ack);
    


    reg [1023:0] tempc_flop;
    reg [1:0] cnt;
    reg [1:0] state,state2;
    reg state2_start;
    reg [1:0] cnt_z;
    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            tempc_ack <= 0;
            tempc_flop <= 0;
            cnt <= 0;
            state <= 0;
            c1_ack <= 0;
            c2_ack <= 0;
            done <= 0;
            state2_start <= 0;
            state2 <= 0;
            c3_ack <= 0;
        end
        else
        begin
            case(state)
                0:
                begin
                    c1_ack <= 0;
                    c2_ack <= 0;
                    done <= 0;
                    state2_start <= 0;
                    if(pedone == 8'hFF)
                    begin
                        tempc_flop <= tempc;
                        tempc_ack <= 1;
                        state <= 1;
                    end
                    else
                    begin
                        state <= 0;
                    end
                end
                1:
                begin
                    state2_start <= 0;
                    if(cnt == 0)
                    begin
                        adderinp[0] <= tempc_flop[127:64]; //1
                        adderinp[1] <= tempc_flop[255:192]; //3
                        adderinp[2] <= tempc_flop[383:320]; //5
                        adderinp[3] <= tempc_flop[511:448]; //7
                        add1_a_stb <= 1;
                        add1_b_stb <= 1;
                        add2_a_stb <= 1;
                        add2_b_stb <= 1;
                    end
                    else if(cnt == 1)
                    begin
                        adderinp[0] <= tempc_flop[63:0]; // 0
                        adderinp[1] <= tempc_flop[191:128]; //2
                        adderinp[2] <= tempc_flop[319:256]; // 4
                        adderinp[3] <= tempc_flop[447:384]; // 6
                        add1_a_stb <= 1;
                        add1_b_stb <= 1;
                        add2_a_stb <= 1;
                        add2_b_stb <= 1;
                    end
                    else if(cnt == 2)
                    begin
                        adderinp[0] <= tempc_flop[639:576]; //9
                        adderinp[1] <= tempc_flop[767:704]; // 11
                        adderinp[2] <= tempc_flop[895:832]; // 13
                        adderinp[3] <= tempc_flop[1023:960]; // 15
                        add1_a_stb <= 1;
                        add1_b_stb <= 1;
                        add2_a_stb <= 1;
                        add2_b_stb <= 1;
                    end
                    else if (cnt == 3)
                    begin
                        adderinp[0] <= tempc_flop[575:512]; // 8
                        adderinp[1] <= tempc_flop[703:640]; // 10
                        adderinp[2] <= tempc_flop[831:768]; // 12
                        adderinp[3] <= tempc_flop[959:896]; // 14
                        add1_a_stb <= 1;
                        add1_b_stb <= 1;
                        add2_a_stb <= 1;
                        add2_b_stb <= 1;
                    end
                    if(c1_stb == 1 && c2_stb == 1)
                    begin
                        add1_a_stb <= 0;
                        add1_b_stb <= 0;
                        add2_a_stb <= 0;
                        add2_b_stb <= 0;
                        state <= 2;                        
                    end
                    else
                    begin
                        state <= 1;
                    end
                    // if(c1_stb == 1 && c2_stb == 1 && c3_stb == 1)
                    // begin
                    //     state <= 2;                        
                    // end
                    // else
                    // begin
                    //     state <= 1;
                    // end
                end
                2:
                begin
                    state2_start <= 1;
                    if(c1_ack && c2_ack)
                    begin
                        c1_ack <= 0;
                        c2_ack <= 0;
                        if(cnt == 3)
                        begin
                            state <= 3;
                            // if(c3_stb == 1)
                            // begin
                            //     cnt <= 0;
                            //     state <= 0;
                            //     done <= 1; 
                            // end
                            // else
                            // begin
                            //     cnt_z <= cnt;
                            //     state <= 2;
                            // end
                        end
                        else
                        begin
                            cnt_z <= cnt;
                            cnt <= cnt + 1;
                            state <= 1;
                        end
                    end
                end
                3:
                begin
                    if(c3_stb == 1)
                    begin
                        cnt <= 0;
                        state <= 0;
                        done <= 1; 
                    end
                    else
                    begin
                        cnt_z <= cnt;
                        state <= 3;
                    end
                end
            endcase
        end
    end

    
   
    always@(posedge clk)
    begin
        case(state2)
            0:
            begin
                c3_ack <= 0;
                if(state2_start == 1)
                begin
                    c1_z <= c1;
                    c2_z <= c2;
                    // cnt_z <= cnt;
                    add3_a_stb <= 1;
                    add3_b_stb <= 1;
                    if(add3_b_ack == 1)
                    begin
                        c1_ack <= 1;
                        c2_ack <= 1;
                        state2 <= 1;
                    end
                    else
                    begin
                        state2 <= 0;
                    end
                end
                else
                begin
                    state2 <= 0;
                end
            end
            1:
            begin
                c1_ack <= 0;
                c2_ack <= 0;
                add3_a_stb <= 0;
                add3_b_stb <= 0;
                if(c3_stb == 1)
                begin
                    c[cnt_z*64 +: 64] <= c3; // c[ cnt_z*64+64-1 :cnt_z*64]
                    c3_ack <= 1;
                    state2 <= 0;
                end
                else
                begin
                    state2 <= 1;                    
                end
            end
        endcase
    end

endmodule
