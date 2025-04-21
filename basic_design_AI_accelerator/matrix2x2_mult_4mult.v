`timescale 1ns / 1ps


module matrix2x2_mult (
    input       clk,
    input       rst,
    input       start,

    input [7:0]  a00, a01,
    input [7:0]  a10, a11,
    input [7:0]  b00, b01,
    input [7:0]  b10, b11,

    output reg [16:0] c0, c1,
    output reg [16:0] c2, c3,
    output reg done
);
//4 multipliers only
wire [15:0] mult0, mult1, mult2, mult3;
reg [7:0] a[0:3];
reg [7:0] b[0:3];
reg [1:0] count;
reg mstart;
assign mult0 = a[0] * b[0];
assign mult1 = a[1] * b[1];
assign mult2 = a[2] * b[2];
assign mult3 = a[3] * b[3];

always@(posedge clk, posedge rst)
begin
    if(rst) begin
        c0 <= 0;
        c1 <= 0;
        c2 <= 0;
        c3 <= 0;
    end
    else    begin
        if(count==2'd0 && mstart)    begin
            c0 <= mult0 + mult1;
            c1 <= mult2 + mult3;
        end
        else if(count==2'd1 && mstart)    begin
            c2 <= mult0 + mult1;
            c3 <= mult2 + mult3;
        end
    end
end
//start multiplication - inputs fetched
always@(posedge clk, posedge rst)
begin
    if(rst)    begin
        mstart <= 0;
        done <= 1'b0;
    end
    else    begin
        if(start)   begin
            mstart <= 1'b1;
            done <= 1'b0;
        end
        else if(count==2'd2)    begin
            mstart <= 1'b0;
            done <= 1'b1;
        end
    end
end
integer i;
always@(*)
begin
    case(count)
        2'b00:  begin
            a[0] = a00;
            b[0] = b00;
            a[1] = a01;
            b[1] = b10;
            a[2] = a00;
            b[2] = b01;
            a[3] = a01;
            b[3] = b11;
        end
        2'b01:  begin
            a[0] = a10;
            b[0] = b00;
            a[1] = a11;
            b[1] = b10;
            a[2] = a10;
            b[2] = b01;
            a[3] = a11;
            b[3] = b11;
        end
        default:    begin
            for(i=0;i<4;i=i+1)   begin
                a[i] = 0;
                b[i] = 0;
            end  
        end
    endcase
end

//using only 4 multipliers but no pipeline
always@(posedge clk, posedge rst)
begin
    if(rst) begin
        count <= 0;
    end
    else    begin
        if(mstart)  begin
            count <= (count==2'd2)?0 : (count+1'b1);
        end
    end
end

endmodule
