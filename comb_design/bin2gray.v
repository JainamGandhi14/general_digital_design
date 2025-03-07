`timescale 1ns / 1ps

module bin2gray #(parameter length=4) (
    input [length-1:0] in,
    output [length-1:0] op
    );
    
    assign op = in ^ in>>1; // easy to scale
endmodule
