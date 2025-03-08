`timescale 1ns / 1ps

module four_to_two #(parameter len=4)(
    input [len-1:0] in,
    output reg [$clog2(len)-1:0] op,
    output valid
    );
    assign valid = in != {len{0}};
    integer i;
    always@(*)
    begin
        op=0;//to avoid unwanted latches
        for(i=0;i<len;i=i+1)
        begin
            op = (in[i]==1'b1)?i:op;
        end
    end
endmodule
