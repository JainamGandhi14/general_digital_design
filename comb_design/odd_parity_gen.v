`timescale 1ns / 1ps

module odd_parity_generator(
    input [7:0] data,   // 8-bit binary input
    output parity       // 1-bit odd parity output
);




assign parity = ~(^data);

endmodule