`timescale 1ns / 1ps
module peblock(
    input clk,
    input rst,
    input valid,
    input start,
    input [2:0] addra,
    input [63:0] inpa,
    input [2:0] addrb,
    input [63:0] inpb,
    input tempc_ack,
    // output [1:0] addrc,
    output [1023:0] tempc,
    output [7:0] pedone
    // output reg done
);

    reg [63:0] arra [0:7];
    reg [63:0] arrb [0:7];
    reg peack;
    //wire [2:0] pedone;
    reg state;
    // reg [127:0] arrc [0:2];

    multpe pe11(clk, arra[0], arrb[0], arrb[1], rst, valid, start, peack, pedone[0], tempc[127:0]);
    multpe pe12(clk, arra[1], arrb[2], arrb[3], rst, valid, start, peack, pedone[1], tempc[255:128]);
    multpe pe13(clk, arra[2], arrb[4], arrb[5], rst, valid, start, peack, pedone[2], tempc[383:256]);
    multpe pe14(clk, arra[3], arrb[6], arrb[7], rst, valid, start, peack, pedone[3], tempc[511:384]);
    
    multpe pe21(clk, arra[4], arrb[0], arrb[1], rst, valid, start, peack, pedone[4], tempc[639:512]);
    multpe pe22(clk, arra[5], arrb[2], arrb[3], rst, valid, start, peack, pedone[5], tempc[767:640]);
    multpe pe23(clk, arra[6], arrb[4], arrb[5], rst, valid, start, peack, pedone[6], tempc[895:768]);
    multpe pe24(clk, arra[7], arrb[6], arrb[7], rst, valid, start, peack, pedone[7], tempc[1023:896]);


    always@(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            // addrc = 0;
            // tempc <= 1024'd0;
            arra[0] <= 64'h0;
            arra[1] <= 64'h0;
            arra[2] <= 64'h0;
            arra[3] <= 64'h0;
            arra[4] <= 64'h0;
            arra[5] <= 64'h0;
            arra[6] <= 64'h0;
            arra[7] <= 64'h0;

            arrb[0] <= 64'h0;
            arrb[1] <= 64'h0;
            arrb[2] <= 64'h0;
            arrb[3] <= 64'h0;
            arrb[4] <= 64'h0;
            arrb[5] <= 64'h0;
            arrb[6] <= 64'h0;
            arrb[7] <= 64'h0;
            
            state <= 0;
            peack <= 0;
            //done <= 0;
        end
        else
        begin
            case(state)
                0:
                begin
                    //done = 0;
                    peack <= 0;
                    if(valid == 1)
                    begin
                        arra[addra] <= inpa;
                        arrb[addrb] <= inpb;
                    end
                    if(start == 1)
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
                    if(pedone == 8'hFF)
                    begin
                        if(tempc_ack == 1)
                        begin
                            peack <= 1;
                            state <= 0;
                            // done <= 1;
                        end
                        else
                        begin
                            state <= 1;
                        end
                    end
                    else
                    begin
                        state <= 1;
                    end
                end
            endcase
        end
    end


endmodule
