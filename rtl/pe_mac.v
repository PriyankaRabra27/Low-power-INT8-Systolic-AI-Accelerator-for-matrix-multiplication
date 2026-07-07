`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 13:06:29
// Design Name: 
// Module Name: pe_mac
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


module pe_mac(
input wire clk,
input wire rst,
input wire enable,
input wire clear,
input wire valid_in, // To reject dummy values
output reg valid_out,
input wire signed [7:0]a_in,
input wire signed [7:0]b_in,
output reg signed [7:0]a_out,
output reg signed [7:0]b_out,
output reg signed [31:0]acc_out
    );
    
    wire signed [15:0]product;
      
    wire active_mac;
    assign active_mac=enable && valid_in && (a_in!=0) && (b_in!=0);
    
    // Low power feature(operand isolation)
    wire signed [7:0]a_eff;
    wire signed [7:0]b_eff;
        
    assign a_eff= active_mac ? a_in : 8'sd0;
    assign b_eff= active_mac ? b_in : 8'sd0; 
    
    assign product = a_eff*b_eff;
      
    always@(posedge clk) begin
        if(rst) begin
            a_out<=0;
            b_out<=0;
            acc_out<=0;
            valid_out<=0;
            end
        else if(clear) begin
            a_out<=0;
            b_out<=0;
            acc_out<=0;
            valid_out<=0;
            end   
        else if(enable) begin
            a_out<=a_in;
            b_out<=b_in;
            valid_out<=valid_in;
            if(active_mac)  //Low power feature(zero skipping)
                acc_out<=acc_out + product;
            end        
        end
                 
endmodule
