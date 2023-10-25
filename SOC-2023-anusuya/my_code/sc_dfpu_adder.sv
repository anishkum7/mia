`timescale 1ps/1ps
module double_adder(
        input_a,
        input_b,
        input_a_stb,
        input_b_stb,
        output_z_ack,
        clk,
        rst,
        output_z,
        output_z_stb,
        input_a_ack,
        input_b_ack);

  input     clk;
  input     rst;

  input reg[63:0] input_a;
  input  reg   input_a_stb;
  output reg    input_a_ack;

  input reg[63:0] input_b;
  input reg    input_b_stb;
  output reg   input_b_ack;

  output reg[63:0] output_z;
  output reg   output_z_stb;
  input  reg   output_z_ack;

  reg       s_output_z_stb;
  reg       [63:0] s_output_z;
  reg       s_input_a_ack;
  reg       s_input_b_ack;

  reg       [3:0] state;
  parameter get_a         = 4'd0,
            get_b         = 4'd1,
            unpack        = 4'd2,
            special_cases = 4'd3,
            align         = 4'd4,
            add_0         = 4'd5,
            add_1         = 4'd6,
            normalise_1   = 4'd7,
            normalise_2   = 4'd8,
            round         = 4'd9,
            pack          = 4'd10,
            put_z         = 4'd11;

  reg       [63:0] a, b, z;
  reg       [55:0] a_m, b_m;
  reg       [52:0] z_m;
  reg       [12:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, round_bit, sticky;
  reg       [56:0] sum;

  always @(posedge clk)
  begin

    case(state)

      get_a:
      begin
        s_input_a_ack <= 1;
        if (s_input_a_ack && input_a_stb) begin
          a <= input_a;
          s_input_a_ack <= 0;
          state <= get_b;
          // $display("\n 69: a=%b, input_a=%b state=%d\n",a,input_a, state);
        end
        // $display("\n 71: a=%b, input_a=%b state=%d\n",a, input_a,state);
      end

      get_b:
      begin
        s_input_b_ack <= 1;
        if (s_input_b_ack && input_b_stb) begin
          b <= input_b;
          s_input_b_ack <= 0;
          state <= unpack;
          // $display("\n 81: a=%b, b=%b, state=%d\n",a, b ,state);
        end
        // $display("\n 83: a=%b, b=%b, state=%d\n",a, b ,state);
      end

      unpack:
      begin
        a_m <= {a[51 : 0], 3'd0};
        b_m <= {b[51 : 0], 3'd0};
        a_e <= a[62 : 52] - 1023;
        b_e <= b[62 : 52] - 1023;
        a_s <= a[63];
        b_s <= b[63];
        state <= special_cases;
        //  $display("\n 91: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state);
      end

      special_cases:
      begin
        //if a is NaN or b is NaN return NaN 
        if ((a_e == 1024 && a_m != 0) || (b_e == 1024 && b_m != 0)) begin
          z[63] <= 1;
          z[62:52] <= 2047;
          z[51] <= 1;
          z[50:0] <= 0;
          state <= put_z;
        //    $display("\n 104: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        //if a is inf return inf
        end else if (a_e == 1024) begin
          z[63] <= a_s;
          z[62:52] <= 2047;
          z[51:0] <= 0;
          //if a is inf and signs don't match return nan
          if ((b_e == 1024) && (a_s != b_s)) begin
              z[63] <= 1;
              z[62:52] <= 2047;
              z[51] <= 1;
              z[50:0] <= 0;
          end
          state <= put_z;
        //   $display("\n 119: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        //if b is inf return inf
        end else if (b_e == 1024) begin
          z[63] <= b_s;
          z[62:52] <= 2047;
          z[51:0] <= 0;
          state <= put_z;
        //    $display("\n 127: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        //if a is zero return b
        end else if ((($signed(a_e) == -1023) && (a_m == 0)) && (($signed(b_e) == -1023) && (b_m == 0))) begin
          z[63] <= a_s & b_s;
          z[62:52] <= b_e[10:0] + 1023;
          z[51:0] <= b_m[55:3];
          state <= put_z;
        //   $display("\n 135: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        //if a is zero return b
        end else if (($signed(a_e) == -1023) && (a_m == 0)) begin
          z[63] <= b_s;
          z[62:52] <= b_e[10:0] + 1023;
          z[51:0] <= b_m[55:3];
          state <= put_z;
        //   $display("\n 143: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        //if b is zero return a
        end else if (($signed(b_e) == -1023) && (b_m == 0)) begin
          z[63] <= a_s;
          z[62:52] <= a_e[10:0] + 1023;
          z[51:0] <= a_m[55:3];
          state <= put_z;
        //   $display("\n 151: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        end else if ( a[62:0] == b[62:0] && a[63] == ~b[63]) begin
            z <= 0;
            state <= put_z;
        end else begin
          //Denormalised Number
          if ($signed(a_e) == -1023) begin
            a_e <= -1022;
        //     $display("\n 157: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
          end else begin
            a_m[55] <= 1;
        //     $display("\n 161: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
          end
          //Denormalised Number
          if ($signed(b_e) == -1023) begin
            b_e <= -1022;
        //     $display("\n 167: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
          end else begin
            b_m[55] <= 1;
        //     $display("\n 171: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
          end
          state <= align;
        //   $display("\n 175: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        end
        // $display("\n 178: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
      end

      align:
      begin
        if ($signed(a_e) > $signed(b_e)) begin
          b_e <= b_e + 1;
          b_m <= b_m >> 1;
          b_m[0] <= b_m[0] | b_m[1];
        //   $display("\n 188: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        end else if ($signed(a_e) < $signed(b_e)) begin
          a_e <= a_e + 1;
          a_m <= a_m >> 1;
          a_m[0] <= a_m[0] | a_m[1];
        //   $display("\n 194: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        end else begin
          state <= add_0;
        //   $display("\n 198: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        end
        // $display("\n 201: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
      end

      add_0:
      begin
        // $display("\n 211: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z);
        z_e <= a_e;
        if (a_s == b_s) begin
          sum <= {1'd0, a_m} + b_m;
          z_s <= a_s;
        //   $display("\n 217: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
        end else begin
          if (a_m > b_m) begin
            sum <= {1'd0, a_m} - b_m;
            z_s <= a_s;
        //     $display("\n 223: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
          end else begin
            sum <= {1'd0, b_m} - a_m;
            z_s <= b_s;
        //     $display("\n 228: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
          end
        end
        state <= add_1;
        // $display("\n 233: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
      end

      add_1:
      begin
        // $display("\n 238: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
        if (sum[56]) begin
          z_m <= sum[56:4];
          guard <= sum[3];
          round_bit <= sum[2];
          sticky <= sum[1] | sum[0];
          z_e <= z_e + 1;
        end else begin
          z_m <= sum[55:3];
          guard <= sum[2];
          round_bit <= sum[1];
          sticky <= sum[0];
        end
        state <= normalise_1;
      end

      normalise_1:
      begin
        //  $display("\n 258: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
        if (z_m[52] == 0 && $signed(z_e) > -1022) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= guard;
          guard <= round_bit;
          round_bit <= 0;
        //   $display("\n 266: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,z_m=%b, z_e=%b, z=%b sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,z_m,z_e,z,sum);
        end else begin
          state <= normalise_2;
        //   $display("\n 270: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,z_m=%b, z_e=%b, z=%b sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,z_m,z_e,z,sum);
        end
      end

      normalise_2:
      begin
        //  $display("\n 277: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,sum);
        if ($signed(z_e) < -1022) begin
          z_e <= z_e + 1;
          z_m <= z_m >> 1;
          guard <= z_m[0];
          round_bit <= guard;
          sticky <= sticky | round_bit;
        end else begin
          state <= round;
        end
      end

      round:
      begin
        if (guard && (round_bit | sticky | z_m[0])) begin
          z_m <= z_m + 1;
          if (z_m == 53'h1fffffffffffff) begin
            z_e <=z_e + 1;
          end
        end
        state <= pack;
      end

      pack:
      begin
        z[51 : 0] <= z_m[51:0];
        z[62 : 52] <= z_e[10:0] + 1023;
        z[63] <= z_s;
        if ($signed(z_e) == -1022 && z_m[52] == 0) begin
          z[62 : 52] <= 0;
        end
        if ($signed(z_e) == -1022 && z_m[52:0] == 0) begin
           z[63] <= 0;
        end

        //if overflow occurs, return inf
        if ($signed(z_e) > 1023) begin
          z[51 : 0] <= 0;
          z[62 : 52] <= 2047;
          z[63] <= z_s;
        end
        state <= put_z;
      end

      put_z:
      begin
        // $display("\n 318: a_m= %b b_m=%b a_e=%b b_e=%b a_s=%b b_s=%b state=%d z_s=%b,z=%b, sum=%b\n",
        // a_m,b_m,a_e,b_e,a_s,b_s,state,z_s,z, sum);
        s_output_z_stb <= 1;
        s_output_z <= z;
        if (s_output_z_stb && output_z_ack) begin
          s_output_z_stb <= 0;
          state <= get_a;
        end
      end

    endcase

    if (rst == 1) begin
      state <= get_a;
      s_input_a_ack <= 0;
      s_input_b_ack <= 0;
      s_output_z_stb <= 0;
    end

  end
  assign input_a_ack = s_input_a_ack;
  assign input_b_ack = s_input_b_ack;
  assign output_z_stb = s_output_z_stb;
  assign output_z = s_output_z;

endmodule