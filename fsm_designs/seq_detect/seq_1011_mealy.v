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
               s3 = 3'b011;
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
                        op <= 0;
                    end
                    else    begin
                        state <= s0;
                        op <= 0;
                    end
                end
                s1: begin
                    if(in)    begin
                        state <= s1;
                        op <= 0;
                    end
                    else    begin
                        state <= s2;
                        op <= 0;
                    end
                end
                s2: begin
                    if(in)    begin
                        state <= s3;
                        op <= 0;
                    end
                    else    begin
                        state <= s0;
                        op <= 0;
                    end
                end
                s3: begin
                    if(in)    begin
                        state <= s1;
                        op <= 1;
                    end
                    else    begin
                        state <= s2;
                        op <= 0;
                    end
                end
                default:    begin
                    state <= s0;
                    op <= 0;
                end
            endcase
        end
    end
    
    
               
endmodule
