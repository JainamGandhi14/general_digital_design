`timescale 1ns / 1ps
//Y = (A+B) * (C-D)
module pipelined_arith_unit (
    input clk,                  // Clock signal
    input rst,                  // Active-high reset
    input signed [7:0] A,       // 8-bit signed input A
    input signed [7:0] B,       // 8-bit signed input B
    input signed [7:0] C,       // 8-bit signed input C
    input signed [7:0] D,       // 8-bit signed input D
    output reg signed [15:0] Y  // 16-bit signed output result
);
reg signed [7:0] a_reg, b_reg, c_reg, d_reg;
reg signed [8:0] add, sub;
reg signed [15:0] y_reg;  
//capture
always@(posedge clk, posedge rst)
begin : Capturing_Event
    if(rst) begin
       a_reg <= 0;
       b_reg <= 0;
       c_reg <= 0;
       d_reg <= 0; 
    end
    else    begin
        a_reg <= A;
        b_reg <= B;
        c_reg <= C;
        d_reg <= D;
    end
end

//arith
always@(posedge clk, posedge rst)
begin : first_Event
    if(rst) begin
        add <= 0;
        sub <= 0;
    end
    else    begin
        add <= a_reg + b_reg;
        sub <= c_reg - d_reg;
    end
end

//mult
always@(posedge clk, posedge rst)
begin : second_Event
    if(rst) begin
        Y <= 0;
        y_reg <= 0;
    end
    else    begin
        y_reg <= add * sub;
        Y <= y_reg;
    end
end


endmodule
