// mat_a: row major matrix ( real components followed by imaginary components)
// mat_b: row major matrix ( real components followed by imaginary components)
// mat_num_row: number of rows in matrix, Assumption: mat_a and mat_b are square matrices-> number of rows=number of columns
// mat_out: output matrix also row major order (real components followed by imaginary components)
// how to use the module: 
// set the input values->raise valid signal for one clock period->raise start signal for the next clock period
// ->wait for the done signal to be raised to read the output
module mat_mult_uneven
#(parameter out_row=2, parameter out_col=3, parameter common_factor=2)(
    input clk,
    input rst,
    input start,
    input valid,
    input [2*64*out_row*common_factor-1:0] mat_a,
    input [2*64*common_factor*out_col-1:0] mat_b,
    output reg [2*64*out_row*out_col-1:0] mat_out,
    output reg done);

    reg[2:0] state;
    // reg[63:0] a_real_local[mat_num_row*mat_num_row-1:0]; // a has to be rearranged in row major order
    // reg[63:0] a_imag_local[mat_num_row*mat_num_row-1:0];
    // reg[63:0] b_real_local[mat_num_row*mat_num_row-1:0]; // b has to be rearranged in column major order
    // reg[63:0] b_imag_local[mat_num_row*mat_num_row-1:0];
    // reg[63:0] out_real_local[mat_num_row*mat_num_row-1:0];
    // reg[63:0] out_imag_local[mat_num_row*mat_num_row-1:0];

    reg[64*out_row*common_factor-1:0] a_real_local; // a has to be rearranged in row major order
    reg[64*out_row*common_factor-1:0] a_imag_local;
    reg[64*common_factor*out_col-1:0] b_real_local; // b has to be rearranged in column major order
    reg[64*common_factor*out_col-1:0] b_imag_local;
    reg[64*out_row*out_col-1:0] out_real_local;
    reg[64*out_row*out_col-1:0] out_imag_local;


    reg[out_row*out_col-1:0] done_vecMult;
    reg[out_row*out_col-1:0] start_vecMult; 
    reg[out_row*out_col-1:0] valid_vecMult;
    reg[out_row*out_col-1:0] out_read_ack_vecMult;
    
    genvar i,j;
    generate
        for(i=0;i<out_row;i=i+1) begin : name_block_1
            for(j=0;j<out_col;j=j+1) begin : name_block_2
                vec_mult_acc#(.mat_add_gen(common_factor))
                 m0(clk,rst,
                 start_vecMult[i*out_col+j], valid_vecMult[i*out_col+j],
                 a_real_local[(64*i*common_factor)+:64*common_factor],
                 a_imag_local[(64*i*common_factor)+:64*common_factor],
                 b_real_local[(64*j*common_factor)+:64*common_factor],
                 b_imag_local[(64*j*common_factor)+:64*common_factor],
                 out_read_ack_vecMult[i*out_col+j],
                 out_real_local[64*(i*out_col+j)+:64],
                 out_imag_local[64*(i*out_col+j)+:64],
                 done_vecMult[i*out_col+j]);
                //  assign b_real_local[64*(j*common_factor+i)+:64]=mat_b[64*(i*common_factor+j) +:64]; // rearrange the input into separate real and imaginary vectors
                //  assign b_imag_local[64*(j*common_factor+i)+:64]=mat_b[64*(i*mat_num_row+j)+(64*out_col*common_factor)+:64];

            end
        end
        for(i=0;i<common_factor;i++) begin : assign_b_1
            for(j=0;j<out_col;j++) begin: assign_b_2
                assign b_real_local[64*(j*common_factor+i)+:64]=mat_b[64*(i*out_col+j) +:64];
                assign b_imag_local[64*(j*common_factor+i)+:64]=mat_b[64*(i*out_col+j)+(64*out_col*common_factor)+:64];
            end
        end
    endgenerate

    assign a_real_local = mat_a[out_row*64*common_factor-1:0];// rearrange the input into separate real and imaginary vectors
    assign a_imag_local = mat_a[2*64*out_row*common_factor-1:out_row*64*common_factor];


    always@(posedge clk)
    begin
        if(rst==1) begin
        // a_real_local<=0;
        // a_imag_local<=0;
        // b_real_local<=0;
        // b_imag_local<=0;
        // count<=0;
        state<=0;
        valid_vecMult<={(out_row*out_col){1'b0}};
        start_vecMult<={(out_row*out_col){1'b0}};
        done<=0;
        out_read_ack_vecMult<={(out_row*out_col){1'b0}};
        end
        else begin
        case(state)
        0: // if the inputs are valid, feed them to the vec_mult_acc modules
        begin
            done<=0;
            if(valid==1) begin 
                valid_vecMult<={(out_row*out_col){1'b1}};
                if(start==1) begin 
                state<=1;
                end
                else begin
                state<=0;
                end

            end
            else begin
                valid_vecMult<={(out_row*out_col){1'b0}};
                out_read_ack_vecMult<={(out_row*out_col){1'b0}};
                state<=0;
            end
        end
        1: // if the start command is given, start the vec_mult_acc modules' computation
        begin
            if(start==1) begin
            start_vecMult<={(out_row*out_col){1'b1}};
            state<=2;
            end
            else begin
                start_vecMult<={(out_row*out_col){1'b0}};
                state<=1; // if start command is not given wait in this state;
            end
        end
        2: // wait for the vec_mult_acc modules' computation to be done
        begin
            if(done_vecMult=={(out_row*out_col){1'b1}}) begin
            mat_out[out_row*out_col*64-1:0]<=out_real_local;
            mat_out[2*64*out_row*out_col-1:out_row*out_col*64]<=out_imag_local;
            out_read_ack_vecMult<={(out_row*out_col){1'b1}};
            start_vecMult<={(out_row*out_col){1'b0}};
            valid_vecMult<={(out_row*out_col){1'b0}};
            done<=1;
            state<=0;
            end
            else begin
                state<=2;
            end
        end
        endcase
        end
    end
endmodule