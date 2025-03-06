`timescale 1ns / 1ps

module bin2gray(
    input [3:0] in,
    output [3:0] op
    );
    
    assign op = in ^ {1'b0,in[3:1]};
endmodule
