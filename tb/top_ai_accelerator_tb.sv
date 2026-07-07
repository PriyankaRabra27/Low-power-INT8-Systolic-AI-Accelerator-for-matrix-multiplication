`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2026 13:34:39
// Design Name: 
// Module Name: tb_top_ai_accelerator
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


module tb_top_ai_accelerator;

reg clk;
reg rst;
reg start;

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

wire done;

top_ai_accelerator uut(
    .clk(clk),
    .rst(rst),
    .start(start),

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
    .c33_out(c33_out),

    .done(done)
);

initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
    rst   = 1;
    start = 0;

    a0_in = 0;
    a1_in = 0;
    a2_in = 0;
    a3_in = 0;

    b0_in = 0;
    b1_in = 0;
    b2_in = 0;
    b3_in = 0;

    // release reset away from clock edge
    #12;
    rst = 0;

    // start pulse
    #10;
    start = 1;

    #10;
    start = 0;
    #10
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

    // Stop external inputs
    #10;
    a0_in = 0;
    a1_in = 0;
    a2_in = 0;
    a3_in = 0;

    b0_in = 0;
    b1_in = 0;
    b2_in = 0;
    b3_in = 0;

    // Wait until controller says done
    wait(done == 1);

    $display("DONE received at time %0t", $time);

    $display("C00=%0d C01=%0d C02=%0d C03=%0d", c00_out, c01_out, c02_out, c03_out);
    $display("C10=%0d C11=%0d C12=%0d C13=%0d", c10_out, c11_out, c12_out, c13_out);
    $display("C20=%0d C21=%0d C22=%0d C23=%0d", c20_out, c21_out, c22_out, c23_out);
    $display("C30=%0d C31=%0d C32=%0d C33=%0d", c30_out, c31_out, c32_out, c33_out);

    
    //TEST PHASE 2: Toggle coverage stimulus
    //Covers sign bit.full magnitude range,
    //negitive x positive, accumulator upper bit toggling
    #20;
    start=1;
    #10;
    start=0;
    #10;
    // Cycle 1
    a0_in = -8'sd128;
    a1_in = 8'sd0;
    a2_in = 8'sd0;
    a3_in = 8'sd0;
    b0_in = 8'sd1;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;
    // Cycle 2
    #10;
    a0_in = 8'sd127;
    a1_in = -8'sd100;
    a2_in = 8'sd0;
    a3_in = 8'sd0;
     b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;
    // Cycle 3
    #10;
    a0_in = -8'sd64;
    a1_in = 8'sd64;
    a2_in = -8'sd1;
    a3_in = 8'sd0;
    b0_in = 8'sd0;
    b1_in = 8'sd1;
    b2_in = 8'sd0;
    b3_in = 8'sd0;
    // Cycle 4
    #10;
    a0_in = 8'sd100;
    a1_in = -8'sd127;
    a2_in = -8'sd1;
    a3_in = 8'sd50;
    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;
    // Cycle 5
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd90;
    a2_in = -8'sd1;
    a3_in = 8'sd50;
    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd1;
    b3_in = 8'sd0;
    // Cycle 6
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd0;
    a2_in = -8'sd1;
    a3_in = 8'sd50;
    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd0;
    // Cycle 7
    #10;
    a0_in = 8'sd0;
    a1_in = 8'sd0;
    a2_in = 8'sd0;
    a3_in = 8'sd50;
    b0_in = 8'sd0;
    b1_in = 8'sd0;
    b2_in = 8'sd0;
    b3_in = 8'sd1;

    // Stop external inputs
    #10;
    a0_in = 0;
    a1_in = 0;
    a2_in = 0;
    a3_in = 0;
    b0_in = 0;
    b1_in = 0;
    b2_in = 0;
    b3_in = 0;

    // Wait until controller says done for test 2
    wait(done == 1);
    $display("=== TEST PHASE 2 (toggle coverage stimulus) ===");
    $display("DONE received at time %0t", $time);
    $display("C00=%0d C01=%0d C02=%0d C03=%0d", c00_out, c01_out, c02_out, c03_out);
    $display("C10=%0d C11=%0d C12=%0d C13=%0d", c10_out, c11_out, c12_out, c13_out);
    $display("C20=%0d C21=%0d C22=%0d C23=%0d", c20_out, c21_out, c22_out, c23_out);
    $display("C30=%0d C31=%0d C32=%0d C33=%0d", c30_out, c31_out, c32_out, c33_out);
    
    
    // TEST PHASE 3: Strong toggle coverage stimulus
#20;

// reset before next test
rst = 1;
start = 0;

a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;

#20;
rst = 0;

// start pulse
#10;
start = 1;
#10;
start = 0;

// Cycle 1: max positive and max negative
#10;
a0_in = 8'sd127;
a1_in = -8'sd128;
a2_in = 8'sd85;
a3_in = -8'sd64;

b0_in = -8'sd128;
b1_in = 8'sd127;
b2_in = -8'sd85;
b3_in = 8'sd64;

// Cycle 2: change all bits strongly
#10;
a0_in = -8'sd1;
a1_in = 8'sd1;
a2_in = -8'sd32;
a3_in = 8'sd32;

b0_in = 8'sd1;
b1_in = -8'sd1;
b2_in = 8'sd32;
b3_in = -8'sd32;

// Cycle 3: alternating bit-like values
#10;
a0_in = 8'sd85;      // 01010101
a1_in = -8'sd86;     // toggles many bits
a2_in = 8'sd51;      // 00110011
a3_in = -8'sd52;

b0_in = -8'sd86;
b1_in = 8'sd85;
b2_in = -8'sd52;
b3_in = 8'sd51;

// Cycle 4: sparse/zero case for operand isolation
#10;
a0_in = 8'sd0;
a1_in = -8'sd128;
a2_in = 8'sd0;
a3_in = 8'sd127;

b0_in = 8'sd127;
b1_in = 8'sd0;
b2_in = -8'sd128;
b3_in = 8'sd0;

// Cycle 5: opposite signs
#10;
a0_in = -8'sd100;
a1_in = 8'sd100;
a2_in = -8'sd50;
a3_in = 8'sd50;

b0_in = 8'sd100;
b1_in = -8'sd100;
b2_in = 8'sd50;
b3_in = -8'sd50;

// Cycle 6: all negative
#10;
a0_in = -8'sd10;
a1_in = -8'sd20;
a2_in = -8'sd30;
a3_in = -8'sd40;

b0_in = -8'sd40;
b1_in = -8'sd30;
b2_in = -8'sd20;
b3_in = -8'sd10;

// Cycle 7: all positive different magnitude
#10;
a0_in = 8'sd11;
a1_in = 8'sd22;
a2_in = 8'sd33;
a3_in = 8'sd44;

b0_in = 8'sd55;
b1_in = 8'sd66;
b2_in = 8'sd77;
b3_in = 8'sd88;

// Stop inputs
#10;
a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;

wait(done == 1);

$display("=== TEST PHASE 3: Strong toggle coverage stimulus ===");
$display("DONE received at time %0t", $time);

// TEST PHASE: Dense random stimulus for systolic array toggle coverage
#20;

// Reset before new test
rst = 1;
start = 0;

a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;

#20;
rst = 0;

// Wait for done to be low before new start
#10;
wait(done == 0);

// Start pulse
start = 1;
#10;
start = 0;

// Dense non-zero values for many cycles
#10;
a0_in = 8'sd127;   a1_in = -8'sd128;  a2_in = 8'sd85;    a3_in = -8'sd64;
b0_in = -8'sd32;   b1_in = 8'sd64;     b2_in = -8'sd100;  b3_in = 8'sd127;

#10;
a0_in = -8'sd1;    a1_in = 8'sd100;    a2_in = -8'sd50;   a3_in = 8'sd25;
b0_in = 8'sd90;    b1_in = -8'sd75;    b2_in = 8'sd45;    b3_in = -8'sd20;

#10;
a0_in = 8'sd55;    a1_in = -8'sd66;    a2_in = 8'sd77;    a3_in = -8'sd88;
b0_in = -8'sd99;   b1_in = 8'sd111;    b2_in = -8'sd120;  b3_in = 8'sd33;

#10;
a0_in = -8'sd100;  a1_in = 8'sd90;     a2_in = -8'sd80;   a3_in = 8'sd70;
b0_in = 8'sd60;    b1_in = -8'sd50;    b2_in = 8'sd40;    b3_in = -8'sd30;

#10;
a0_in = 8'sd12;    a1_in = 8'sd34;     a2_in = -8'sd56;   a3_in = -8'sd78;
b0_in = -8'sd87;   b1_in = 8'sd65;     b2_in = -8'sd43;   b3_in = 8'sd21;

#10;
a0_in = -8'sd128;  a1_in = 8'sd127;    a2_in = -8'sd1;    a3_in = 8'sd1;
b0_in = 8'sd127;   b1_in = -8'sd128;   b2_in = 8'sd1;     b3_in = -8'sd1;

#10;
a0_in = 8'sd85;    a1_in = -8'sd86;    a2_in = 8'sd51;    a3_in = -8'sd52;
b0_in = -8'sd86;   b1_in = 8'sd85;     b2_in = -8'sd52;   b3_in = 8'sd51;

// Flush
#10;
a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;

wait(done == 1);

$display("Dense toggle test done at time %0t", $time);

    #20;
    $finish;
    
end


endmodule
