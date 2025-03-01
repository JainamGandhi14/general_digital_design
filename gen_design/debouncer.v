`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2025 16:45:44
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce #(parameter N=4)(
    input clk,
    input rst,
    input push_b,
    output reg stable_b
    );
    
    localparam bits = $clog2(N);
    reg [bits-1:0] count;
    
    
    always@(posedge clk, posedge rst)
    begin
        if(rst) begin
            count <= 0;
            stable_b <= 0;
        end
        else    begin
            if(push_b)  begin
                if(count<(N-1)) begin
                count <= count + 1'b1;
                stable_b <= 0;
                end
                else    begin
                    stable_b <= 1;
                end
            end
            else    begin
                count <= 0;
                stable_b <= 0;
            end
        end 
    end
endmodule
