`timescale 1ns / 1ps

module bin2gray(
    input [3:0] in,
    output [3:0] op
    );
    
    assign op = in ^ in>>1; // easy to scale
endmodule
