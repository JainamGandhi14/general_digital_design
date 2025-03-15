`timescale 1ns/1ps
module pipelined_adder_tree (
    input clk,                      // Clock signal
    input rst,                      // Synchronous reset (active high)
    input [7:0] in0, in1, in2, in3,  // First four 8-bit inputs
    input [7:0] in4, in5, in6, in7,  // Next four 8-bit inputs
    output reg [11:0] sum           // 12-bit output sum
);

reg [8:0] s1[0:3];
reg [9:0] s2[0:1];

//1st stage
//in0 + in4, in1 + in5, in2 + in6, in3 + in7
always@(posedge clk)
begin
    if(rst) begin
        s1[0] <= 0;
        s1[1] <= 0;
        s1[2] <= 0;
        s1[3] <= 0;
    end
    else    begin
        s1[0] <= in0 + in1;
        s1[1] <= in2 + in3;
        s1[2] <= in4 + in5;
        s1[3] <= in6 + in7;
    end
end
  
//2nd stage
//s1[0] + s1[1], s1[2] + s1[3]
always@(posedge clk)
begin
    if(rst) begin
        s2[0] <= 0;
        s2[1] <= 0;
    end
    else    begin
        s2[0] <= s1[0] + s1[1];
        s2[1] <= s1[2] + s1[3];
    end
end

//3rd stage
//s2[0] + s2[1]
always@(posedge clk)
begin
    if(rst) begin
        sum <= 0;
    end
    else    begin
        sum <= s2[0] + s2[1];
    end
end


endmodule
