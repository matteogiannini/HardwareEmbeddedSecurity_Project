`timescale 1ns/1ps

module tb_light_hash;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in nanoseconds

    // Signals for the DUT
    reg clk;
    reg rst_n;
    reg [7:0] msg_byte;
    reg byte_valid;
    reg msg_start;
    wire eoc;
    wire [7:0] ctxt [0:7]; // Output from light_hash

    // Instantiate the light_hash module
    light_hash uut (
        .clk(clk),
        .rst_n(rst_n),
        .msg_byte(msg_byte),
        .byte_valid(byte_valid),
        .msg_start(msg_start),
        .eoc(eoc),
        .ctxt(ctxt)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;
        msg_byte = 8'd0;
        byte_valid = 1'b0;
        msg_start = 1'b0;

        // Apply reset
        #20 rst_n = 1'b1; // Release reset
        #10;

        // Test Case 1: Provide one complete block of 8 bytes
        msg_start = 1'b1; // Start providing message
        byte_valid = 1'b1;
        
        // Provide 8 valid bytes
        msg_byte = 8'h01; #CLK_PERIOD;
        msg_byte = 8'h02; #CLK_PERIOD;
        msg_byte = 8'h03; #CLK_PERIOD;
        msg_byte = 8'h04; #CLK_PERIOD;
        msg_byte = 8'h05; #CLK_PERIOD;
        msg_byte = 8'h06; #CLK_PERIOD;
        msg_byte = 8'h07; #CLK_PERIOD;
        msg_byte = 8'h08; #CLK_PERIOD;

        // End message
        msg_start = 1'b0; 
        #CLK_PERIOD;

        // Wait for EOC to go high
        wait(eoc);
        #10; // Wait for a moment

        // Check the output digest
        $display("Output ctxt after first block:");
        for (int i = 0; i < 8; i++) begin
            $display("ctxt[%0d] = %h", i, ctxt[i]);
        end

        // Test Case 2: Provide a second incomplete block of 3 bytes
        msg_start = 1'b1; // Start providing message
        byte_valid = 1'b1;

        msg_byte = 8'hA1; #CLK_PERIOD;
        msg_byte = 8'hA2; #CLK_PERIOD;
        msg_byte = 8'hA3; #CLK_PERIOD;

        // End message
        msg_start = 1'b0; 
        #CLK_PERIOD;

        // Wait for EOC to go high
        wait(eoc);
        #10; // Wait for a moment

        // Check the output digest
        $display("Output ctxt after second block:");
        for (int i = 0; i < 8; i++) begin
            $display("ctxt[%0d] = %h", i, ctxt[i]);
        end

        // Finish simulation
        #50;
        $stop;
    end

endmodule
