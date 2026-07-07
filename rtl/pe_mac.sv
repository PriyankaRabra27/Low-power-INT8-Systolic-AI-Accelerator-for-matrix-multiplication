`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: pe_mac (SystemVerilog version)
// Behavior identical to original pe_mac.v
//////////////////////////////////////////////////////////////////////////////////

module pe_mac (
    input  logic              clk,
    input  logic              rst,
    input  logic              enable,
    input  logic              clear,
    input  logic              valid_in,   // To reject dummy values
    output logic              valid_out,
    input  logic signed [7:0] a_in,
    input  logic signed [7:0] b_in,
    output logic signed [7:0] a_out,
    output logic signed [7:0] b_out,
    output logic signed [31:0] acc_out
);

    logic signed [15:0] product;
    logic active_mac;

    assign active_mac = enable && valid_in && (a_in != 0) && (b_in != 0);

    // Low power feature (operand isolation)
    logic signed [7:0] a_eff;
    logic signed [7:0] b_eff;

    assign a_eff = active_mac ? a_in : 8'sd0;
    assign b_eff = active_mac ? b_in : 8'sd0;

    assign product = a_eff * b_eff;

    always_ff @(posedge clk) begin
        if (rst) begin
            a_out     <= '0;
            b_out     <= '0;
            acc_out   <= '0;
            valid_out <= 1'b0;
        end
        else if (clear) begin
            a_out     <= '0;
            b_out     <= '0;
            acc_out   <= '0;
            valid_out <= 1'b0;
        end
        else if (enable) begin
            a_out     <= a_in;
            b_out     <= b_in;
            valid_out <= valid_in;
            if (active_mac)  // Low power feature (zero skipping)
                acc_out <= acc_out + product;
        end
    end

endmodule
