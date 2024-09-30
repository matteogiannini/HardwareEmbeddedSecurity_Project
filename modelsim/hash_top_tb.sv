`timescale 1ns / 1ps

module hash_top_tb;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [63:0] msg_block;
    reg soc;
    wire eoc;
    wire [7:0] ctxt [0:7];

    // Instantiate the hash_processor module
    hash_processor uut (
        .clk(clk),
        .rst_n(rst_n),
        .msg_block(msg_block),
        .soc(soc),
        .eoc(eoc),
        .ctxt(ctxt)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test vectors
    initial begin
        // Initialize signals
        $display("Starting simulation");
        rst_n = 0;
        soc = 0;
        msg_block = 64'h0;

        // Apply reset
        #10 rst_n = 1;
        // Test case 1
        #10 msg_block = 64'h0123456789ABCDEF;
        soc = 1;
        #10 soc = 0;

        #10

        // Wait for end of conversion
        wait (eoc == 1);
        #10; // Additional delay to ensure outputs are stable
        $display("Test case 1 output: %h %h %h %h %h %h %h %h", ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        // Test case 2
        #10 msg_block = 64'hFEDCBA9876543210;
        soc = 1;
        #10 soc = 0;

        #10;

        // Wait for end of conversion
        wait (eoc == 1);
        #10; // Additional delay to ensure outputs are stable
        $display("Test case 2 output: %h %h %h %h %h %h %h %h", ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);


        // Finish simulation
        #10 $stop;
    end

endmodule
