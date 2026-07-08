`timescale 1ns / 1ps
module top_ai_accelerator_compare_tb;

    logic clk;
    logic rst;
    logic start;

    logic signed [7:0] a0_in, a1_in, a2_in, a3_in;
    logic signed [7:0] b0_in, b1_in, b2_in, b3_in;

    logic signed [31:0] c00_out, c01_out, c02_out, c03_out;
    logic signed [31:0] c10_out, c11_out, c12_out, c13_out;
    logic signed [31:0] c20_out, c21_out, c22_out, c23_out;
    logic signed [31:0] c30_out, c31_out, c32_out, c33_out;
    logic done;

    integer stim_file, out_file;
    integer scan_ok;
    integer rst_v, start_v, a0_v, a1_v, a2_v, a3_v, b0_v, b1_v, b2_v, b3_v;

    top_ai_accelerator uut (
        .clk(clk), .rst(rst), .start(start),
        .a0_in(a0_in), .a1_in(a1_in), .a2_in(a2_in), .a3_in(a3_in),
        .b0_in(b0_in), .b1_in(b1_in), .b2_in(b2_in), .b3_in(b3_in),
        .c00_out(c00_out), .c01_out(c01_out), .c02_out(c02_out), .c03_out(c03_out),
        .c10_out(c10_out), .c11_out(c11_out), .c12_out(c12_out), .c13_out(c13_out),
        .c20_out(c20_out), .c21_out(c21_out), .c22_out(c22_out), .c23_out(c23_out),
        .c30_out(c30_out), .c31_out(c31_out), .c32_out(c32_out), .c33_out(c33_out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;

        stim_file = $fopen("stimulus_top.txt", "r");
        out_file  = $fopen("rtl_top_output.csv", "w");

        if (stim_file == 0) begin
            $display("ERROR: could not open stimulus_top.txt");
            $finish;
        end

        $fwrite(out_file, "c00,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33,done\n");

        #2;

        for (int line_num = 0; line_num < 32; line_num = line_num + 1) begin
            scan_ok = $fscanf(stim_file, "%d %d %d %d %d %d %d %d %d %d",
                               rst_v, start_v, a0_v, a1_v, a2_v, a3_v,
                               b0_v, b1_v, b2_v, b3_v);

            if (scan_ok == 10) begin
                rst = rst_v;
                start = start_v;
                a0_in = a0_v; a1_in = a1_v; a2_in = a2_v; a3_in = a3_v;
                b0_in = b0_v; b1_in = b1_v; b2_in = b2_v; b3_in = b3_v;

                @(posedge clk);
                #1;

                $fwrite(out_file, "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                        c00_out, c01_out, c02_out, c03_out,
                        c10_out, c11_out, c12_out, c13_out,
                        c20_out, c21_out, c22_out, c23_out,
                        c30_out, c31_out, c32_out, c33_out,
                        done);
            end
            else begin
                $display("WARNING: line %0d did not parse (scan_ok=%0d)", line_num, scan_ok);
            end
        end

        $fclose(stim_file);
        $fclose(out_file);
        $display("Done. Wrote rtl_top_output.csv");
        $finish;
    end

endmodule
