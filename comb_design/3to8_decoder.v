`timescale 1ns / 1ps
module decoder_3to8 (
    input [2:0] sel,   // 3-bit select input
    output [7:0] out  // 8-bit output
); //a decoder without any enable signal
//elegant solution and very easy to scale by changing IO bits only.
assign out = 1'b1<<sel; 

endmodule
