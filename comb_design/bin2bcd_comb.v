`timescale 1ns / 1ps

module bin2bcd(
    input [3:0] in,
    output [4:0] op
    );
    
    assign op = (in<4'd10)? {1'b0,in} : {1'b1,(in-4'd10)};//4 bit binary to bcd conversion- easy to understand
    /*easy-to scale design approach here using only comb logic is not feasible
    for easy-to scale approach, need to go with algorithmic approach like double-dabby or something like that*/
endmodule
