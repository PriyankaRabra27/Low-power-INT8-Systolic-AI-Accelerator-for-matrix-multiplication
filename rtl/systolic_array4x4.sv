`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: systolic_array4x4 (SystemVerilog version)
// Behavior/wiring identical to original systolic_array4x4.v
//////////////////////////////////////////////////////////////////////////////////

module systolic_array4x4 (
    input  logic clk,
    input  logic rst,
    input  logic clear,
    input  logic enable,

    input  logic valid_in,

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
    output logic signed [31:0] c33_out
);

    // A moves left to right
    logic signed [7:0] a00_to_01, a10_to_11, a20_to_21, a30_to_31;
    logic signed [7:0] a01_to_02, a11_to_12, a21_to_22, a31_to_32;
    logic signed [7:0] a02_to_03, a12_to_13, a22_to_23, a32_to_33;

    // B moves top to bottom
    logic signed [7:0] b00_to_10, b10_to_20, b20_to_30;
    logic signed [7:0] b01_to_11, b11_to_21, b21_to_31;
    logic signed [7:0] b02_to_12, b12_to_22, b22_to_32;
    logic signed [7:0] b03_to_13, b13_to_23;

    // valid signals between PEs
    logic valid00_out, valid01_out, valid02_out, valid03_out;
    logic valid10_out, valid11_out, valid12_out, valid13_out;
    logic valid20_out, valid21_out, valid22_out, valid23_out;
    logic valid30_out, valid31_out, valid32_out, valid33_out;

    pe_mac PE00 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid_in),
        .a_in(a0_in), .b_in(b0_in),
        .a_out(a00_to_01), .b_out(b00_to_10),
        .valid_out(valid00_out),
        .acc_out(c00_out)
    );

    pe_mac PE01 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid00_out),
        .a_in(a00_to_01), .b_in(b1_in),
        .a_out(a01_to_02), .b_out(b01_to_11),
        .valid_out(valid01_out),
        .acc_out(c01_out)
    );

    pe_mac PE02 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid01_out),
        .a_in(a01_to_02), .b_in(b2_in),
        .a_out(a02_to_03), .b_out(b02_to_12),
        .valid_out(valid02_out),
        .acc_out(c02_out)
    );

    pe_mac PE03 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid02_out),
        .a_in(a02_to_03), .b_in(b3_in),
        .a_out(), .b_out(b03_to_13),
        .valid_out(valid03_out),
        .acc_out(c03_out)
    );

    pe_mac PE10 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid00_out),
        .a_in(a1_in), .b_in(b00_to_10),
        .a_out(a10_to_11), .b_out(b10_to_20),
        .valid_out(valid10_out),
        .acc_out(c10_out)
    );

    pe_mac PE11 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid10_out),
        .a_in(a10_to_11), .b_in(b01_to_11),
        .a_out(a11_to_12), .b_out(b11_to_21),
        .valid_out(valid11_out),
        .acc_out(c11_out)
    );

    pe_mac PE12 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid11_out),
        .a_in(a11_to_12), .b_in(b02_to_12),
        .a_out(a12_to_13), .b_out(b12_to_22),
        .valid_out(valid12_out),
        .acc_out(c12_out)
    );

    pe_mac PE13 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid12_out),
        .a_in(a12_to_13), .b_in(b03_to_13),
        .a_out(), .b_out(b13_to_23),
        .valid_out(valid13_out),
        .acc_out(c13_out)
    );

    pe_mac PE20 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid10_out),
        .a_in(a2_in), .b_in(b10_to_20),
        .a_out(a20_to_21), .b_out(b20_to_30),
        .valid_out(valid20_out),
        .acc_out(c20_out)
    );

    pe_mac PE21 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid20_out),
        .a_in(a20_to_21), .b_in(b11_to_21),
        .a_out(a21_to_22), .b_out(b21_to_31),
        .valid_out(valid21_out),
        .acc_out(c21_out)
    );

    pe_mac PE22 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid21_out),
        .a_in(a21_to_22), .b_in(b12_to_22),
        .a_out(a22_to_23), .b_out(b22_to_32),
        .valid_out(valid22_out),
        .acc_out(c22_out)
    );

    pe_mac PE23 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid22_out),
        .a_in(a22_to_23), .b_in(b13_to_23),
        .a_out(), .b_out(b23_to_33),
        .valid_out(valid23_out),
        .acc_out(c23_out)
    );

    pe_mac PE30 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid20_out),
        .a_in(a3_in), .b_in(b20_to_30),
        .a_out(a30_to_31), .b_out(),
        .valid_out(valid30_out),
        .acc_out(c30_out)
    );

    pe_mac PE31 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid30_out),
        .a_in(a30_to_31), .b_in(b21_to_31),
        .a_out(a31_to_32), .b_out(),
        .valid_out(valid31_out),
        .acc_out(c31_out)
    );

    pe_mac PE32 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid31_out),
        .a_in(a31_to_32), .b_in(b22_to_32),
        .a_out(a32_to_33), .b_out(),
        .valid_out(valid32_out),
        .acc_out(c32_out)
    );

    pe_mac PE33 (
        .clk(clk), .rst(rst), .enable(enable), .clear(clear),
        .valid_in(valid32_out),
        .a_in(a32_to_33), .b_in(b23_to_33),
        .a_out(), .b_out(),
        .valid_out(valid33_out),
        .acc_out(c33_out)
    );

endmodule
