`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2026 15:20:01
// Design Name: 
// Module Name: tb_controller
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


module tb_controller;

reg clk;
reg rst;
reg start;

wire clear;
wire enable;
wire valid_in;
wire done;

controller uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .enable(enable),
    .clear(clear),
    .valid_in(valid_in),
    .done(done)
    );
    
initial begin
    clk=0;
    end
always #5 clk=~clk;

initial begin
rst=1;
start=0;
#12
rst=0;
#10
start=1;

#10;
start=0;


#150
$finish;
end

initial begin
    $monitor("T=%0t | start=%b state=%b cycle=%0d | clear=%b enable=%b valid_in=%b done=%b",
              $time, start, uut.current_state, uut.cycle_count,
              clear, enable, valid_in, done);
end

endmodule
