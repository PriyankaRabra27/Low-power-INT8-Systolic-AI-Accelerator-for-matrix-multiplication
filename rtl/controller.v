`timescale 1ns / 1ps

module controller(
    input wire clk,
    input wire rst,
    input wire start,

    output reg clear,
    output reg enable,
    output reg valid_in,
    output reg done
);

    parameter IDLE  = 2'b00;
    parameter CLEAR = 2'b01;
    parameter RUN   = 2'b10;
    parameter DONE  = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    reg [3:0] cycle_count;

    // Sequential block: state and counter update
    always @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
            cycle_count   <= 0;
        end
        else begin
            current_state <= next_state;

            if (current_state == CLEAR) begin
                cycle_count <= 0;
            end
            else if (current_state == RUN) begin
                cycle_count <= cycle_count + 1;
            end
            else begin
                cycle_count <= 0;
            end
        end
    end

    // Combinational block: next state and outputs
    always @(*) begin
        // default values
        next_state = current_state;
        clear      = 0;
        enable     = 0;
        valid_in   = 0;
        done       = 0;
        case (current_state)
            IDLE: begin
                clear    = 0;
                enable   = 0;
                valid_in = 0;
                done     = 0;
                if (start)
                    next_state = CLEAR;
                else
                    next_state = IDLE;
            end
            CLEAR: begin
                clear      = 1;
                enable     = 0;
                valid_in   = 0;
                done       = 0;
                next_state = RUN;
            end
            RUN: begin
                clear  = 0;
                enable = 1;
                done   = 0;
                if (cycle_count <= 4'd6)
                    valid_in = 1;
                else
                    valid_in = 0;
                if (cycle_count == 4'd9)
                    next_state = DONE;
                else
                    next_state = RUN;
            end
            DONE: begin
                clear      = 0;
                enable     = 0;
                valid_in   = 0;
                done       = 1;
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
                clear      = 0;
                enable     = 0;
                valid_in   = 0;
                done       = 0;
            end
        endcase
    end

endmodule