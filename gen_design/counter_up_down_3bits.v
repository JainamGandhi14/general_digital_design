`timescale 1ns / 1ps
module up_down_counter(input clk, input rst, input up_down,
                        output reg[2:0] count);
                        
                        
always@(posedge clk, negedge rst)
begin
    if(~rst) begin
        count <= 0;
    end
    else    begin
        count <= up_down? count + 1'b1: count - 1'b1;//wrapping is part of the bit structure itself for hardware
    end
end
endmodule