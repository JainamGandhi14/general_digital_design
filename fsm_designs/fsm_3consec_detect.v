`timescale 1ns / 1ps

module fsm_3consec_ones (
    input clk,       // Clock signal
    input rst,       // Active-high reset
    input in,        // Serial input
    output reg out   // Output: 1 if "111" is detected
);

//states - 3 states
reg [1:0] state;
localparam s0 = 2'b00,
           s1 = 2'b01,
           s2 = 2'b10;

always@(posedge clk, posedge rst)
begin
    if(rst) begin
        state <= s0;
        out <= 0;
    end
    else    begin
        case(state)
            s0: begin
                if(in)  begin
                    state <= s1;
                    out <= 1'b0;
                end
                else    begin
                    state <= s0;
                    out <= 1'b0;
                end
            end
            s1: begin
                if(in)  begin
                    state <= s2;
                    out <= 1'b0;
                end
                else    begin
                    state <= s0;
                    out <= 1'b0;
                end
            end
            s2: begin
                if(in)  begin
                    state <= s2;
                    out <= 1'b1;
                end
                else    begin
                    state <= s0;
                    out <= 1'b0;
                end
            end
            default:    begin
                    state <= s0;
                    out <= 1'b0;
            end
        endcase
    end
end


endmodule