`timescale 1ns / 1ps


module matrix2x2_mult (
    input       clk,
    input       rst,
    input       start,

    input [7:0]  a00, a01,
    input [7:0]  a10, a11,
    input [7:0]  b00, b01,
    input [7:0]  b10, b11,

    output reg [16:0] c00, c01,
    output reg [16:0] c10, c11,
    output reg done
);

always@(posedge clk, posedge rst)
begin
    if(rst) begin
        c00 <= 0;
        c01 <= 0;
        c10 <= 0;
        c11 <= 0;
        done <= 0;
    end
    else    begin
        if(start)   begin
            c00 <= (a00 * b00) + (a01 * b10);
            c01 <= (a00 * b01) + (a01 * b11);
            c10 <= (a10 * b00) + (a11 * b10);
            c11 <= (a10 * b01) + (a11 * b11);
            done <= 1'b1;
        end
        else    begin
            c00 <= 0;
            c01 <= 0;
            c10 <= 0;
            c11 <= 0;
            done <= 0;    
        end
    end
end

endmodule
