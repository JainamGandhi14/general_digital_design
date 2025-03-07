`timescale 1ns / 1ps

module product #(parameter length = 8)(
    input clk,
    input rst,
    input [length-1:0] a,
    input [length-1:0] b,
    output reg [((2*length)-1):0] op
    );
    
   reg [length-1:0] a_reg,b_reg;
   reg [((2*length)-2):0] pp[length-1:0];
   reg [((2*length)-1):0] op_reg;
   //stage 1 - capture the inputs
   always@(posedge clk,posedge rst)
   begin
        if(rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end
        else    begin
            a_reg <= a;
            b_reg <= b;
        end
   end
   

   generate
   genvar i;
   //stage 2- generate partial products
        for(i=0;i<length;i=i+1)   begin: PARTIAL_PRODUCTS
            always@(posedge clk, posedge rst)
            begin
                if(rst) begin
                    pp[i] <= 0;
                end
                else    begin
                    pp[i] <= (b_reg & {length{a_reg[i]}})<<i;
                end
            end
        end
   endgenerate
   
   //stage 3 - collecting the sum
   always@(posedge clk, posedge rst)
   begin
        if(rst) begin
            op_reg <= 0;            
        end
        else    begin
        // add all the required PPs here to confirm the correct multiplication, here as because of 8 bit length,
        // there are 8 PPs to be added
            op_reg <= pp[0] + pp[1] + pp[2] + pp[3] + pp[4] + pp[5] + pp[6] + pp[7];
        end
   end
   //stage 4 - registering the output
   always@(posedge clk, posedge rst)
   begin
        if(rst) begin
            op <= 0;            
        end
        else    begin
            op <= op_reg;
        end
   end
   
endmodule
