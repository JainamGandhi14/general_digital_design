`timescale 1ns / 1ps
module interrupt_control_priority_encode(
  input        clk,
  input        reset_n,
  input  [3:0] req,
  input        done,
  output reg [3:0] ack,
  output reg       irq
    );

wire [1:0] code;
wire valid;
reg [3:0] prev_req; //will be needed to process the previous requests when waiting if no high priority new request is asserted
reg [2:0] state; //using one-hot encoding
localparam IDLE = 3'b001,
           ACK = 3'b010,
           WAIT_DONE = 3'b100;
priority_encoder encode(.enable(1'b1),.req(prev_req),.code(code),.valid(valid));


//prev req -- because of using 1 extra reg to capture and manipulate input, some input req depending 
//on the current state,needs to stable for either 1 clock cycle or 2 clock cycle to be correctly captured

always@(posedge clk, negedge reset_n)
begin
    if(~reset_n)    begin
        prev_req <= 4'b0;
    end
    else    begin
        if(state==IDLE && req !=0)  begin
            prev_req <= prev_req | req;
        end
        else if(state==ACK)   begin
            prev_req[code] <= 1'b0;  //removing previously assigned priority 
        end
        else if(state==WAIT_DONE)   begin
            prev_req <= prev_req | req; // masking new req
        end
    end
end

//ack op && irq
always@(posedge clk, negedge reset_n)
begin
    if(~reset_n)    begin
        ack <= 4'b0;
    end
    else    begin
        if(state==IDLE)  begin
            ack <= 4'b0;
            irq <= 0;
        end
        else if(state==ACK)   begin
            ack <= 4'b0001 << code; 
            irq <= valid;
        end
        else if(state==WAIT_DONE)   begin
            ack<=4'b0;
            irq<=1'b0;
        end
    end
end

//state machine
always@(posedge clk, negedge reset_n)
begin
    if(~reset_n)    begin
        state <= IDLE;
    end
    else    begin
        case(state)
        IDLE:   begin
            if(prev_req != 0)    begin
                state <= ACK;
            end
            end
        ACK:    begin
                state <= WAIT_DONE;
            end
        WAIT_DONE:  begin
                if(done)    begin
                    state <= IDLE;//if done, go to idle state
                end
                else if(prev_req!=0)   begin
                  state <= ACK;//if req are pending and not rcvd done yet then go to ACk state to process next pending req
                end
            end
        default:    begin
                    state <= IDLE;
        end
        endcase
    end
end

endmodule

module priority_encoder (
  input        enable,
  input  [3:0] req,
  output reg [1:0] code,
  output       valid
);

reg [2:0] i; //to maintain the priority - easy to scale
assign valid = (req != 0 ) && enable;

always@(*)
begin
    if(~enable) begin
        code = 0;
    end
    else    begin
        code = 0;
        for(i=0;i<4;i=i+1)   begin : WILL_GEN_COMB
            code = req[i]? i[1:0] : code;
        end
    end
end

endmodule
