`timescale 1ns / 1ps

module palindrome_detector (
    input  [7:0] data,       // 8-bit binary input
    output     palindrome  // 1-bit output: 1 if 'data' is a palindrome, 0 otherwise
);
integer i;
reg [7:0] data_b;
assign palindrome = data == data_b;
always@(*)
begin
    data_b = 0;
    for(i=0;i<8;i=i+1)
    begin
        data_b[i] = data[7-i]; 
    end
end

endmodule