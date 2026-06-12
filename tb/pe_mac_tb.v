`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 13:54:30
// Design Name: 
// Module Name: pe_mac_tb
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


module pe_mac_tb;

reg clk;
reg rst;
reg enable;
reg clear;
reg valid_in;

reg signed [7:0]a_in;
reg signed [7:0]b_in;

wire valid_out;
wire signed [7:0]a_out;
wire signed [7:0]b_out;
wire signed [31:0]acc_out;

pe_mac uut(
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .enable(enable),
    .valid_in(valid_in),
    .valid_out(valid_out),
    .a_in(a_in),
    .b_in(b_in),
    .a_out(a_out),
    .b_out(b_out),
    .acc_out(acc_out)
    );
    
    initial begin 
    rst      = 1;
    enable   = 0;
    clear    = 0;
    valid_in = 0;
    a_in     = 0;
    b_in     = 0;
    clk      = 0;

    // keep reset for 2 clock edges
    #12;
    rst = 0;

    // start MAC
    #10;
    enable   = 1;
    valid_in = 1;
    clear    = 0;
    a_in     = 8'sd2;
    b_in     = 8'sd3;

    #10;
    a_in = 8'sd4;
    b_in = 8'sd5;

    #10;
    a_in = 8'sd1;
    b_in = 8'sd6;
    
    #10;
    a_in = 8'sd0;
    b_in = 8'sd9;   // product = 0, acc_out should stay 32
    
    #10;
    a_in = 8'sd7;
    b_in = 8'sd0;
       // product = 0, acc_out should still stay 32
    #10;
    clear = 1;
    valid_in = 0;
    a_in = 0;
    b_in = 0;
    
    #10;
    clear = 0;
    enable=1;
    valid_in=1;
    a_in=-8'sd2;
    b_in=8'sd3;
    
    #10
    a_in=8'sd4;
    b_in=-8'sd5;
    
    #10;
    valid_in = 0;
    a_in     = 0;
    b_in     = 0;
    
    #10
    if(acc_out == -26)
    $display("TEST PASSED:acc_out=&0d",acc_out);
    else
    $display("TEST FAILED:acc_out=%0d",acc_out);
    
    #10;
    $display("FINAL acc_out = %0d", acc_out);

    #10;
    $finish;
end
    always #5 clk=~clk;
    
   
    initial begin
    $monitor("Time=%0t | clk=%b rst=%b enable=%b valid_in=%b | a_in=%0d b_in=%0d | acc_out=%0d valid_out=%b",
             $time, clk, rst, enable, valid_in, a_in, b_in, acc_out, valid_out);
end

endmodule
