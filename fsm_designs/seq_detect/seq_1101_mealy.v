`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 16:31:57
// Design Name: 
// Module Name: seq_1101_mealy
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


module seq_1101_mealy(
    input clk,       // Clock signal
    input rst,       // Reset signal (active high)
    input in,        // Serial input bit
    output reg op  // Output signal: 1 when "1101" is detected
    );
    //designing this fsm with different concept than the ones that I have in this directory
    //here, the state modification and outputs is combinatorial ckt while next_state updates are sequential
    //almost similar to all the designs that I have here, just the different structure of the code using blocking and non-blocking efficiently
    /*with this approach, there will be glitches in the output as the output is unregistered, so, for mealy machine, we can add the register for the output which will delay the output by 1 clock cycle,
    or using the moore machine with the similar approach woould help with the glitch problem.
    */
    reg [1:0] state,next_state;
    
    always@(posedge clk, posedge rst)
    begin
        if(rst) begin
            state <= 2'b00;
        end
        else    begin
            state <= next_state;
        end
    end
    
    always@(*)
    begin
        case(state)
        2'b00:  begin
            if(in)  begin
                next_state = 2'b01;
                op = 0;
            end
            else    begin
                next_state = 2'b00;
                op = 0;
            end
        end
        2'b01:  begin
            if(in)  begin
                next_state = 2'b10;
                op = 0;
            end
            else    begin
                next_state = 2'b00;
                op = 0;
            end
        end
        2'b10:  begin
            if(in)  begin
                next_state = 2'b10;
                op = 0;
            end
            else    begin
                next_state = 2'b11;
                op = 0;
            end
        end
        2'b11:  begin
            if(in)  begin
                next_state = 2'b01;
                op = 1;
            end
            else    begin
                next_state = 2'b00;
                op = 0;
            end
        end
        default:    begin
                next_state = 2'b00;
                op = 0;
            end
        endcase
    end
    
    
endmodule
