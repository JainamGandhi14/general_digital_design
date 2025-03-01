`timescale 1ns / 1ps

//FIR filter - 3rd order

module fir #(parameter c0=8'd1,c1=8'd2,c2=8'd3,c3=8'd4)(input clk, input rst, input [7:0] in, output reg [17:0] op
);

reg [7:0] in_0, in_1, in_2, in_3;
reg [15:0] mult0, mult1, mult2, mult3;
reg [16:0] add1,add2;
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        in_0 <= 8'b0;
        in_1 <= 8'b0;
        in_2 <= 8'b0;
        in_3 <= 8'b0;
        op <= 16'b0;
        add1 <= 16'b0;
        add2 <= 16'b0;
    end
    else    begin
    //shifting
        in_0 <= in;
        in_1 <= in_0;
        in_2 <= in_1;
        in_3 <= in_2;
    //multiply
        mult0 <= c0 * in_0;
        mult1 <= c1 * in_1;
        mult2 <= c2 * in_2;
        mult3 <= c3 * in_3;
    //partial accumulate
        add1 <= mult0 + mult1;
        add2 <= mult2 + mult3;
    //accumulate
        op <= add1 + add2;
    end
end

endmodule
