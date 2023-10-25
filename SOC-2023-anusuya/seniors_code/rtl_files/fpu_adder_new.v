module adder(
    a,
    b,
    sign_atb,
    sign_btb,
    z_ack,
    clk,
    rst,
    z,
    sign_ztb,
    a_ack,
    b_ack);

    input     clk;
    input     rst;

    input     [31:0] a;
    input     sign_atb;
    output    a_ack;

    input     [31:0] b;
    input     sign_btb;
    output    b_ack;

    output    [31:0] z;
    output    sign_ztb;
    input     z_ack;

    reg       s_sign_ztb;
    reg       [31:0] s_z;
    reg       s_a_ack;
    reg       s_b_ack;

    reg       [3:0] state;
    parameter get_input_1         = 4'd0,
    get_input_2         = 4'd1,
    unpack_inputs        = 4'd2,
    special_cases = 4'd3,
    align         = 4'd4,
    add_stage_1         = 4'd5,
    add_stage_2         = 4'd6,
    normalise_1   = 4'd7,
    normalise_2   = 4'd8,
    round         = 4'd9,
    pack          = 4'd10,
    put_output         = 4'd11;

   
    reg       [26:0] man_a, man_b;
    reg       [23:0] man_z;
    reg       [31:0] a, b, z;
    reg       [9:0] exp_a, exp_b, exp_z;
    reg       [27:0] sum;
    reg       sign_a, sign_b, sign_z;
    reg       guard, round_bit, sticky;

    always @(posedge clk)
    begin

        case(state)

            get_input_1:
                begin
                    s_a_ack <= 1;
                    if (s_a_ack && sign_atb) begin
                        a <= a;
                        s_a_ack <= 0;
                        state <= get_input_2;
                    end
                end

            get_input_2:
                begin
                    s_b_ack <= 1;
                    if (s_b_ack && sign_btb) begin
                        b <= b;
                        s_b_ack <= 0;
                        state <= unpack_inputs;
                    end
                end

            unpack_inputs:
                begin
                    man_a <= {a[22 : 0], 3'd0};
                    man_b <= {b[22 : 0], 3'd0};
                    exp_a <= a[30 : 23] - 127;
                    exp_b <= b[30 : 23] - 127;
                    sign_a <= a[31];
                    sign_b <= b[31];
                    state <= special_cases;
                end

            special_cases:
                begin
                    //if a is NaN or b is NaN return NaN 
                    if ((exp_a == 128 && man_a != 0) || (exp_b == 128 && man_b != 0)) begin
                        z[31] <= 1;
                        z[30:23] <= 255;
                        z[22] <= 1;
                        z[21:0] <= 0;
                        state <= put_output;
                        //if a is inf return inf
                    end else if (exp_a == 128) begin
                        z[31] <= sign_a;
                        z[30:23] <= 255;
                        z[22:0] <= 0;
                        //if a is inf and signs don't match return nan
                        if ((exp_b == 128) && (sign_a != sign_b)) begin
                            z[31] <= sign_b;
                            z[30:23] <= 255;
                            z[22] <= 1;
                            z[21:0] <= 0;
                        end
                        state <= put_output;
                        //if b is inf return inf
                    end else if (exp_b == 128) begin
                        z[31] <= sign_b;
                        z[30:23] <= 255;
                        z[22:0] <= 0;
                        state <= put_output;
                        //if a is zero return b
                    end else if ((($signed(exp_a) == -127) && (man_a == 0)) && (($signed(exp_b) == -127) && (man_b == 0))) begin
                        z[31] <= sign_a & sign_b;
                        z[30:23] <= exp_b[7:0] + 127;
                        z[22:0] <= man_b[26:3];
                        state <= put_output;
                        //if a is zero return b
                    end else if (($signed(exp_a) == -127) && (man_a == 0)) begin
                        z[31] <= sign_b;
                        z[30:23] <= exp_b[7:0] + 127;
                        z[22:0] <= man_b[26:3];
                        state <= put_output;
                        //if b is zero return a
                    end else if (($signed(exp_b) == -127) && (man_b == 0)) begin
                        z[31] <= sign_a;
                        z[30:23] <= exp_a[7:0] + 127;
                        z[22:0] <= man_a[26:3];
                        state <= put_output;
                    end else begin
                        //Denormalised Number
                        if ($signed(exp_a) == -127) begin
                            exp_a <= -126;
                        end else begin
                            man_a[26] <= 1;
                        end
                        //Denormalised Number
                        if ($signed(exp_b) == -127) begin
                            exp_b <= -126;
                        end else begin
                            man_b[26] <= 1;
                        end
                        state <= align;
                    end
                end

            align:
                begin
                    if ($signed(exp_a) > $signed(exp_b)) begin
                        exp_b <= exp_b + 1;
                        man_b <= man_b >> 1;
                        man_b[0] <= man_b[0] | man_b[1];
                    end else if ($signed(exp_a) < $signed(exp_b)) begin
                        exp_a <= exp_a + 1;
                        man_a <= man_a >> 1;
                        man_a[0] <= man_a[0] | man_a[1];
                    end else begin
                        state <= add_stage_1;
                    end
                end

            add_stage_1:
                begin
                    exp_z <= exp_a;
                    if (sign_a == sign_b) begin
                        sum <= man_a + man_b;
                        sign_z <= sign_a;
                    end else begin
                        if (man_a >= man_b) begin
                            sum <= man_a - man_b;
                            sign_z <= sign_a;
                        end else begin
                            sum <= man_b - man_a;
                            sign_z <= sign_b;
                        end
                    end
                    state <= add_stage_2;
                end

            add_stage_2:
                begin
                    if (sum[27]) begin
                        man_z <= sum[27:4];
                        guard <= sum[3];
                        round_bit <= sum[2];
                        sticky <= sum[1] | sum[0];
                        exp_z <= exp_z + 1;
                    end else begin
                        man_z <= sum[26:3];
                        guard <= sum[2];
                        round_bit <= sum[1];
                        sticky <= sum[0];
                    end
                    state <= normalise_1;
                end

            normalise_1:
                begin
                    if (man_z[23] == 0 && $signed(exp_z) > -126) begin
                        exp_z <= exp_z - 1;
                        man_z <= man_z << 1;
                        man_z[0] <= guard;
                        guard <= round_bit;
                        round_bit <= 0;
                    end else begin
                        state <= normalise_2;
                    end
                end

            normalise_2:
                begin
                    if ($signed(exp_z) < -126) begin
                        exp_z <= exp_z + 1;
                        man_z <= man_z >> 1;
                        guard <= man_z[0];
                        round_bit <= guard;
                        sticky <= sticky | round_bit;
                    end else begin
                        state <= round;
                    end
                end

            round:
                begin
                    if (guard && (round_bit | sticky | man_z[0])) begin
                        man_z <= man_z + 1;
                        if (man_z == 24'hffffff) begin
                            exp_z <=exp_z + 1;
                        end
                    end
                    state <= pack;
                end

            pack:
                begin
                    z[22 : 0] <= man_z[22:0];
                    z[30 : 23] <= exp_z[7:0] + 127;
                    z[31] <= sign_z;
                    if ($signed(exp_z) == -126 && man_z[23] == 0) begin
                        z[30 : 23] <= 0;
                    end
                    if ($signed(exp_z) == -126 && man_z[23:0] == 24'h0) begin
                        z[31] <= 1'b0; 
                    end
                    //return inf if overflow
                    if ($signed(exp_z) > 127) begin
                        z[22 : 0] <= 0;
                        z[30 : 23] <= 255;
                        z[31] <= sign_z;
                    end
                    state <= put_output;
                end

            put_output:
                begin
                    s_sign_ztb <= 1;
                    s_z <= z;
                    if (s_sign_ztb && z_ack) begin
                        s_sign_ztb <= 0;
                        state <= get_input_1;
                    end
                end

        endcase

        if (rst == 1) begin
            state <= get_input_1;
            s_a_ack <= 0;
            s_b_ack <= 0;
            s_sign_ztb <= 0;
            //TODO - Sarang, check if any functionality is broken
            s_z <= 0;
            z <= 0;
        end

    end
    assign a_ack = s_a_ack;
    assign b_ack = s_b_ack;
    assign sign_ztb = s_sign_ztb;
    assign z = s_z;

endmodule
