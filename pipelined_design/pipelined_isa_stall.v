`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 18:24:13
// Design Name: 
// Module Name: isa
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//design not so structured, will work on restructuring the design
//instruction = 16 bits = 7 bit of opcode + 3 + 3 + 3 bits of registers(9 bits for operand)
//execute memory write instruction will have 2 outputs, data and address, i.e., where to write the data in regbus for cpu
// implementing 2 instruction: Load R1, {R2] ; ADD R3, R1, R2;
module isa_stall(input clk, input rst, input [15:0] ins, output reg [8:0] exec_output_data, output reg [2:0] exec_output_adr, output reg load_ins );//pipelined isa with stalling feature

reg [15:0] if_reg;//instruction fetch
reg [6:0] id_op;//instruction decode: opcode
reg [8:0] id_oper_reg;//instruction decode: operands
reg [7:0] ie_reg1_val;//instruction execute: values
reg [7:0] ie_reg2_val;//instruction execute: values
reg [7:0] ie_reg3_val;//instruction execute: values



//locals
integer i;
reg [7:0] main_mem[0:7];//reg memory, just for an example to replicate the write from memory
reg rst_done;
reg rst_done_d;
reg [2:0] ex_dest, ex_op1, ex_op2;
reg [2:0] if_dest, if_op1, if_op2;
reg stall_done;
//if execute is using the next instruction register, then the data hazard(RAW) occurs. So, one solution is to stall the pipeline
wire stall = rst_done_d && ~stall_done &&
             (if_reg[8:6] == ex_dest||
             if_reg[5:3] == ex_dest  ||
            (id_op!=7'd1 ? if_reg[2:0] == ex_dest : 1'b0)); //making sure that when the instruction in the decode stage 
                                                            //is still using the register for the next instruction

//fetch - decode
always@(posedge clk, posedge rst)
begin
    if(rst) begin
            if_reg <= 16'h0;
            id_op <= 7'b0;
            id_oper_reg <= 9'b111111111;//this value as default to make sure that the 
                                       //stall is not happening indefinitely after the reset
            ie_reg1_val <= 8'b0;;
            ie_reg2_val <= 8'b0;
            ie_reg3_val <= 8'b0;
            ex_dest <= 3'b0;
            ex_op1 <= 3'b0;
            ex_op2 <= 3'b0;
            if_dest <= 3'b0;
            if_op1 <= 3'b0;
            if_op2 <= 3'b0;
            rst_done <=1'b0;
            rst_done_d <= 1'b0;
            stall_done <= 1'b0;
        end
    else if(!stall) begin
            //fetch
            if_reg <= ins;
            if_dest <= ins[8:6];
            if_op1 <= ins[2:0];
            if_op2 <= ins[5:3];
            $display("reg3_if= %3b reg2_if= %3b reg1_if= %3b",if_reg[8:6], if_reg[5:3], if_reg[2:0] );
            //decode
            id_op <= if_reg[15:9];
            ex_dest <= if_reg [8:6];
            ex_op1 <= if_reg[2:0];
            ex_op2 <= if_reg[5:3];
            id_oper_reg <= if_reg[8:0];
            ie_reg1_val <= main_mem[if_reg[2:0]];
            ie_reg2_val <= main_mem[if_reg[5:3]];
            ie_reg3_val <= main_mem[if_reg[8:6]];
            rst_done <= 1'b1;
            rst_done_d <= rst_done;
            stall_done <= 1'b0;
            $display("reg3= %3b reg2= %3b reg1= %3b", ex_dest, ex_op2, ex_op1 );
        end
    else if(stall)   begin
            if_reg <= if_reg;//stalling - no-op
            id_op <= 7'b0; //stalling -  no- operation
            stall_done <= 1'b1;
    end        
    else    begin
        stall_done <= 1'b0;
    end
        
end
//execute
always@(posedge clk, posedge rst)  
begin
    if(rst) begin
        exec_output_data <= 9'b0;
        exec_output_adr <= 3'b0;
        load_ins <= 1'b0;
    end
    else    begin
        case(id_op)
        7'b0000001: begin   //load
            exec_output_adr <= id_oper_reg[8:6];
            exec_output_data <= ie_reg2_val;
            load_ins <= 1'b1;
        end
        7'b0000010: begin   //add
            exec_output_data <= ie_reg1_val + ie_reg2_val;
            exec_output_adr <= id_oper_reg[8:6];
            load_ins <= 1'b0;
        end
        default:    begin
            exec_output_data <= 9'b0;
            exec_output_adr <= 3'b0;
            load_ins <= 1'b0;

        end
        endcase
    end
end
always@(posedge clk, posedge rst)
begin
    if(rst) begin
       for(i=0;i<8;i=i+1)   begin
            main_mem[i]=i;
        end    
    end
end
endmodule
    
