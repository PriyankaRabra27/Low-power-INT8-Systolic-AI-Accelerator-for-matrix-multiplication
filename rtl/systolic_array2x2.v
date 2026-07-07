`timescale 1ns / 1ps

module systolic_array2x2(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire clear,

    input wire valid_in,

    input wire signed [7:0] a0_in,
    input wire signed [7:0] b0_in,
    input wire signed [7:0] a1_in,
    input wire signed [7:0] b1_in,

    output wire signed [31:0] c00_out,
    output wire signed [31:0] c01_out,
    output wire signed [31:0] c10_out,
    output wire signed [31:0] c11_out
);

    // A moves left to right
    wire signed [7:0] a00_to_01;
    wire signed [7:0] a10_to_11;

    // B moves top to bottom
    wire signed [7:0] b00_to_10;
    wire signed [7:0] b01_to_11;

    // Valid signals between PEs
    wire valid00_out;
    wire valid01_out;
    wire valid10_out;
    wire valid11_out;

    // PE00 computes C00
    pe_mac PE00(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .enable(enable),
        .valid_in(valid_in),

        .a_in(a0_in),
        .b_in(b0_in),

        .a_out(a00_to_01),
        .b_out(b00_to_10),
        .valid_out(valid00_out),

        .acc_out(c00_out)
    );

    // PE01 computes C01
    pe_mac PE01(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .enable(enable),
        .valid_in(valid00_out),

        .a_in(a00_to_01),
        .b_in(b1_in),

        .a_out(),
        .b_out(b01_to_11),
        .valid_out(valid01_out),

        .acc_out(c01_out)
    );

    // PE10 computes C10
    pe_mac PE10(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .enable(enable),
        .valid_in(valid00_out),

        .a_in(a1_in),
        .b_in(b00_to_10),

        .a_out(a10_to_11),
        .b_out(),
        .valid_out(valid10_out),

        .acc_out(c10_out)
    );

    // PE11 computes C11
    pe_mac PE11(
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .enable(enable),
        .valid_in(valid10_out),

        .a_in(a10_to_11),
        .b_in(b01_to_11),

        .a_out(),
        .b_out(),
        .valid_out(valid11_out),

        .acc_out(c11_out)
    );

endmodule