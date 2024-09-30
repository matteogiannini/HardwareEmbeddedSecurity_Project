module tb_FPX;

    // Testbench Signals
    reg clock;
    reg reset_;
    reg [7:0] msg_arr [0:7];
    reg soc;    // Start of Calculation signal
    wire eoc;   // End of Calculation signal
    wire [7:0] output_arr [0:7];

    // Instantiate the FPX module
    FPX uut (
        .clock(clock),
        .reset_(reset_),
        .msg_arr(msg_arr),
        .soc(soc),
        .eoc(eoc),
        .output_arr(output_arr)
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
        soc = 0;
        
        // Reset the design
        #10 reset_ = 1;
        #10 reset_ = 0;
        #10 reset_ = 1;

        // Test vector 1
        msg_arr[0] = 8'h11;
        msg_arr[1] = 8'h22;
        msg_arr[2] = 8'h33;
        msg_arr[3] = 8'h44;
        msg_arr[4] = 8'h55;
        msg_arr[5] = 8'h66;
        msg_arr[6] = 8'h77;
        msg_arr[7] = 8'h88;
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after sufficient time
        
        // Wait for EOC before checking the output
        wait (eoc == 1);

        // Check result of the first test vector
        if (output_arr[0] == 8'hbc && output_arr[1] == 8'h22 &&
            output_arr[2] == 8'h69 && output_arr[3] == 8'h41 &&
            output_arr[4] == 8'h88 && output_arr[5] == 8'h99 &&
            output_arr[6] == 8'hd2 && output_arr[7] == 8'hf2) begin
            $display("Test vector 1 passed: Output = %h %h %h %h %h %h %h %h",
                     output_arr[0], output_arr[1], output_arr[2], output_arr[3],
                     output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        end else begin
            $display("Test vector 1 failed: Output = %h %h %h %h %h %h %h %h",
                     output_arr[0], output_arr[1], output_arr[2], output_arr[3],
                     output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        end

        // Test vector 2
        msg_arr[0] = 8'hFF;
        msg_arr[1] = 8'hEE;
        msg_arr[2] = 8'hDD;
        msg_arr[3] = 8'hCC;
        msg_arr[4] = 8'hBB;
        msg_arr[5] = 8'hAA;
        msg_arr[6] = 8'h99;
        msg_arr[7] = 8'h88;
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after sufficient time
        
        // Wait for EOC before checking the output
        wait (eoc == 1);

        // Check result of the second test vector
        if (output_arr[0] == 8'hbc && output_arr[1] == 8'hcc &&
            output_arr[2] == 8'ha5 && output_arr[3] == 8'haf &&
            output_arr[4] == 8'h00 && output_arr[5] == 8'h77 &&
            output_arr[6] == 8'h1e && output_arr[7] == 8'h1c) begin
            $display("Test vector 2 passed: Output = %h %h %h %h %h %h %h %h",
                     output_arr[0], output_arr[1], output_arr[2], output_arr[3],
                     output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        end else begin
            $display("Test vector 2 failed: Output = %h %h %h %h %h %h %h %h",
                     output_arr[0], output_arr[1], output_arr[2], output_arr[3],
                     output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        end

        // End simulation
        $stop;
    end

endmodule
