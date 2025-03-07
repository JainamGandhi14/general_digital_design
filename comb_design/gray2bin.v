`timescale 1ns / 1ps
module gray2bin #(parameter length=4)(
    input [length-1:0] in,
    output reg [length-1:0] op
    );
    
    integer i;
    always@(*)
    begin
        op = in;
        for(i=length-2;i>=0;i=i-1)  begin
            op[i] = op[i+1] ^ in[i];//easy to scale
        end
    end
endmodule
