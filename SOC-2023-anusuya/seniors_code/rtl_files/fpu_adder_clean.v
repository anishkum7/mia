module adder_clean(
    in_a,
    in_b,
    in_a_req,
    in_b_req,
    out_z_ack,
    clk,
    rst,
    out_z,
    out_z_req,
    in_a_ack,
    in_b_ack);

    input     clk;
    input     rst;

    input     [31:0] in_a;
    input     in_a_req;
    output    in_a_ack;

    input     [31:0] in_b;
    input     in_b_req;
    output    in_b_ack;

    output    [31:0] out_z;
    output    out_z_req;
    input     out_z_ack;

    reg       final_out_z_req;
    reg       [31:0] final_out_z;
    reg       final_in_a_ack;
    reg       final_in_b_ack;

    reg       [3:0] state;
    parameter WAIT_INPUT_1 = 4'd0,
    WAIT_INPUT_2           = 4'd1,
    SPLIT_SPECIAL          = 4'd2,
    ALIGN                  = 4'd3,
    ADD                    = 4'd4,
    NORM_1                 = 4'd5,
    NORM_2                 = 4'd6,
    ROUND                  = 4'd7,
    DRIVE_Z                = 4'd8;

    reg       [31:0] a, b, z;
    reg       [26:0] mant_a, mant_b;
    reg       temp_mant_a_bit0, temp_mant_b_bit0;
    reg       [23:0] mant_z;
    reg       temp_mant_z_bit0;
    reg       [9:0] exp_a, exp_b, exp_z;
    reg       sign_a, sign_b, sign_z;
    reg       guard, round_bit, sticky;
    reg       [27:0] sum;

    always @(posedge clk)
    begin

        case(state)

            WAIT_INPUT_1:
                begin
                    if (!final_in_a_ack) begin
                        final_in_a_ack = 1;
                    end
                    else if (in_a_req) begin
                        a = in_a;
                        final_in_a_ack = 0;
                        state <= WAIT_INPUT_2;
                    end
                end

            WAIT_INPUT_2:
                begin
                    if (!final_in_b_ack) begin
                        final_in_b_ack = 1;
                    end
                    else if (in_b_req) begin
                        b = in_b;
                        final_in_b_ack = 0;
                        state <= SPLIT_SPECIAL;
                    end
                end

            SPLIT_SPECIAL:
                begin
                    mant_a = {a[22 : 0], 3'd0};
                    mant_b = {b[22 : 0], 3'd0};
                    exp_a = a[30 : 23] - 127;
                    exp_b = b[30 : 23] - 127;
                    sign_a = a[31];
                    sign_b = b[31];
                    //state <= special_cases;
                    if ((exp_a == 128 && mant_a != 0) || (exp_b == 128 && mant_b != 0)) begin
                        z[31] = 1;
                        z[30:23] = 255;
                        z[22] = 1;
                        z[21:0] = 0;
                        state <= DRIVE_Z;
                        //if a is inf return inf
                    end else if (exp_a == 128) begin
                        z[31] = sign_a;
                        z[30:23] = 255;
                        z[22:0] = 0;
                        //if a is inf and signs don't match return nan
                        if ((exp_b == 128) && (sign_a != sign_b)) begin
                            z[31] = sign_b;
                            z[30:23] = 255;
                            z[22] = 1;
                            z[21:0] = 0;
                        end
                        state <= DRIVE_Z;
                        //if b is inf return inf
                    end else if (exp_b == 128) begin
                        z[31] = sign_b;
                        z[30:23] = 255;
                        z[22:0] = 0;
                        state <= DRIVE_Z;
                        //if a is zero return b
                    end else if ((($signed(exp_a) == -127) && (mant_a == 0)) && (($signed(exp_b) == -127) && (mant_b == 0))) begin
                        z[31] = sign_a & sign_b;
                        z[30:23] = exp_b[7:0] + 127;
                        z[22:0] = mant_b[26:3];
                        state <= DRIVE_Z;
                        //if a is zero return b
                    end else if (($signed(exp_a) == -127) && (mant_a == 0)) begin
                        z[31] = sign_b;
                        z[30:23] = exp_b[7:0] + 127;
                        z[22:0] = mant_b[26:3];
                        state <= DRIVE_Z;
                        //if b is zero return a
                    end else if (($signed(exp_b) == -127) && (mant_b == 0)) begin
                        z[31] = sign_a;
                        z[30:23] = exp_a[7:0] + 127;
                        z[22:0] = mant_a[26:3];
                        state <= DRIVE_Z;
                    end else begin
                        //Denormalised Number
                        if ($signed(exp_a) == -127) begin
                            exp_a = -126;
                        end else begin
                            mant_a[26] = 1;
                        end
                        //Denormalised Number
                        if ($signed(exp_b) == -127) begin
                            exp_b = -126;
                        end else begin
                            mant_b[26] = 1;
                        end
                        state <= ALIGN;
                    end
                end

            ALIGN:
                begin
                    if ($signed(exp_a) > $signed(exp_b)) begin
                        exp_b = exp_b + 1;
                        temp_mant_b_bit0 = mant_b[0] | mant_b[1];
                        mant_b = mant_b >> 1;
                        mant_b[0] = temp_mant_b_bit0;
                    end else if ($signed(exp_a) < $signed(exp_b)) begin
                        exp_a = exp_a + 1;
                        temp_mant_a_bit0 = mant_a[0] | mant_a[1];
                        mant_a = mant_a >> 1;
                        mant_a[0] = temp_mant_a_bit0;
                    end else begin
                        state <= ADD;
                    end
                end

            ADD:
                begin
                    exp_z = exp_a;
                    if (sign_a == sign_b) begin
                        sum = mant_a + mant_b;
                        sign_z = sign_a;
                    end else begin
                        if (mant_a >= mant_b) begin
                            sum = mant_a - mant_b;
                            sign_z = sign_a;
                        end else begin
                            sum = mant_b - mant_a;
                            sign_z = sign_b;
                        end
                    end
                    //state <= add_1;
                    if (sum[27]) begin
                        mant_z = sum[27:4];
                        guard = sum[3];
                        round_bit = sum[2];
                        sticky = sum[1] | sum[0];
                        exp_z = exp_z + 1;
                    end else begin
                        mant_z = sum[26:3];
                        guard = sum[2];
                        round_bit = sum[1];
                        sticky = sum[0];
                    end
                    state <= NORM_1;
                end

            NORM_1:
                begin
                    if (mant_z[23] == 0 && $signed(exp_z) > -126) begin
                        exp_z = exp_z - 1;
                        mant_z = mant_z << 1;
                        mant_z[0] = guard;
                        guard = round_bit;
                        round_bit = 0;
                    end else begin
                        state <= NORM_2;
                    end
                end

            NORM_2:
                begin
                    if ($signed(exp_z) < -126) begin
                        exp_z = exp_z + 1;
                        temp_mant_z_bit0 = mant_z[0];
                        mant_z = mant_z >> 1;
                        sticky = sticky | round_bit;
                        round_bit = guard;
                        guard = temp_mant_z_bit0;
                    end else begin
                        state <= ROUND;
                    end
                end

            ROUND:
                begin
                    if (guard && (round_bit | sticky | mant_z[0])) begin
                        if (mant_z == 24'hffffff) begin
                            exp_z =exp_z + 1;
                        end
                        mant_z = mant_z + 1;
                    end
                    //state <= pack;
                    z[22 : 0] = mant_z[22:0];
                    z[30 : 23] = exp_z[7:0] + 127;
                    z[31] = sign_z;
                    if ($signed(exp_z) == -126 && mant_z[23] == 0) begin
                        z[30 : 23] = 0;
                    end
                    if ($signed(exp_z) == -126 && mant_z[23:0] == 24'h0) begin
                        z[31] = 1'b0;
                    end
                    //overflow => inf
                    if ($signed(exp_z) > 127) begin
                        z[22 : 0] = 0;
                        z[30 : 23] = 255;
                        z[31] = sign_z;
                    end
                    state <= DRIVE_Z;
                end

            DRIVE_Z:
                begin
                    final_out_z = z;
                    if (!final_out_z_req) begin
                        final_out_z_req = 1;
                    end
                    else if (out_z_ack) begin
                        final_out_z_req = 0;
                        state <= WAIT_INPUT_1;
                    end
                end

        endcase

        if (rst == 1) begin
            state <= WAIT_INPUT_1;
            final_in_a_ack <= 0;
            final_in_b_ack <= 0;
            final_out_z_req <= 0;
            //TODO - Sarang, check if any functionality is broken
            final_out_z <= 0;
            z <= 0;
        end

    end
    assign in_a_ack  = final_in_a_ack;
    assign in_b_ack  = final_in_b_ack;
    assign out_z_req = final_out_z_req;
    assign out_z     = final_out_z;

endmodule