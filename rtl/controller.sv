`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: controller (SystemVerilog version)
// Behavior identical to original controller.v
// (states now a proper enum instead of parameter constants)
//////////////////////////////////////////////////////////////////////////////////

module controller (
    input  logic clk,
    input  logic rst,
    input  logic start,
    output logic clear,
    output logic enable,
    output logic valid_in,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        CLEAR = 2'b01,
        RUN   = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t current_state, next_state;
    logic [3:0] cycle_count;

    // Sequential block: state and counter update
    always_ff @(posedge clk) begin
        if (rst) begin
            current_state <= IDLE;
            cycle_count   <= '0;
        end
        else begin
            current_state <= next_state;
            if (current_state == CLEAR)
                cycle_count <= '0;
            else if (current_state == RUN)
                cycle_count <= cycle_count + 1'b1;
            else
                cycle_count <= '0;
        end
    end

    // Combinational block: next state and outputs
    always_comb begin
        // default values
        next_state = current_state;
        clear      = 1'b0;
        enable     = 1'b0;
        valid_in   = 1'b0;
        done       = 1'b0;

        case (current_state)
            IDLE: begin
                clear    = 1'b0;
                enable   = 1'b0;
                valid_in = 1'b0;
                done     = 1'b0;
                next_state = start ? CLEAR : IDLE;
            end

            CLEAR: begin
                clear      = 1'b1;
                enable     = 1'b0;
                valid_in   = 1'b0;
                done       = 1'b0;
                next_state = RUN;
            end

            RUN: begin
                clear    = 1'b0;
                enable   = 1'b1;
                done     = 1'b0;
                valid_in = (cycle_count <= 4'd6) ? 1'b1 : 1'b0;
                next_state = (cycle_count == 4'd9) ? DONE : RUN;
            end

            DONE: begin
                clear      = 1'b0;
                enable     = 1'b0;
                valid_in   = 1'b0;
                done       = 1'b1;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                clear      = 1'b0;
                enable     = 1'b0;
                valid_in   = 1'b0;
                done       = 1'b0;
            end
        endcase
    end

endmodule
