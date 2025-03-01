`timescale 1ns / 1ps

module auto_sliding_door(
    input clk,
    input rst,
    input person_detected,
    input door_opened,
    input door_closed,
    input timer_expired,
    output reg mo,//motor_open
    output reg mc,//motor_close
    output reg ms //motor_stop
    );
    
    reg [2:0] state;
    localparam IDLE = 3'b000,
               OPENING = 3'b001,
               OPEN = 3'b010,
               CLOSING = 3'b011,
               STOP = 3'b100;
    reg [3:0] count; // fix amount of time the door needs to stay open after that, once timer_expired is rcvd, door will start closing
   always@(posedge clk, negedge rst)
   begin
    if(~rst)    begin
        state <= IDLE;
        mo <= 0;
        mc <= 0;
        ms <= 0;
        count <= 0;
    end
    else    begin
        case(state)
            IDLE:   begin
                if(person_detected && door_closed)  begin
                    mo <= 1'b1;
                    state <= OPENING;
                    count <= 4'd0;
                    mc <= 1'b0;
                    ms <= 1'b0;
                end
            end
            OPENING: begin
                if(door_opened)    begin
                    count <= 4'd15;
                    mo <= 1'b0;
                    mc <= 1'b0;
                    ms <= 1'b0;
                    state <= OPEN;
                end
            end
            OPEN:   begin
                if(count>0 || person_detected)    begin
                    if(person_detected) begin
                        count <= 4'd15; //timer restarts if the person is detected when the door is still open
                    end
                    else    begin
                        count <= count - 1'b1;
                    end
                end
                else if(timer_expired)   begin
                    state <= CLOSING;
                    mc <= 1'b1;
                    mo <= 1'b0;
                    ms <= 1'b0;
                end
            end
            CLOSING:    begin
                if(person_detected) begin
                    state <= STOP;
                    mc <= 1'b0;
                    ms <= 1'b1;
                    mo <= 1'b0;
                end
                else if(door_closed)    begin
                    state <= IDLE;
                    mc <= 1'b0;
                    ms <= 1'b0;
                    mo <= 1'b0;
                end
            end
            STOP:   begin
                if(~person_detected)    begin
                    state <= OPENING;
                    mo <= 1'b1;
                    ms <= 1'b0;
                    mc <= 1'b0;
                end
            end
            default:    begin
                state <= IDLE;
                {mo,mc,ms} <= {3'b0};
            end
        endcase
    end
   end
    
endmodule
