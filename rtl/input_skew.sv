`timescale 1ns / 1ps
module input_skew (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic signed [7:0] a0_in, a1_in, a2_in, a3_in,
    input logic signed [7:0] b0_in, b1_in, b2_in, b3_in,
    output logic signed [7:0] a0_out, a1_out, a2_out, a3_out,
    output logic signed [7:0] b0_out, b1_out, b2_out, b3_out
);

    skew_delay #(.DELAY(0)) skew_a0 (.clk(clk), .rst(rst), .enable(enable), .in_val(a0_in), .out_val(a0_out));
    skew_delay #(.DELAY(1)) skew_a1 (.clk(clk), .rst(rst), .enable(enable), .in_val(a1_in), .out_val(a1_out));
    skew_delay #(.DELAY(2)) skew_a2 (.clk(clk), .rst(rst), .enable(enable), .in_val(a2_in), .out_val(a2_out));
    skew_delay #(.DELAY(3)) skew_a3 (.clk(clk), .rst(rst), .enable(enable), .in_val(a3_in), .out_val(a3_out));
    
    skew_delay #(.DELAY(0)) skew_b0 (.clk(clk), .rst(rst), .enable(enable), .in_val(b0_in), .out_val(b0_out));
    skew_delay #(.DELAY(1)) skew_b1 (.clk(clk), .rst(rst), .enable(enable), .in_val(b1_in), .out_val(b1_out));
    skew_delay #(.DELAY(2)) skew_b2 (.clk(clk), .rst(rst), .enable(enable), .in_val(b2_in), .out_val(b2_out));
    skew_delay #(.DELAY(3)) skew_b3 (.clk(clk), .rst(rst), .enable(enable), .in_val(b3_in), .out_val(b3_out));
    

endmodule