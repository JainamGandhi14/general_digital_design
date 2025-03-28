`timescale 1ns / 1ps
module interrupt_control_priority_encode #(parameter NINTR = 4)(
  input        clk,
  input        reset_n,
  input  [NINTR-1:0] req,
  input        done,
  output reg [NINTR-1:0] ack,
  output reg       irq
    );
  //NINTR is number of interrupts
  localparam bit_req = $clog2(NINTR);
  wire [bit_req-1:0] code;
wire valid;
  reg [NINTR-1:0] prev_req; //will be needed to process the previous requests when waiting if no high priority new request is asserted
reg [2:0] state; //using one-hot encoding
localparam IDLE = 3'b001,
           ACK = 3'b010,
           WAIT_DONE = 3'b100;
priority_encoder encode(.enable(1'b1),.req(prev_req),.code(code),.valid(valid));



//state machine and input manipulation
always@(posedge clk, negedge reset_n)
begin
    if(~reset_n)    begin
        state <= IDLE;
        prev_req <= 0;
    end
    else    begin
        case(state)
        IDLE:   begin
            if(req!=0) begin
                state <= ACK;
                prev_req <= req;
            end
        end
        ACK:    begin
                state <= WAIT_DONE;
                prev_req <= (prev_req & (~ack)) | req;//remove the last priority and mask
        end
        WAIT_DONE:  begin
            prev_req <= (prev_req & ~ack) | req;//remove the last priority and mask
            if(done)    begin
                state <= IDLE; //if done comes into picture, always take the new set of reqs, and ignore older set
            end
            else if(prev_req!=0)    begin
                state <= ACK;
            end
        end
        default:    begin
            state <= IDLE;
        end
        endcase
    end
end
//output mech
always@(posedge clk, negedge reset_n)
begin
    if(~reset_n)    begin
        ack <= 0;
        irq <= 0;
    end
    else    begin
        if(state == IDLE)   begin
            ack <= 1'b0;
            irq <= 1'b0;
        end
        else if(state == ACK && ((prev_req || req) !=0)) begin
            ack <= 1'b1<<code;
            irq <= valid;
        end
        else if(state==WAIT_DONE)   begin
            if(done)    begin
                ack <= 0;
                irq <= 0;
            end
        end
        else    begin
                ack <= 0;
                irq <= 0;
        end
    end
end

endmodule

module priority_encoder #(parameter NINTR = 4, bit_req = $clog2(NINTR))(
  input        enable,
  input  [NINTR-1:0] req,
  output reg [bit_req-1:0] code,
  output       valid
);

  reg [bit_req:0] i; //to maintain the priority - easy to scale
assign valid = (req != 0 ) && enable;

always@(*)
begin
    if(~enable) begin
        code = 0;
    end
    else    begin
        code = 0;
      for(i=0;i<NINTR;i=i+1)   begin : WILL_GEN_COMB
            code = req[i]? i[1:0] : code;
        end
    end
end

endmodule
