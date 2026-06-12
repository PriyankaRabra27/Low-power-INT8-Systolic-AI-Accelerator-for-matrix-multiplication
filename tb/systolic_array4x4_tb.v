`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2026 13:35:31
// Design Name: 
// Module Name: systolic_array4x4_tb
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


module systolic_array4x4_tb();

reg clk;
reg rst;
reg clear;
reg enable;
reg valid_in;

reg signed [7:0] a0_in;
reg signed [7:0] a1_in;
reg signed [7:0] a2_in;
reg signed [7:0] a3_in;

reg signed [7:0] b0_in;
reg signed [7:0] b1_in;
reg signed [7:0] b2_in;
reg signed [7:0] b3_in;

wire signed [31:0] c00_out;
wire signed [31:0] c01_out;
wire signed [31:0] c02_out;
wire signed [31:0] c03_out;

wire signed [31:0] c10_out;
wire signed [31:0] c11_out;
wire signed [31:0] c12_out;
wire signed [31:0] c13_out;

wire signed [31:0] c20_out;
wire signed [31:0] c21_out;
wire signed [31:0] c22_out;
wire signed [31:0] c23_out;

wire signed [31:0] c30_out;
wire signed [31:0] c31_out;
wire signed [31:0] c32_out;
wire signed [31:0] c33_out;

systolic_array4x4  uut(
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .enable(enable),
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

initial begin
    clk=0;
    end
    
always #5 clk=~clk;

initial begin
    rst      = 1;
    clear    = 0;
    enable   = 0;
    valid_in = 0;

    a0_in = 0;
    a1_in = 0;
    a2_in = 0;
    a3_in = 0;

    b0_in = 0;
    b1_in = 0;
    b2_in = 0;
    b3_in = 0;

    // Release reset away from clock edge
    #12;
    rst = 0;

    // Clear all accumulators
    #10;
    clear = 1;

    #10;
    clear    = 0;
    enable   = 1;
    valid_in = 1;

    // Cycle 1
    a0_in = 8'sd1;
    a1_in = 8'sd0;
    a2_in = 8'sd0;
    a3_in = 8'sd0;

    b0_in = 8'sd1;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;

    // Cycle 2
    #10;
    a0_in = 8'sd2;
    a1_in = 8'sd5;
    a2_in = 8'sd0;
    a3_in = 8'sd0;

    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;

    // Cycle 3
    #10;
    a0_in = 8'sd3;
    a1_in = 8'sd6;
    a2_in = 8'sd1;
    a3_in = 8'sd0;

    b0_in = 8'sd0;
    b1_in = 8'sd1;
    b2_in = 8'sd0;
    b3_in = 8'sd0;

    // Cycle 4
    #10;
    a0_in = 8'sd4;
    a1_in = 8'sd7;
    a2_in = 8'sd1;
    a3_in = 8'sd2;

    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;

    // Cycle 5
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd8;
    a2_in = 8'sd1;
    a3_in = 8'sd2;

    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd1;
    b3_in = 8'sd0;

    // Cycle 6
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd0;
    a2_in = 8'sd1;
    a3_in = 8'sd2;

    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;

    // Cycle 7
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd0;
    a2_in = 8'sd0;
    a3_in = 8'sd2;

    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd1;

    // Stop new inputs
    #10;
    valid_in = 0;
    a0_in = 0;
    a1_in = 0;
    a2_in = 0;
    a3_in = 0;
    b0_in = 0;
    b1_in = 0;
    b2_in = 0;
    b3_in = 0;

    // Wait for data to propagate through full array
    #80;

    $display("C00=%0d C01=%0d C02=%0d C03=%0d", c00_out, c01_out, c02_out, c03_out);
    $display("C10=%0d C11=%0d C12=%0d C13=%0d", c10_out, c11_out, c12_out, c13_out);
    $display("C20=%0d C21=%0d C22=%0d C23=%0d", c20_out, c21_out, c22_out, c23_out);
    $display("C30=%0d C31=%0d C32=%0d C33=%0d", c30_out, c31_out, c32_out, c33_out);

    #10;
    $finish;
end

endmodule
