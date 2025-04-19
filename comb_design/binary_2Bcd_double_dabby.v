`timescale 1ns / 1ps

module bin_to_bcd (
    input  [7:0] binary,   // 8-bit binary input
    output [3:0] hundreds, // 4-bit BCD hundreds place
    output [3:0] tens,     // 4-bit BCD tens place
    output [3:0] ones      // 4-bit BCD ones place
);

//double dabby
//if any nibble > 4 then, add 3 and then shift
reg [19:0]acc;
integer i;
assign hundreds = acc[19:16];
assign tens = acc[15:12];
assign ones = acc[11:8];
always@(*)
begin
    acc = {12'b0,binary};//12 + 8 = 20 bits
    for(i=0;i<8;i=i+1)  begin
        if(acc[19:16] > 4 || acc[15:12] >4 || acc [11:8] > 4)   begin
            acc[15:8] = acc[11:8] > 4? acc[15:8] + 2'd3: acc[15:8];
            acc[19:12] = acc[15:12] > 4? acc[19:12] + 2'd3: acc[19:12];
            acc[19:16] = acc[19:16] > 4? acc[19:16] + 2'd3: acc[19:16];
            acc = {acc[18:0], 1'b0};
        end
        else    begin
            acc = {acc[18:0], 1'b0};
        end
    end
end

endmodule