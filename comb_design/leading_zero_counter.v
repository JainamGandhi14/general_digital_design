`timescale 1ns / 1ps

module leading_zero_counter #(parameter len = 4)(
    input [len-1:0] a,
    output reg [$clog2(len):0] z
    );
    integer i;
    reg flag;
    always@(*)
    begin
        flag = 0;
        z = len;
        for(i=len-1;i>=0;i=i-1)   begin
            if(a[i] && (!flag))    begin
                z = len - 1 - i;
                flag = 1;
            end
        end
    end
    
endmodule
