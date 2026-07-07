`timescale 1ns / 1ps
module pe_mac_tb;
    logic             clk;
    logic             rst;
    logic             enable;
    logic             clear;
    logic             valid_in;
    logic signed [7:0]  a_in;
    logic signed [7:0]  b_in;
    logic               valid_out;
    logic signed [7:0]  a_out;
    logic signed [7:0]  b_out;
    logic signed [31:0] acc_out;

    // ---- pass/fail bookkeeping ----
    integer pass_count = 0;
    integer fail_count = 0;

    task check(input string test_name, input integer expected, input integer actual);
        begin
            if (expected == actual) begin
                pass_count = pass_count + 1;
                $display("[PASS] %-0s  (acc_out=%0d)", test_name, actual);
            end
            else begin
                fail_count = fail_count + 1;
                $display("[FAIL] %-0s  expected=%0d  actual=%0d", test_name, expected, actual);
            end
        end
    endtask

    pe_mac uut (
        .clk      (clk),
        .rst      (rst),
        .clear    (clear),
        .enable   (enable),
        .valid_in (valid_in),
        .valid_out(valid_out),
        .a_in     (a_in),
        .b_in     (b_in),
        .a_out    (a_out),
        .b_out    (b_out),
        .acc_out  (acc_out)
    );

    always #5 clk = ~clk;

    initial begin
        rst      = 1;
        enable   = 0;
        clear    = 0;
        valid_in = 0;
        a_in     = 0;
        b_in     = 0;
        clk      = 0;
        #12;
        rst = 0;

        // ---- Phase 1: positive accumulation ----
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
        b_in = 8'sd9;   // product = 0, zero-skip check
        #10;
        a_in = 8'sd7;
        b_in = 8'sd0;   // product = 0, zero-skip check
        #10;
        check("Phase1_positive_accum_zero_skip", 32, acc_out);

        clear    = 1;
        valid_in = 0;
        a_in     = 0;
        b_in     = 0;

        // ---- Phase 2: negative accumulation (sign bit + upper bits go to 1) ----
        #10;
        clear    = 0;
        enable   = 1;
        valid_in = 1;
        a_in     = -8'sd2;
        b_in     = 8'sd3;
        #10;
        a_in = 8'sd4;
        b_in = -8'sd5;
        #10;
        valid_in = 0;
        a_in     = 0;
        b_in     = 0;
        #10;
        check("Phase2_negative_accum", -26, acc_out);

        // ---- Phase 3: full magnitude extremes (-128, 127) ----
        #10;
        clear    = 1;
        valid_in = 0;
        a_in     = 0;
        b_in     = 0;
        #10;
        clear    = 0;
        enable   = 1;
        valid_in = 1;
        a_in     = -8'sd128;
        b_in     = 8'sd1;
        #10;
        a_in = 8'sd127;
        b_in = 8'sd1;
        #10;
        valid_in = 0;
        a_in     = 0;
        b_in     = 0;
        #10;
        check("Phase3_magnitude_extremes", -1, acc_out);

        // ---- Phase 4: clear again -> forces 1->0 toggle on upper/sign-extension bits ----
        #10;
        clear = 1;
        #10;
        check("Phase4_post_clear", 0, acc_out);
        clear = 0;
        #10;
        check("Phase4_final_hold", 0, acc_out);

        // ---- summary ----
        #10;
        $display("--------------------------------------------------");
        $display("TOTAL: %0d PASSED, %0d FAILED", pass_count, fail_count);
        if (fail_count == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: SOME TESTS FAILED");
        $display("--------------------------------------------------");

        $finish;
    end

endmodule
