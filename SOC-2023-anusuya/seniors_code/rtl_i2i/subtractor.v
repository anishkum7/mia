`timescale 1ns/1ps

module subtractor(
    input clk,
    input rst,
    input sel,
//    input valid,
    input start,
    input [1023:0] inpa,
    input [1023:0] inpb,
    output reg [1023:0] c,
    output reg done
);

    reg [63:0] sub_in1[0:3];
	reg [63:0] sub_in2[0:3];
	reg a_stb_sub[0:3]; reg b_stb_sub[0:3]; reg c_ack_sub[0:3];
	wire [63:0] sub_out[0:3];
	wire c_stb_sub[0:3]; wire a_ack_sub[0:3]; wire b_ack_sub[0:3];

    double_adder sub0(
	                      .input_a(sub_in1[0]),
								 .input_b(sub_in2[0]),
								 .input_a_stb(a_stb_sub[0]),
								 .input_b_stb(b_stb_sub[0]),
								 .output_z_ack(c_ack_sub[0]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[0]),
								 .output_z_stb(c_stb_sub[0]),
								 .input_a_ack(a_ack_sub[0]),
								 .input_b_ack(b_ack_sub[0]));
								 
	double_adder sub1(
	                      .input_a(sub_in1[1]),
								 .input_b(sub_in2[1]),
								 .input_a_stb(a_stb_sub[1]),
								 .input_b_stb(b_stb_sub[1]),
								 .output_z_ack(c_ack_sub[1]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[1]),
								 .output_z_stb(c_stb_sub[1]),
								 .input_a_ack(a_ack_sub[1]),
								 .input_b_ack(b_ack_sub[1]));
								 
	double_adder sub2(
	                      .input_a(sub_in1[2]),
								 .input_b(sub_in2[2]),
								 .input_a_stb(a_stb_sub[2]),
								 .input_b_stb(b_stb_sub[2]),
								 .output_z_ack(c_ack_sub[2]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[2]),
								 .output_z_stb(c_stb_sub[2]),
								 .input_a_ack(a_ack_sub[2]),
								 .input_b_ack(b_ack_sub[2]));
    
    double_adder sub3(
	                      .input_a(sub_in1[3]),
								 .input_b(sub_in2[3]),
								 .input_a_stb(a_stb_sub[3]),
								 .input_b_stb(b_stb_sub[3]),
								 .output_z_ack(c_ack_sub[3]),
								 .clk(clk),
								 .rst(rst),
								 .output_z(sub_out[3]),
								 .output_z_stb(c_stb_sub[3]),
								 .input_a_ack(a_ack_sub[3]),
								 .input_b_ack(b_ack_sub[3]));

    reg[2:0] state;
    reg[1:0] cnt;

    always@(posedge clk)
    begin
        if(rst == 1)
        begin
			state <= 0;
			cnt <= 0;
			done <= 0;
        end
        else
        begin
            case(state)
                0:
                begin
                    done <= 0;
                    cnt <= 0;
                    if(start == 1)
                    begin
                        state <= 1;
                    end
                end

                1:
                begin
                    sub_in1[0] <= inpa[cnt*64 +: 64];
                    sub_in1[1] <= inpa[(cnt+4)*64 +: 64];
                    sub_in1[2] <= inpa[(cnt+8)*64 +: 64];
                    sub_in1[3] <= inpa[(cnt+12)*64 +: 64];
                    if(sel == 1)
                    begin
                        sub_in2[0] <= {~inpb[cnt*64+63], inpb[cnt*64 +: 63]};
                        sub_in2[1] <= {~inpb[((cnt+4)*64)+63], inpb[(cnt+4)*64 +: 63]};
                        sub_in2[2] <= {~inpb[((cnt+8)*64)+63], inpb[(cnt+8)*64 +: 63]};
                        sub_in2[3] <= {~inpb[((cnt+12)*64)+63], inpb[(cnt+12)*64 +: 63]};
                    end
                    else
                    begin
                        sub_in2[0] <= inpb[cnt*64 +: 64];
                        sub_in2[1] <= inpb[(cnt+4)*64 +: 64];
                        sub_in2[2] <= inpb[(cnt+8)*64 +: 64];
                        sub_in2[3] <= inpb[(cnt+12)*64 +: 64];
                    end
                    a_stb_sub[0] <= 1;
                    a_stb_sub[1] <= 1;
                    a_stb_sub[2] <= 1;
                    a_stb_sub[3] <= 1;

                    b_stb_sub[0] <= 1;
                    b_stb_sub[1] <= 1;
                    b_stb_sub[2] <= 1;
                    b_stb_sub[3] <= 1;
                    state <= 3;
                end
                3:
                begin
                    if({c_stb_sub[3],c_stb_sub[2],c_stb_sub[1],c_stb_sub[0]} == 4'hF)
                    begin
                        c_ack_sub[3] <= 1;
                        c_ack_sub[2] <= 1;
                        c_ack_sub[1] <= 1;
                        c_ack_sub[0] <= 1;   
                        c[cnt*64 +: 64] <= sub_out[0];
                        c[(cnt+4)*64 +: 64] <= sub_out[1];
                        c[(cnt+8)*64 +: 64] <= sub_out[2];
                        c[(cnt+12)*64 +: 64] <= sub_out[3];
                        state <= 2;
                        a_stb_sub[0] <= 0;
                        a_stb_sub[1] <= 0;
                        a_stb_sub[2] <= 0;
                        a_stb_sub[3] <= 0;

                        b_stb_sub[0] <= 0;
                        b_stb_sub[1] <= 0;
                        b_stb_sub[2] <= 0;
                        b_stb_sub[3] <= 0;

		
                    end
		    else
	            begin
                        state <= 3;
		    end
                end

                2:
                begin
                    c_ack_sub[3] <= 0;
                    c_ack_sub[2] <= 0;
                    c_ack_sub[1] <= 0;
                    c_ack_sub[0] <= 0;

                    a_stb_sub[0] <= 0;
                    a_stb_sub[1] <= 0;
                    a_stb_sub[2] <= 0;
                    a_stb_sub[3] <= 0;

                    b_stb_sub[0] <= 0;
                    b_stb_sub[1] <= 0;
                    b_stb_sub[2] <= 0;
                    b_stb_sub[3] <= 0;
                    if(cnt == 2'd3)
                    begin
                        cnt <= 0;
                        state <= 0;
                        done <= 1;
                    end           
                    else
                    begin
                        cnt <= cnt + 1;
                        state <= 1;
                    end         
                end
            endcase
        end
    end


endmodule

