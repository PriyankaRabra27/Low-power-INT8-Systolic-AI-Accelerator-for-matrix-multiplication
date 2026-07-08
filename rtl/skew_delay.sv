`timescale 1ns / 1ps
module skew_delay #(
    parameter DELAY = 3
) (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic signed [7:0] in_val,
    output logic signed [7:0] out_val
);

    // 1. declare the stage array here (hint: needs DELAY+1 slots, indices 0 to DELAY)
    logic signed [7:0] stage[0:DELAY];
    // 2. connect stage[0] to the input
    assign stage[0]=in_val;

    // 3. the genvar/generate loop here
    genvar i;
    generate
        for(i=0;i<DELAY; i=i+1) begin 
            delay_reg u_stage(
                .clk(clk),
                .rst(rst),
                .enable(enable),
                .in_val(stage[i]),
                .out_val(stage[i+1])
            );
        end
    endgenerate



    // 4. connect the output to the last stage
    assign out_val=stage[DELAY];
    

endmodule