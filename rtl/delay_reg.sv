`timescale 1ns / 1ps

module delay_reg(
    input logic clk,
    input logic rst,
    input logic enable,
    input logic signed [7:0] in_val,
    output logic signed [7:0] out_val
);

always_ff@(posedge clk) begin
    if(rst) begin
        out_val<=0;
    end
    else if(enable) begin
        out_val<= in_val;
    end
end





endmodule