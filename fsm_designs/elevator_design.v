`timescale 1ns / 1ps

module elevator_controller(
    input clk,         // Clock signal
    input rst,         // asynchronous reset (active high)
    input req1,        // Request from Floor 1
    input req2,        // Request from Floor 2
    input req3,        // Request from Floor 3
    output reg [1:0] floor  // Current floor: 2'b01 = Floor1, 2'b10 = Floor2, 2'b11 = Floor3
);

reg [1:0] state;//
reg moving; // indicates that the elevator is moving
localparam f0 = 2'b00,
           f1 = 2'b01,
           f2 = 2'b10,
           f3 = 2'b11;
parameter ground_floor = 2'b00;           
 always@(posedge clk, posedge rst)//following the nearest floor approach
 begin
    if(rst) begin
        state <= f0;
        moving <= 0; 
    end
    else    begin
        case(state)
            f0: begin
                if(req1 || req2 || req3)    begin
                    if(req1)    begin
                        state <= f1;
                        moving <= 1;
                    end
                    else if(req2)   begin
                        state <= f2;
                        moving <= 1;
                    end
                    else if(req3)   begin
                        state <= f3;
                        moving <= 1;
                    end
                end
                else    begin
                    moving <= 0;
                    state <= f0;
                end
            end
            f1: begin
                    if(req2)   begin
                        state <= f2;
                        moving <= 1;
                    end
                    else if(req3)   begin
                        state <= f3;
                        moving <= 1;
                    end
                    else    begin
                        moving <= 0;
                        state <= f1;
                    end
            end
            f2: begin
                    if(req3)   begin
                        state <= f3;
                        moving <= 1;
                    end
                    else if(req1)   begin
                        state <= f1;
                        moving <= 1;
                    end
                    else    begin
                        moving <= 0;
                        state <= f2;
                    end
            end
            f3: begin
                    if(req2)   begin
                        state <= f2;
                        moving <= 1;
                    end
                    else if(req1)   begin
                        state <= f1;
                        moving <= 1;
                    end
                    else    begin
                        moving <= 0;
                        state <= f3;
                    end
            end
            default:    begin
                state <= f0;
                moving <= 1;
            end
        endcase
    end
 end        
 
 //output floor
    always@(posedge clk, posedge rst)
    begin
        if(rst) begin
            floor <= 0;   
        end
        else    begin
            floor <= (state!=f0)? state : ground_floor;
        end   
    end
      

endmodule