module memory
#(parameter SIZE = 1000000,
            WIDTH = 16)
(
input [WIDTH-1:0] data_in,
output reg [WIDTH-1:0] data_out,
input enable,
input wr_enable,
input [$clog2(SIZE)-1:0] addr,
input clk
    );
   
        
    reg [WIDTH-1:0] mem [SIZE-1:0];
    
    always @ (posedge clk) begin
        if (enable)begin
            data_out <= mem[addr];
                if (wr_enable)
                    mem[addr] <= data_in;
        end
    end                
    
endmodule          