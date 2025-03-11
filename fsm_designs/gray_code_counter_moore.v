`timescale 1ns / 1ps

/*Problem Statement: Design a finite state machine (FSM) that generates a 3-bit Gray Code sequence. 
Requirements
Implement the FSM with both state and next_state logic.
Use a Moore Machine for clear state-to-output mapping.
Ensure glitch-free output transitions.*/

module gray_code_counter (
    input clk,             // Clock signal
    input rst,             // Active high reset signal
    output reg [2:0] gray_code // 3-bit Gray code output
);

reg [1:0] state, next_state;
reg [2:0] bin_count;

//registering the current state
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        state <= 0;
    end
    else    begin
        state <= next_state;
    end
end
//fsm logic- combinational
always@(*)
begin
    case(state)
    2'b00:  begin//reset state
        next_state = 2'b01;
    end
    2'b01:  begin//counting state
        next_state = 2'b01;
    end
    default:    begin
        next_state = 2'b00;
    end    
    endcase
end
//keep the binary count in place
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        bin_count <= 0;
    end
    else    begin
        if(next_state==2'b01)    begin
            bin_count <= bin_count + 1'b1;
        end
    end
end
//generating the output
always@(posedge clk, negedge rst)
begin
    if(~rst)    begin
        gray_code <= 0;
    end
    else    begin
        if(next_state==2'b01)    begin
            gray_code <= (bin_count ^ bin_count>>1);
        end
    end
end
endmodule