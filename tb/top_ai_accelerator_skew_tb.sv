`timescale 1ns/1ps

module top_ai_accelerator_skew_tb;

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

    integer pass_count=0;
    integer fail_count=0;

    task check(input string test_name, input integer expected, input integer actual);
        begin
            if(expected==actual) begin
                pass_count=pass_count+1;
                $display("[PASS] %-0s (value=%0d)",test_name,actual);
            end
            else begin
                fail_count=fail_count+1;
                $display("[FAIL] %-0s expected=%0d actual=%0d",test_name,expected,actual);
            end
        end
    endtask

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

    always #5 clk=~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;
        #12;
        rst = 0;

        #10;
        start = 1;
        #10;
        start = 0;

        #10;  // this is the "warmup" gap cycle - inputs still 0 here

        a0_in = 1; a1_in = 5; a2_in = 9; a3_in = 13;
        b0_in = 1; b1_in = 0; b2_in = 0; b3_in = 0;
        #10;  // k=0 fed

        a0_in = 2; a1_in = 6; a2_in = 10; a3_in = 14;
        b0_in = 0; b1_in = 1; b2_in = 0; b3_in = 0;
        #10;  // k=1 fed    

        a0_in = 3; a1_in = 7; a2_in = 11; a3_in = 15;
        b0_in = 0; b1_in = 0; b2_in = 1; b3_in = 0;
        #10;  // k=2 fed

        a0_in = 4; a1_in = 8; a2_in = 12; a3_in = 16;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 1;
        #10;  // k=3 fed 

        a0_in = 0; a1_in = 0; a2_in = 0; a3_in = 0;
        b0_in = 0; b1_in = 0; b2_in = 0; b3_in = 0;

        wait (done == 1);

        check("c00", 1,  c00_out);
        check("c01", 2,  c01_out);
        check("c02", 3,  c02_out);
        check("c03", 4,  c03_out);
        check("c10", 5,  c10_out);
        check("c11", 6,  c11_out);
        check("c12", 7,  c12_out);
        check("c13", 8,  c13_out);
        check("c20", 9,  c20_out);
        check("c21", 10, c21_out);
        check("c22", 11, c22_out);
        check("c23", 12, c23_out);
        check("c30", 13, c30_out);
        check("c31", 14, c31_out);
        check("c32", 15, c32_out);
        check("c33", 16, c33_out);

        $display("--------------------------------------------------");
        $display("TOTAL: %0d PASSED, %0d FAILED", pass_count, fail_count);
        if (fail_count == 0)
            $display("RESULT: ALL TESTS PASSED - skew fix verified!");
        else
            $display("RESULT: SOME TESTS FAILED");
        $display("--------------------------------------------------");

        $finish;      
    end
endmodule
