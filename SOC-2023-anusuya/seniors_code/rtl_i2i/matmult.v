`timescale 1ns / 1ps
module matmult(
    input clk,
    input rst,
    input valid,
    input start,
    input [2:0] addra,
    input [63:0] inpa,
    input [2:0] addrb,
    input [63:0] inpb,
    output [255:0] c,
    output done
);

wire [1023:0] tempc;
wire tempc_ack;
wire [7:0] pedone;


peblock pe_inst(clk,rst,valid,start,addra,inpa,addrb,inpb,tempc_ack, tempc,pedone);

addertree addertree_inst(clk,rst,tempc,pedone,tempc_ack,c,done);


endmodule
