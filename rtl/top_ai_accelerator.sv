`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top_ai_accelerator (SystemVerilog version)
// Behavior identical to original top_ai_accelerator.v
//////////////////////////////////////////////////////////////////////////////////

module top_ai_accelerator (
    input  logic clk,
    input  logic rst,
    input  logic start,

    input  logic signed [7:0] a0_in,
    input  logic signed [7:0] a1_in,
    input  logic signed [7:0] a2_in,
    input  logic signed [7:0] a3_in,
    input  logic signed [7:0] b0_in,
    input  logic signed [7:0] b1_in,
    input  logic signed [7:0] b2_in,
    input  logic signed [7:0] b3_in,

    output logic signed [31:0] c00_out,
    output logic signed [31:0] c01_out,
    output logic signed [31:0] c02_out,
    output logic signed [31:0] c03_out,
    output logic signed [31:0] c10_out,
    output logic signed [31:0] c11_out,
    output logic signed [31:0] c12_out,
    output logic signed [31:0] c13_out,
    output logic signed [31:0] c20_out,
    output logic signed [31:0] c21_out,
    output logic signed [31:0] c22_out,
    output logic signed [31:0] c23_out,
    output logic signed [31:0] c30_out,
    output logic signed [31:0] c31_out,
    output logic signed [31:0] c32_out,
    output logic signed [31:0] c33_out,

    output logic done
);

    logic clear;
    logic valid_in;
    logic enable;

    controller ctrl_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .clear(clear),
        .enable(enable),
        .valid_in(valid_in),
        .done(done)
    );

    systolic_array4x4 array_inst (
        .clk(clk),
        .enable(enable),
        .clear(clear),
        .rst(rst),
        .valid_in(valid_in),

        .a0_in(a0_in),
        .a1_in(a1_in),
        .a2_in(a2_in),
        .a3_in(a3_in),

        .b0_in(b0_in),
        .b1_in(b1_in),
        .b2_in(b2_in),
        .b3_in(b3_in),

        .c00_out(c00_out),
        .c01_out(c01_out),
        .c02_out(c02_out),
        .c03_out(c03_out),

        .c10_out(c10_out),
        .c11_out(c11_out),
        .c12_out(c12_out),
        .c13_out(c13_out),

        .c20_out(c20_out),
        .c21_out(c21_out),
        .c22_out(c22_out),
        .c23_out(c23_out),

        .c30_out(c30_out),
        .c31_out(c31_out),
        .c32_out(c32_out),
        .c33_out(c33_out)
    );

endmodule
