module tb_controller;

    logic clk;
    logic rst;
    logic start;
    logic clear;
    logic enable;
    logic valid_in;
    logic done;

    controller uut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .enable  (enable),
        .clear   (clear),
        .valid_in(valid_in),
        .done    (done)
    );

    initial begin
        clk = 0;
    end

    always #5 clk = ~clk;

    initial begin
        rst   = 1;
        start = 0;
        #12;
        rst = 0;
        #10;
        start = 1;
        #10;
        start = 0;
        #150;
        $finish;
    end

    initial begin
        $monitor("T=%0t | start=%b state=%b cycle=%0d | clear=%b enable=%b valid_in=%b done=%b",
                  $time, start, uut.current_state, uut.cycle_count,
                  clear, enable, valid_in, done);
    end

endmodule
