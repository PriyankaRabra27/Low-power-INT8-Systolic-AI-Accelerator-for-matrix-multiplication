`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2026 15:30:20
// Design Name: 
// Module Name: systolic_array2x2_tb
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


module systolic_array2x2_tb();
reg clk;
reg rst;
reg clear;
reg enable;
reg valid_in;
reg signed [7:0] a0_in; 
reg signed [7:0] b0_in; 
reg signed [7:0] a1_in; 
reg signed [7:0] b1_in; 

wire signed [31:0] c00_out; 
wire signed [31:0] c01_out;
wire signed [31:0] c10_out;
wire signed [31:0] c11_out;   

systolic_array2x2 uut(
    .clk(clk),
    .rst(rst),
    .clear(clear),
    .enable(enable),
    .valid_in(valid_in),
    .a0_in(a0_in),
    .a1_in(a1_in),
    .b0_in(b0_in),
    .b1_in(b1_in),
    .c00_out(c00_out),
    .c01_out(c01_out),
    .c10_out(c10_out),
    .c11_out(c11_out)
    );
    
    initial begin
    clk=0;
    end
    always #5 clk=~clk;
    initial begin
    rst=1;
    enable=0;
    clear=0;
    valid_in=0;
    a0_in=0;
    a1_in=0;
    b0_in=0;
    b1_in=0;
    
    #12
    rst=0;
    
    #10 
    clear=1;
    
    #10
    clear=0;
    enable=1;
    valid_in=1;
    //cycle 1
    a0_in=8'sd1;
    a1_in=8'sd0;
    b0_in=8'sd5;
    b1_in=8'sd0;
    
    //cycle 2
    #10
    a0_in=8'sd2;
    a1_in=8'sd3;
    b0_in=8'sd7;
    b1_in=8'sd6;
    
    //cycle 3
    #10
    a0_in=8'sd0;
    a1_in=8'sd4;
    b0_in=8'sd0;
    b1_in=8'sd8;
    
    //cycle 4
    #10
    a0_in=8'sd0;
    a1_in=8'sd0;
    b0_in=8'sd0;
    b1_in=8'sd0;
    valid_in=0;
    
    #30
    $display("C00 = %0d", c00_out);
    $display("C01 = %0d", c01_out);
    $display("C10 = %0d", c10_out);
    $display("C11 = %0d", c11_out);

    #10;
    $finish;
    end
    
    initial begin
    $monitor("T=%0t | a0=%0d a1=%0d b0=%0d b1=%0d | C00=%0d C01=%0d C10=%0d C11=%0d",
             $time, a0_in, a1_in, b0_in, b1_in,
             c00_out, c01_out, c10_out, c11_out);
end
    
    
    

endmodule
