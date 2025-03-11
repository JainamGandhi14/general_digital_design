`timescale 1ns / 1ps

/*Pipeline Design Problem:
Design a 3-stage pipelined arithmetic unit that computes the following equation:
Y=((A+B)×C)+D */
module pipelined_arith_unit (
    input clk,             // Clock signal
    input rst,             // Reset signal (active low)
    input [7:0] a, b, c, d, // 8-bit inputs
    output reg [17:0] y     // 19-bit output to accomodate all the cases -- 2**17 + 2**8
);
//bit structure is to avoind all the possible overflows
reg [8:0]add1;
reg [16:0] mult;//2**9 * 2**8
reg [7:0] a_reg, b_reg;
reg [7:0] c_reg[0:1]; 
reg [7:0] d_reg[0:2];
//capture the inputs
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        a_reg <= 0;
    end
    else    begin
        a_reg <= a;
    end
end
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        b_reg <= 0;
    end
    else    begin
        b_reg <= b;
    end
end
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        c_reg[0] <= 0;
        c_reg[1] <= 0;
    end
    else    begin
        c_reg[0] <= c;
        c_reg[1] <= c_reg[0];
    end
end
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        d_reg[0] <= 0;
        d_reg[1] <= 0;
        d_reg[2] <= 0;
    end
    else    begin
        d_reg[0] <= d;
        d_reg[1] <= d_reg[0];
        d_reg[2] <= d_reg[1];
    end
end
//addition A+B
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        add1 <= 0;
    end
    else    begin
        add1 <= a_reg + b_reg;
    end
end
//mult with C
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        mult <= 0;
    end
    else    begin
        mult <= add1 * c_reg[1];
    end
end
//add D

always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        y <= 0;
    end
    else    begin
        y <= mult + d_reg[2];
    end
end

endmodule