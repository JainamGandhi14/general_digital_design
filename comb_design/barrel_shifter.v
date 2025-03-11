`timescale 1ns / 1ps


module barrel_shifter #(parameter bits = 4)(
    input  [bits-1:0] in,
    input  [$clog2(bits)-1:0] shift,
    output [bits-1:0] out
);
//easy to scale
assign out = in<<shift | in>>(bits-shift);//understanding how shifting really works helps here 

endmodule