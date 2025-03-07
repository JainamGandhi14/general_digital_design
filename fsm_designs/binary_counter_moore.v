`timescale 1ns / 1ps

/*module leading_zero_counter #(parameter len = 4)(
    input [len-1:0] a,
    output reg [$clog2(len):0] z
    );
    integer i;
    reg flag;
    always@(*)
    begin
        flag = 0;
        z = len;
        for(i=len-1;i>=0;i=i-1)   begin
            if(a[i] && (!flag))    begin
                z = len - 1 - i;
                flag = 1;
            end
        end
    end
    
endmodule
*/
module counter_fsm(
    input clk,          // Clock signal
    input rst,          // Reset signal
    output reg [1:0] count  // 2-bit output count
);

reg [1:0] state;

always@(posedge clk, posedge rst)
begin
    if(rst) begin
        state <= 0;
    end
    else    begin
        case(state)
        2'b00:  begin
            state <= 2'b01;
        end
        2'b01:  begin
            state <= 2'b10;
        end
        2'b10:  begin
            state <= 2'b11;
        end
        2'b11:  begin
            state <= 2'b00;
        end
        default:    begin
            state <= 2'b00;
        end
        endcase
    end
end

always@(posedge clk, posedge rst)
begin
    if(rst) begin
        count <= 0;
    end
    else    begin
        count <= state;
    end
end
endmodule