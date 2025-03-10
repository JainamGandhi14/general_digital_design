`timescale 1ns / 1ps


//res = (a*b) + acc_in
module pipelined_mac(input clk, input rst, 
        input [7:0] a,b,input [15:0] acc_in,
        output reg [16:0] res //to accomodate the complete sum, as A*B will be 16 bits, and adding 16-bit no. + 16 bit no. 
                             //requires 17 bit to store the complete result 
    );
    
    reg [7:0] a_reg,b_reg;
    reg [15:0] mult; //storing the product
    reg [15:0] acc_in_reg[0:1];
    //capture
    //a
    always@(posedge clk, negedge rst)
    begin
        if(rst) begin
            a_reg <= 0;
        end
        else    begin
            a_reg <= a;
        end
    end
    //b
    always@(posedge clk, negedge rst)
    begin
        if(rst) begin
            b_reg <= 0;
        end
        else    begin
            b_reg <= b;
        end
    end
    //acc_in_reg
    always@(posedge clk, negedge rst)
    begin
        if(rst) begin
            acc_in_reg[0] <= 0;
            acc_in_reg[1] <= 0;
        end
        else    begin
            acc_in_reg[0] <= acc_in;
            acc_in_reg[1] <= acc_in_reg[0];
        end
    end
    //multiply
    always@(posedge clk, negedge rst)
    begin
        if(rst) begin
            mult <= 0;
        end
        else    begin
            mult <= a_reg * b_reg;
        end
    end    
    //add the mac and generate the output
    always@(posedge clk, negedge rst)
    begin
        if(rst) begin
            res <= 0;
        end
        else    begin
            res <= mult + acc_in_reg[1];
        end
    end    
endmodule
