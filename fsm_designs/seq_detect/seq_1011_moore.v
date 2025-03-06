`timescale 1ns / 1ps

module seq_1011(
    input clk,
    input rst,
    input in,
    output reg op
    );
    
    reg [2:0] state;
    localparam s0 = 3'b000,
               s1 = 3'b001,
               s2 = 3'b010,
               s3 = 3'b011,
               s4 = 3'b100;
        always@(posedge clk, posedge rst)
    begin
        if(rst) begin
            op <= 0;
            state <= s0;
        end
        else    begin
            case(state)
                s0: begin
                    if(in)    begin
                        state <= s1;
                    end
                    else    begin
                        state <= s0;
                    end
                end
                s1: begin
                    if(in)    begin
                        state <= s1;
                    end
                    else    begin
                        state <= s2;
                    end
                end
                s2: begin
                    if(in)    begin
                        state <= s3;
                    end
                    else    begin
                        state <= s0;
                    end
                end
                s3: begin
                    if(in)    begin
                        state <= s4;
                    end
                    else    begin
                        state <= s2;
                    end
                end
                s4: begin
                    if(in)    begin
                        state <= s1;
                    end
                    else    begin
                        state <= s2;
                    end
                end
                default:    begin
                    state <= s0;
                end
            endcase
        end
    end
    
    always@(*)
    begin
            op = (state == s4);
    end
    
               
endmodule
