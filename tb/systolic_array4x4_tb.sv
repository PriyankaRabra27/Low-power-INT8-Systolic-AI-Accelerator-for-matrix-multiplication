`timescale 1ns / 1ps
module systolic_array4x4_tb();

    logic clk;
    logic rst;
    logic clear;
    logic enable;
    logic valid_in;
    logic signed [7:0] a0_in, a1_in, a2_in, a3_in;
    logic signed [7:0] b0_in, b1_in, b2_in, b3_in;

    logic signed [31:0] c00_out, c01_out, c02_out, c03_out;
    logic signed [31:0] c10_out, c11_out, c12_out, c13_out;
    logic signed [31:0] c20_out, c21_out, c22_out, c23_out;
    logic signed [31:0] c30_out, c31_out, c32_out, c33_out;

    integer i, j;

    // ---- pass/fail bookkeeping ----
    integer pass_count = 0;
    integer fail_count = 0;

    task check(input string test_name, input integer expected, input integer actual);
        begin
            if (expected == actual) begin
                pass_count = pass_count + 1;
                $display("[PASS] %-0s  (value=%0d)", test_name, actual);
            end
            else begin
                fail_count = fail_count + 1;
                $display("[FAIL] %-0s  expected=%0d  actual=%0d", test_name, expected, actual);
            end
        end
    endtask

    systolic_array4x4 uut (
        .clk(clk), .rst(rst), .clear(clear), .enable(enable),
        .valid_in(valid_in),
        .a0_in(a0_in), .a1_in(a1_in), .a2_in(a2_in), .a3_in(a3_in),
        .b0_in(b0_in), .b1_in(b1_in), .b2_in(b2_in), .b3_in(b3_in),
        .c00_out(c00_out), .c01_out(c01_out), .c02_out(c02_out), .c03_out(c03_out),
        .c10_out(c10_out), .c11_out(c11_out), .c12_out(c12_out), .c13_out(c13_out),
        .c20_out(c20_out), .c21_out(c21_out), .c22_out(c22_out), .c23_out(c23_out),
        .c30_out(c30_out), .c31_out(c31_out), .c32_out(c32_out), .c33_out(c33_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1; clear = 0; enable = 0; valid_in = 0;
        a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;
        #12;
        rst = 0;

        // ============================================================
        // TEST 1: clear behavior - all outputs must be 0 right after clear
        // ============================================================
        #10;
        clear = 1;
        #10;
        clear = 0;
        check("clear_c00", 0, c00_out);
        check("clear_c33", 0, c33_out);

        // ============================================================
        // TEST 2: wiring + drain-timing check
        // Feed constant per-row a values and per-col b values so the
        // skew issue doesn't corrupt this check (same value every
        // cycle -> no k-index mismatch possible). This isolates
        // whether the MAC/wiring/drain timing is correct.
        // ============================================================
        enable = 1;
        valid_in = 1;
        a0_in = 8'sd1; a1_in = 8'sd2; a2_in = 8'sd3; a3_in = 8'sd4;
        b0_in = 8'sd1; b1_in = 8'sd2; b2_in = 8'sd3; b3_in = 8'sd4;

        // hold valid_in high for NUM_VALID cycles
        for (i = 0; i < 9; i = i + 1) begin
            #10;
        end
        // NUM_VALID = 10 cycles fed total (this one + the 9 above)

        // now stop feeding valid data, but keep enable high so the
        // array can drain (worst-case corner needs i+j=6 extra cycles)
        valid_in = 0;
        a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;
        for (i = 0; i < 8; i = i + 1) begin
            #10;
        end

        // expected: each PE[i][j] accumulated (i+1)*(j+1) per valid
        // cycle, for 10 valid cycles -> (i+1)*(j+1)*10
        check("PE_0_0",  1*1*10, c00_out);
        check("PE_0_1",  1*2*10, c01_out);
        check("PE_0_2",  1*3*10, c02_out);
        check("PE_0_3",  1*4*10, c03_out);
        check("PE_1_0",  2*1*10, c10_out);
        check("PE_1_1",  2*2*10, c11_out);
        check("PE_1_2",  2*3*10, c12_out);
        check("PE_1_3",  2*4*10, c13_out);
        check("PE_2_0",  3*1*10, c20_out);
        check("PE_2_1",  3*2*10, c21_out);
        check("PE_2_2",  3*3*10, c22_out);
        check("PE_2_3",  3*4*10, c23_out);
        check("PE_3_0",  4*1*10, c30_out);
        check("PE_3_1",  4*2*10, c31_out);
        check("PE_3_2",  4*3*10, c32_out);
        check("PE_3_3",  4*4*10, c33_out);

        // ============================================================
        // TEST 3: zero-skip check at array level
        // ============================================================
        clear = 1;
        #10;
        clear = 0;
        enable = 1;
        valid_in = 1;
        a0_in = 8'sd0; a1_in = 8'sd5; a2_in = 8'sd5; a3_in = 8'sd5; // a0 is zero
        b0_in = 8'sd5; b1_in = 8'sd5; b2_in = 8'sd5; b3_in = 8'sd5;
        #10;
        valid_in = 0;
        a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;
        for (i = 0; i < 8; i = i + 1) #10;
        // PE[0][0] used a_in=0 on its one active cycle -> must stay 0
        check("zero_skip_c00", 0, c00_out);

        // ============================================================
        // Random stimulus for toggle/code coverage only
        // (no golden check here - correctness needs skewed inputs,
        //  see project log; this just exercises more RTL states)
        // ============================================================
        clear = 1;
        #10;
        clear = 0;
        enable = 1;
        valid_in = 1;
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
            enable   = (i % 17 != 0);
            valid_in = (i % 13 != 0);
            clear    = (i == 40 || i == 120 || i == 180);
            a0_in = $random; a1_in = $random; a2_in = $random; a3_in = $random;
            b0_in = $random; b1_in = $random; b2_in = $random; b3_in = $random;
        end

        clear = 0; enable = 1; valid_in = 0;
        repeat (10) begin
            @(negedge clk);
            a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
            b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;
        end

        @(negedge clk);
        rst = 1;
        repeat (3) @(negedge clk);
        rst = 0;
        repeat (5) @(negedge clk);

        // ---- summary ----
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