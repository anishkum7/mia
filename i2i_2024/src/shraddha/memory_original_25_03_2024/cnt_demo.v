//timescale 1ns/1ns
//`define EXT_CNT_ENBL
module cnt_start_check ( 
                            osc_ext,
                            reset_n,
			    cnt_reg ,
			    cnt_dly_reg,
			    start_flag );

input osc_ext, reset_n;
input [15:0] cnt_reg, cnt_dly_reg;
output reg start_flag;
wire osc;
    assign osc = osc_ext;    

always @ (posedge osc or negedge reset_n)
    begin
      if (~reset_n) 
		start_flag <= 1'b0;
      else
	if (cnt_reg==0 && cnt_dly_reg==65535)
		start_flag <= 1'b1;
	else
		start_flag <= 1'b0;	
	end	

endmodule

module cnt_end_check ( 
                            osc_ext,
                            reset_n,
			    cnt_reg ,
			    cnt_dly_reg,
			      end_flag );

input osc_ext, reset_n;
input [15:0] cnt_reg, cnt_dly_reg;
output reg end_flag;
wire osc;
    assign osc = osc_ext;  
			
always @ (posedge osc or negedge reset_n)
    begin
      if (~reset_n) 
		end_flag <= 1'b0;
      else
	if (cnt_reg==65535 && cnt_dly_reg==65534)
		end_flag <= 1'b1;
	else
		end_flag <= 1'b0;	
	end

endmodule



