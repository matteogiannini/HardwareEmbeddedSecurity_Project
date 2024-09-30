module tb_SA();

    // Testbench Signals
    reg clock;
    reg reset_;
    reg [63:0] msg_block;
    reg soc;    // Start of Calculation signal
    wire eoc;   // End of Calculation signal
    wire [7:0] output_block [0:7];  // Updated to match module output (array of 8 bytes)

    // Instantiate the SA module
    SA uut (
        .clock(clock),
        .reset_(reset_),
        .msg_block(msg_block),
        .soc(soc),
        .eoc(eoc),
        .output_block(output_block)
    );

    // Clock generation
    always begin
        #5 clock = ~clock; // 10 time unit period (100MHz clock)
    end

    // Testbench procedure
    initial begin
        // Initialize inputs
        clock = 0;
        reset_ = 0;
        msg_block = 64'h0000000000000000;
        soc = 0;
        
        // Reset the design
        #10 reset_ = 1;
        
        // Test vector 1
        msg_block = 64'h1122334455667788; // Message block to be XORed with IV
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after 1 cycle
        
        wait (eoc == 1);  // Wait for EOC before checking the output

        // Check result of the first test vector
        if (output_block[0] == 8'h25 && output_block[1] == 8'h77 &&
            output_block[2] == 8'h3C && output_block[3] == 8'h50 &&
            output_block[4] == 8'h99 && output_block[5] == 8'hCC &&
            output_block[6] == 8'h87 && output_block[7] == 8'h6B) 
        begin
            $display("Test vector 1 passed: Output = %h %h %h %h %h %h %h %h",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end else begin
            $display("Test vector 1 failed: Output = %h %h %h %h %h %h %h %h, Expected = 25 77 3C 50 99 CC 87 6B",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end

        // Test vector 2
        msg_block = 64'hAABBCCDDEEFF0011; // Another message block
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after 1 cycle
        
        wait (eoc == 1);  // Wait for EOC before checking the output

        // Check result of the second test vector
        if (output_block[0] == 8'h9E && output_block[1] == 8'hEE &&
            output_block[2] == 8'hC3 && output_block[3] == 8'hC9 &&
            output_block[4] == 8'h22 && output_block[5] == 8'h55 &&
            output_block[6] == 8'hF0 && output_block[7] == 8'hF2)
        begin
            $display("Test vector 2 passed: Output = %h %h %h %h %h %h %h %h",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end else begin
            $display("Test vector 2 failed: Output = %h %h %h %h %h %h %h %h, Expected = 9E EE C3 C9 22 55 F0 F2",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end

        // Test vector 3
        msg_block = 64'h123456789ABCDEF0; // Another message block
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after 1 cycle
        
        wait (eoc == 1);  // Wait for EOC before checking the output

        // Check result of the third test vector
        if (output_block[0] == 8'h26 && output_block[1] == 8'h61 &&
            output_block[2] == 8'h59 && output_block[3] == 8'h6C &&
            output_block[4] == 8'h56 && output_block[5] == 8'h16 &&
            output_block[6] == 8'h2E && output_block[7] == 8'h13)
        begin
            $display("Test vector 3 passed: Output = %h %h %h %h %h %h %h %h",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end else begin
            $display("Test vector 3 failed: Output = %h %h %h %h %h %h %h %h, Expected = 26 61 59 6C 56 16 2E 13",
                     output_block[0], output_block[1], output_block[2], output_block[3],
                     output_block[4], output_block[5], output_block[6], output_block[7]);
        end

        // End simulation
        $stop;
    end

endmodule
