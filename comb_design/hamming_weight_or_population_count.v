`timescale 1ns / 1ps

//Design a combinational circuit that counts the number of 1's in a 4-bit input and outputs the count as a 3-bit number.
//hamming weight circuit design
module population_counter #(parameter bits = 4)(
    input [(bits-1):0] in,
    output reg [($clog2(bits)):0] op
    );
    //scalable combinational design
    integer i;
    always@(*)
    begin
        op=0;//to ensure latch free design
        for(i=0;i<bits;i=i+1)   begin
            op = op + in[i];
        end
    end
endmodule
