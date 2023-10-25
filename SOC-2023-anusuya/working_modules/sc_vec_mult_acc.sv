`timescale 1ns / 1ps
module vec_mult_acc
#(parameter mat_add_gen = 2)(
    input clk,rst,start,valid,
    input[64*mat_add_gen-1:0] a_real,
    input[64*mat_add_gen-1:0] a_imag,
    input[64*mat_add_gen-1:0] b_real,
    input[64*mat_add_gen-1:0] b_imag,
    input out_read_ack,
    output reg[63:0] z_real,
    output reg[63:0] z_imag,
    output reg done);
    reg[2:0] state;
    reg [$clog2(mat_add_gen):0] count;
    reg [$clog2(mat_add_gen):0] index;

    reg[63:0] a_real_local[mat_add_gen-1:0];
    reg[63:0] a_imag_local[mat_add_gen-1:0];
    reg[63:0] b_real_local[mat_add_gen-1:0];
    reg[63:0] b_imag_local[mat_add_gen-1:0];

    reg[63:0] input_a_real, input_b_real, input_a_imag,input_b_imag,output_z_real,output_z_imag;
    reg input_a_real_stb,input_a_imag_stb,input_b_real_stb,input_b_imag_stb,output_z_real_ack,output_z_imag_ack;
    reg  output_z_real_stb,output_z_imag_stb,input_a_real_ack,input_a_imag_ack,input_b_real_ack,input_b_imag_ack;
    double_complex_mult multiplier0(
        input_a_real,
        input_a_imag,
        input_b_real,
        input_b_imag,
        input_a_real_stb,
        input_a_imag_stb,
        input_b_real_stb,
        input_b_imag_stb,
        output_z_real_ack,
        output_z_imag_ack,
        clk,
        rst,
        output_z_real,
        output_z_imag,
        output_z_real_stb,
        output_z_imag_stb,
        input_a_real_ack,
        input_a_imag_ack,
        input_b_real_ack,
        input_b_imag_ack,    
);

    reg[63:0] last_sum_real,last_sum_imag,this_prod_real,this_prod_imag,next_sum_real,next_sum_imag;
    reg last_sum_real_stb,last_sum_imag_stb, last_sum_real_ack, last_sum_imag_ack;
    reg this_prod_real_stb,this_prod_imag_stb, this_prod_real_ack;
    reg this_prod_imag_ack,next_sum_real_stb,next_sum_imag_stb,next_sum_real_ack,next_sum_imag_ack;
    
    double_complexnumber_adder adder0(
    last_sum_real,last_sum_imag,last_sum_real_stb,last_sum_imag_stb, last_sum_real_ack, last_sum_imag_ack,
    this_prod_real,this_prod_imag,this_prod_real_stb,this_prod_imag_stb, this_prod_real_ack, this_prod_imag_ack,
    next_sum_real,next_sum_imag,next_sum_real_stb,next_sum_imag_stb,next_sum_real_ack,next_sum_imag_ack,
    clk,rst);

    always@(posedge clk)
    begin
        if(rst ==1'b1)
        begin
            done<=0;
            z_real<=0;
            z_imag<=0;
            state<=0;
            count<=0;
        end
        else
            case(state)
            0:
                begin
                    input_a_real_stb<=0;
                    input_a_imag_stb<=0;
                    input_b_real_stb<=0;
                    input_b_imag_stb<=0;
                    output_z_imag_ack<=0;
                    output_z_real_ack<=0;
                    input_a_real<=0;
                    input_b_real<=0;
                    input_a_imag<=0;
                    input_b_imag<=0;
                    
                    last_sum_real<=0;
                    last_sum_imag<=0;
                    last_sum_real_stb<=0;
                    last_sum_imag_stb<=0;
                    // last_sum_real_ack<=0;
                    // last_sum_imag_ack<=0;

                    this_prod_real<=0;
                    this_prod_imag<=0;
                    this_prod_real_stb<=0;
                    this_prod_imag_stb<=0;
                    // this_prod_real_ack<=0;
                    // this_prod_imag_ack<=0;
                    next_sum_real_ack<=0;
                    next_sum_imag_ack<=0;

                    count<=0;
                    done<=0;
                    
                    if(valid==1) begin
                        state<=1;
                    end
                    else begin
                        state<=0;
                    end
                end
            1: // read input to local variables
                begin
                    // if(valid==1) begin
                        for(index = 0; index < mat_add_gen; index=index+1) begin 
                            a_real_local[index]=a_real[index*64 +: 64];
                            a_imag_local[index]=a_imag[index*64 +: 64];
                            b_real_local[index]=b_real[index*64 +: 64];
                            b_imag_local[index]=b_imag[index*64 +: 64];
                        end
                        if(start==1) begin
                            count<=0;
                            done<=0;
                            last_sum_imag<=0;
                            last_sum_real<=0;
                            this_prod_real<=0;
                            this_prod_imag<=0;
                            state<=2;
                        end
                        else begin
                            state<=1;
                        end
                    // end
                    // else begin
                    //     state<=1;
                    // end
                end
            2: // feed multiplication input
            begin
                input_a_real<=a_real_local[count];
                input_b_real<=b_real_local[count];
                input_a_imag<=a_imag_local[count];
                input_b_imag<=b_imag_local[count];
                input_a_real_stb<=1;
                input_a_imag_stb<=1;
                input_b_real_stb<=1;
                input_b_imag_stb<=1;
                output_z_imag_ack<=0;
                output_z_real_ack<=0;
                next_sum_real_ack<=0;
                next_sum_imag_ack<=0;
                state<=3;
            end
            3: // wait for multiplication to end
            begin
                if(input_a_real_ack==1) begin
                input_a_real_stb<=0;
                end
                if(input_a_imag_ack==1) begin
                    input_a_imag_stb<=0;
                end
                if(input_b_real_ack==1) begin
                    input_b_real_stb<=0;
                end
                if(input_b_imag_ack==1) begin
                    input_b_imag_stb<=0;
                end
                if((output_z_real_stb==1)&(output_z_imag_stb==1)) begin
                    output_z_imag_ack<=1;
                    output_z_real_ack<=1;
                    input_a_real_stb<=0;
                    input_a_imag_stb<=0;
                    input_b_real_stb<=0;
                    input_b_imag_stb<=0;
                    state<=4;
                    end
                else begin
                        state<=3;
                    end
                
            end
            4: // feed cumulative adder input
            begin
                this_prod_real<=output_z_real;
                this_prod_imag<=output_z_imag;
                this_prod_real_stb<=1;
                this_prod_imag_stb<=1;
                last_sum_real_stb<=1;
                last_sum_imag_stb<=1;
                state<=5;
            end
            5: //wait for cumulative addition to complete
            begin
                if(this_prod_real_ack==1) begin
                    this_prod_real_stb<=0;
                end
                if(this_prod_imag_ack==1) begin
                    this_prod_imag_stb<=0;
                end
                if(last_sum_real_ack==1) begin
                    last_sum_real_stb<=0;
                end
                if(last_sum_imag_ack==1) begin
                    last_sum_imag_stb<=0;
                end
                if((next_sum_imag_stb==1)&(next_sum_real_stb==1)) begin
                    next_sum_real_ack<=1;
                    next_sum_imag_ack<=1;
                    this_prod_real_stb<=0;
                    this_prod_imag_stb<=0;
                    last_sum_real_stb<=0;
                    last_sum_imag_stb<=0;
                    state<=6;
                end
                else begin
                    state<=5;
                end
            end
            6: // next count
            begin
                last_sum_real<=next_sum_real;
                last_sum_imag<=next_sum_imag;
                next_sum_real_ack<=1;
                next_sum_imag_ack<=1;
                if(count==(mat_add_gen-1)) begin
                    state<=7;
                end
                else begin
                    count<= count+1;
                    state<=2;
                end
            end
            7: //final output
            begin
                next_sum_real_ack<=0;
                next_sum_imag_ack<=0;
                output_z_imag_ack<=0;
                output_z_real_ack<=0;
                this_prod_real_stb<=0;
                this_prod_imag_stb<=0;
                last_sum_real_stb<=0;
                last_sum_imag_stb<=0;
                z_real<=last_sum_real;
                z_imag<=last_sum_imag;
                done<=1;
                if(out_read_ack==1) begin
                    state<=0;
                end
                else begin
                state<=7;
                end



                
            end
                
            endcase
    end

endmodule