`timescale 1ns / 1ps
module mux_4to1 (
    input [3:0] A,    // 4-bit input A
    input [3:0] B,    // 4-bit input B
    input [3:0] C,    // 4-bit input C
    input [3:0] D,    // 4-bit input D
    input [1:0] sel,  // 2-bit select signal
    output reg [3:0] out // 4-bit output
);

always@(*)
begin: MUX
case(sel)
2'b00 : out = A;
2'b01 : out = B;
2'b10 : out = C;
2'b11 : out = D;
default:    out = 4'b0;
endcase
end

endmodule
