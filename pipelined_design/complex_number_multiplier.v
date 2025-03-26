`timescale 1ns / 1ps
//Real=(a×c)-(b×d)
//Imag=(a×d)+(b×c)
//where the first complex number is A=a+jb and second is B=c+jd. 

module pipelined_complex_mult (
    input clk,                   // Clock signal
    input rst,                   // Active-high reset
    input signed [7:0] a,        // 8-bit signed real part of A
    input signed [7:0] b,        // 8-bit signed imaginary part of A
    input signed [7:0] c,        // 8-bit signed real part of B
    input signed [7:0] d,        // 8-bit signed imaginary part of B
    output reg signed [16:0] real_out, // 17-bit signed real part of the product
    output reg signed [16:0] imag_out  // 17-bit signed imaginary part of the product
);

reg signed [7:0] a_reg, b_reg, c_reg, d_reg;
reg signed [15:0] r1,r2,i1,i2;//mult
reg signed [16:0] re, im; //add sub

//capture
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        a_reg <= 0;
        b_reg <= 0;
        c_reg <= 0;
        d_reg <= 0;
    end
    else    begin
        a_reg <= a;
        b_reg <= b;
        c_reg <= c;
        d_reg <= d;
    end
end


//multiply
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        r1 <= 0;
        r2 <= 0;
        i1 <= 0;
        i2 <= 0;
    end
    else    begin
        r1 <= a_reg * c_reg;
        r2 <= b_reg * d_reg;
        i1 <= a_reg * d_reg;
        i2 <= b_reg * c_reg;
    end 
end

//add-subtract
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        re <= 0;
        im <= 0;
    end
    else    begin
        re <= r1 - r2;
        im <= i1 + i2;
    end 
end

//output push
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        real_out <= 0;
        imag_out <= 0;
    end
    else    begin
        real_out <= re;
        imag_out <= im;
    end 
end

endmodule