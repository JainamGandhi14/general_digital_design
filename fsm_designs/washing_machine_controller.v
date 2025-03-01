`timescale 1ns / 1ps

module washing_machine_controller #(parameter count_m=7, count_mo= 14)(
    input clk,
    input rst,
    input start,
    input door_closed,
    input water_full,
    input water_empty, // optional
    output reg water_valve,
    output reg drain_valve,
    output reg [1:0] motor,   // e.g., 00: off, 01: wash speed, 10: spin speed
    output reg end_cycle
);
    reg [3:0] count; 
    reg [3:0] state;
    localparam idle = 4'b0000,
               fill = 4'b0001,
               wash = 4'b0010,
               drain = 4'b0011,
               rinse = 4'b0100,
               spin = 4'b1001,
               end_c = 4'b1011;
    
    always@(posedge clk, posedge rst)
    begin
        if(rst) begin
            state <= 4'b0;
            water_valve <= 1'b0;
            drain_valve <= 1'b0;
            motor <= 2'b0;
            end_cycle <= 1'b0;
            count <= 0;
        end
        else    begin
            case(state)
            idle:   begin
                if(start&&door_closed)   begin
                    state <= fill;
                    water_valve <= 1'b1;
                end
            end
            fill:   begin
                if(water_full)  begin
                    state <= wash;
                    water_valve <= 1'b0;
                    motor <= 2'b01;
                    count<=0;
                end
            end
            wash:   begin
                if(count<count_m)   begin
                    count <= count + 1'b1;
                end
                else    begin
                    state <= drain;
                    drain_valve <= 1'b1;
                    motor <= 2'b00;
                end
            end
            drain:  begin
                if(water_empty)    begin
                    state <= rinse;
                    drain_valve <= 1'b0;
                    water_valve <= 1'b1;
                    count <= 4'b0;
                end
            end
            rinse:  begin
                if(water_full&&count==0)    begin
                    count <= count + 1'b1;
                    water_valve <= 1'b0;
                end
                else if((count < count_m) && count != 0)    begin
                    count <= count + 1'b1;
                end
                else if(count == count_m-1)    begin
                    state <= spin;
                    motor <= 2'b11;
                    count <= 0;
                end
            end
            spin:   begin
                if(count<count_mo)  begin
                    count <= count + 1'b1;
                end
                else    begin
                    state <= end_c;
                    motor <= 2'b00;
                    end_cycle <= 1'b1;
                end 
            end
            end_c:  begin
                end_cycle <= 1'b0;
                state <= idle;
                count <= 0;
            end
            default:    begin
                water_valve <= 1'b0;
                drain_valve <= 1'b0;
                motor <= 2'b0;
                end_cycle <= 1'b0;
                state <= idle;
            end
            endcase
        end
    end
endmodule