`timescale 1ns / 1ps

module combination_lock(
    input clk,       // Clock signal
    input rst,       // Reset signal (active high)
    input A,         // Button A input
    input B,         // Button B input
    input C,         // Button C input
    input D,         // Button D input
    output reg unlock // Unlock signal (asserted when correct sequence is entered)
    );
    
    reg [2:0] state;
    localparam [2:0] idle = 3'b000,
                     a = 3'b001,
                     c = 3'b011,
                     d = 3'b100;
     //simple state machine                
     always@(posedge clk, posedge rst)
     begin
        if(rst) begin
            state <= idle;
            unlock <= 0;
        end
        else    begin
            case(state)
                idle:   begin
                    if(A)   begin
                        state <= a;
                        unlock <= 0;
                    end
                end
                a : begin
                    if(C)   begin
                        state <= c;
                        unlock <= 0;
                    end
                    else if(A || B || D)   begin
                        state <= idle;
                        unlock <= 0;
                    end
                end
                c : begin
                    if(D)   begin
                        state <= d;
                        unlock <= 0;
                    end
                    else if(A || B || C)   begin
                        state <= idle;
                        unlock <= 0;
                    end
                end
                d : begin
                    if(B)   begin
                        state <= idle;
                        unlock <= 1;
                    end
                    else if(A || C || D)   begin
                        state <= idle;
                        unlock <= 0;
                    end
                end
            endcase
        end
     end
endmodule