module cnt_demo(osc_ext,
                reset_n,
 		cnt_out,
		cnt_dly_out,
                hundred,
                one_fifty,
                toggle);

    parameter USERBIT_WIDTH = 72;
    parameter EXTRA_CNT = 28;
    parameter SMPL_CLK_RATIO = 5;
    parameter SAMPLE_DEPTH =1677722;
    parameter TRIGER_POSITION =67108863;
    localparam BUF_DEPTH_START = TRIGER_POSITION - SAMPLE_DEPTH/2 -1;
    localparam BUF_DEPTH_END = TRIGER_POSITION - SAMPLE_DEPTH/2 + 1;

    input osc_ext;
    input reset_n;
    output hundred;
    output one_fifty;
    output toggle;
    output [15:0] cnt_out, cnt_dly_out;
    reg [8:0]  osc_cnt_int;
    reg [7:0]  osc_cnt;
    reg [15 : 0] capture_cnt;
    reg [15 : 0] capture_cnt_dly;
    reg        toggle;
    reg        reference_cnt;
    reg        hundred;
    reg        one_fifty;
    reg        reference_cnt_d;
    
    reg [6:0]  pz_cnt;
    reg [6:0]  pz_cnt_int;

    reg [23:0] pz_cnt24_a;
    reg [23:0] pz_cnt24_b;
    reg [23:0] pz_cnt24_a_int;
    reg [23:0] pz_cnt24_b_int;
    reg [3:0]  pz_xor4;

    wire osc;
    wire dskip_n;
    wire counter_reset;
    wire capture_flag;
    wire [USERBIT_WIDTH-1:0] pz_cnt01;
    wire [USERBIT_WIDTH-1:0] pz_cnt02;
    wire [USERBIT_WIDTH-1:0] pz_cnt03;
    wire [USERBIT_WIDTH-1:0] pz_cnt04;
    wire [USERBIT_WIDTH-1:0] pz_cnt05;
    wire [USERBIT_WIDTH-1:0] pz_cnt06;
    wire [USERBIT_WIDTH-1:0] pz_cnt07;
    wire [USERBIT_WIDTH-1:0] pz_cnt08;
    wire [USERBIT_WIDTH-1:0] pz_cnt09;
    wire [USERBIT_WIDTH-1:0] pz_cnt10;
    wire [USERBIT_WIDTH-1:0] pz_cnt11;
    wire [USERBIT_WIDTH-1:0] pz_cnt12;
    wire [USERBIT_WIDTH-1:0] pz_cnt13;
    wire [USERBIT_WIDTH-1:0] pz_cnt14;
    wire [USERBIT_WIDTH-1:0] pz_cnt15;
    wire [USERBIT_WIDTH-1:0] pz_cnt16;
    wire [USERBIT_WIDTH-1:0] pz_cnt17;
    wire [USERBIT_WIDTH-1:0] pz_cnt18;
    wire [USERBIT_WIDTH-1:0] pz_cnt19;
    wire [USERBIT_WIDTH-1:0] pz_cnt20;
    wire [USERBIT_WIDTH-1:0] pz_cnt21;
    wire [USERBIT_WIDTH-1:0] pz_cnt22;
    wire [USERBIT_WIDTH-1:0] pz_cnt23;
    wire [USERBIT_WIDTH-1:0] pz_cnt24;
    wire [USERBIT_WIDTH-1:0] pz_cnt25;
    wire [USERBIT_WIDTH-1:0] pz_cnt26;
    wire [USERBIT_WIDTH-1:0] pz_cnt27;
    
    assign osc = osc_ext;    
    assign cnt_out =  capture_cnt;
    assign cnt_dly_out = capture_cnt_dly; 

    // Counter to identify trigger position
    always @ (posedge osc or negedge reset_n)
    begin
      if (~reset_n) begin
        capture_cnt <= 'd0;
        capture_cnt_dly <= 'd0;
      end
      else begin
        capture_cnt <= capture_cnt +1;
        capture_cnt_dly <= capture_cnt;
      end
    end
    
    assign counter_reset = 1'b0; 
    assign capture_flag = (capture_cnt == 'd0 && capture_cnt_dly == 16'hffff) ? 1'b1 : 1'b0;

    always @ (posedge osc or  negedge reset_n)
    begin
      if (~reset_n)
      begin
        osc_cnt_int   <= 0;
        one_fifty     <= 0;
        reference_cnt <= 0;
        hundred       <= 0;
      end
      else
      begin
        case (osc_cnt_int)
        //9'hff:
        9'h114:
        begin
          reference_cnt <= 1;
          osc_cnt_int   <= 0;
        end
        9'h64:
        begin
          hundred     <= 1;
          osc_cnt_int <= osc_cnt_int + 1;
        end
        9'h96:
        begin
          hundred     <= 0;
          one_fifty   <= 1;
          osc_cnt_int <= osc_cnt_int + 1;
        end
        default
        begin
          one_fifty     <= 0;
          reference_cnt <= 0;
          osc_cnt_int   <= osc_cnt_int + 1;
        end
        endcase
      end
    end
    
    always @ (posedge osc or negedge reset_n) begin
      if (~reset_n)
        toggle <= 'b0;
      else begin
        if ((reference_cnt) && (!reference_cnt_d))
           toggle <= !toggle;
      end
    end

    assign dskip_n = toggle;
    
    always @ (posedge osc or negedge reset_n) begin
      if (~reset_n)
        reference_cnt_d <= 'b0;
      else begin
        if (counter_reset == 1'b1)
          reference_cnt_d <= 'b0;
        else
          reference_cnt_d <= reference_cnt;
      end
    end
  
    // pz counter
    always @(posedge osc or negedge reset_n) begin
      if(~reset_n) begin
          pz_cnt_int <= 0;
          pz_cnt24_a_int <= 0;
          pz_cnt24_b_int <= 0;
      end
      else begin
        if (counter_reset == 1'b1) begin
          pz_cnt_int <= 0;
          pz_cnt24_a_int <= 0;
          pz_cnt24_b_int <= 0;
        end
        else begin
          pz_cnt_int <= pz_cnt_int+1;
          pz_cnt24_a_int <= pz_cnt24_a_int + 1;
          pz_cnt24_b_int <= pz_cnt24_b_int - 1;
        end
      end
    end
    
    generate
      genvar i;
      for(i=0; i<4;i=i+1) begin
        always @(posedge osc or negedge reset_n) begin
          if (~reset_n) begin
             pz_xor4[i] <= 'd0;
          end
          else begin
            if (counter_reset == 1'b1) 
              pz_xor4[i] <= 'd0;
            else
              pz_xor4[i] <=(^pz_cnt24_a[4*i+3:4*i])&(^pz_cnt24_b[4*i+3:4*i]);
          end
        end
      end
    endgenerate

    always @(posedge osc or negedge reset_n) begin
      if(~reset_n) begin
        osc_cnt    <= 'd0;
        pz_cnt     <= 'd0;
        pz_cnt24_a <= 'd0;
        pz_cnt24_b <= 'd0;
      end
      else begin
        if (counter_reset == 1'b1) begin
           osc_cnt    <= 'd0;
           pz_cnt     <= 'd0;
           pz_cnt24_a <= 'd0;
          pz_cnt24_b <= 'd0;
        end
        else begin
          osc_cnt    <= (dskip_n) ? osc_cnt_int : 0;
          pz_cnt     <= (dskip_n) ? pz_cnt_int : 0;
          pz_cnt24_a <= (dskip_n) ? pz_cnt24_a_int : 0;
          pz_cnt24_b <= (dskip_n) ? pz_cnt24_b_int : 0;
        end
      end
    end

    updown_cntr updown_cntr01(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt01),.cntr(pz_cnt01),.offset('d1));
    updown_cntr updown_cntr02(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt02),.cntr(pz_cnt02),.offset('d2));
    updown_cntr updown_cntr03(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt03),.cntr(pz_cnt03),.offset('d3));
    updown_cntr updown_cntr04(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt04),.cntr(pz_cnt04),.offset('d4));
    updown_cntr updown_cntr05(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt05),.cntr(pz_cnt05),.offset('d5));
    updown_cntr updown_cntr06(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt06),.cntr(pz_cnt06),.offset('d6));
    updown_cntr updown_cntr07(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt07),.cntr(pz_cnt07),.offset('d7));
    updown_cntr updown_cntr08(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt08),.cntr(pz_cnt08),.offset('d8));
    updown_cntr updown_cntr09(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt09),.cntr(pz_cnt09),.offset('d9));
    updown_cntr updown_cntr10(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt10),.cntr(pz_cnt10),.offset('d10));
    updown_cntr updown_cntr11(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt11),.cntr(pz_cnt11),.offset('d11));
    updown_cntr updown_cntr12(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt12),.cntr(pz_cnt12),.offset('d12));
    updown_cntr updown_cntr13(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt13),.cntr(pz_cnt13),.offset('d13));
    updown_cntr updown_cntr14(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt14),.cntr(pz_cnt14),.offset('d14));
    updown_cntr updown_cntr15(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt15),.cntr(pz_cnt15),.offset('d15));
    updown_cntr updown_cntr16(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt16),.cntr(pz_cnt16),.offset('d16));
    updown_cntr updown_cntr17(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt17),.cntr(pz_cnt17),.offset('d17));
    updown_cntr updown_cntr18(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt18),.cntr(pz_cnt18),.offset('d18));
    updown_cntr updown_cntr19(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt19),.cntr(pz_cnt19),.offset('d19));
    updown_cntr updown_cntr20(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt20),.cntr(pz_cnt20),.offset('d20));
    updown_cntr updown_cntr21(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt21),.cntr(pz_cnt21),.offset('d21));
    updown_cntr updown_cntr22(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt22),.cntr(pz_cnt22),.offset('d22));
    updown_cntr updown_cntr23(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt23),.cntr(pz_cnt23),.offset('d23));
    updown_cntr updown_cntr24(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt24),.cntr(pz_cnt24),.offset('d24));
    updown_cntr updown_cntr25(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt25),.cntr(pz_cnt25),.offset('d25));
    updown_cntr updown_cntr26(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt26),.cntr(pz_cnt26),.offset('d26));
    updown_cntr updown_cntr27(.clk(osc),.reset_n(reset_n),.counter_reset(counter_reset),.dskip_n(dskip_n),.cntr_prev(pz_cnt27),.cntr(pz_cnt27),.offset('d27));

    // To generate extra counter instances. Number of extra instances is 
    // controlled by the parameter EXTRA_CNT and the define EXT_CNT_ENBL
    `ifdef EXT_CNT_ENBL
        wire [USERBIT_WIDTH-1:0] pz_cnt_cur [EXTRA_CNT-1:0];
        generate begin : extr_cnt_inst
           genvar i;
              for(i=0; i<EXTRA_CNT ;i= i+1) begin : extr_cnt
                 updown_cntr updown_cntr (.clk(osc),
                                          .reset_n(reset_n),
                                          .counter_reset(counter_reset),
                                          .dskip_n(dskip_n),
                                          .cntr_prev(pz_cnt_cur[i]),
                                          .cntr(pz_cnt_cur[i]),
                                          .offset(i));
              end
           end
        endgenerate
    `endif

endmodule

module updown_cntr #( parameter WIDTH=64)
(
    input clk,
    input reset_n,
    input counter_reset,
    input dskip_n,
    input [WIDTH-1:0] cntr_prev,
    output reg [WIDTH-1:0] cntr,
    input [WIDTH/2-1:0] offset
);

/*
initial
begin
  cntr = 0;
end
*/

    always @(posedge clk or negedge reset_n) begin
      if(~reset_n) begin
          cntr[WIDTH-1:WIDTH/2] <= offset;
          cntr[WIDTH/2-1:0] <= offset;
      end
      else if (counter_reset == 1'b1) begin
          cntr[WIDTH-1:WIDTH/2] <= offset;
          cntr[WIDTH/2-1:0] <= offset;
      end
      else if(dskip_n) begin
          cntr[WIDTH-1:WIDTH/2] <= cntr_prev[WIDTH-1:WIDTH/2] - offset;
          cntr[WIDTH/2-1:0] <= cntr_prev[WIDTH/2-1:0] + offset;
      end
    end
endmodule