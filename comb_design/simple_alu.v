`timescale 1ns/1ps
module simple_alu(
    input  [3:0] A,        // 4-bit input operand A
    input  [3:0] B,        // 4-bit input operand B
    input  [1:0] op_sel,   // 2-bit operation select
    output reg [3:0] result,   // 4-bit result of the operation
    output reg flag      // Carry out for addition / Borrow for subtraction (optional)
);

always@(*)
begin
    result = 0;
    flag = 0;
    case(op_sel)
        2'b00:  begin//add
            {flag,result} = A + B;
        end
        2'b01:  begin//sub
            {flag,result} = A - B;
        end
        2'b10:  begin//and
             result = A & B;
        end
        2'b11:  begin//or
            result = A | B;
        end
        default:    begin
            result = 0;
            flag = 0;
        end
    endcase
end
endmodule