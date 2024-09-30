module tb_theta();

    // Testbench Signals
    reg clock;
    reg reset_;
    reg [7:0] msg_arr [0:7];
    reg soc;
    wire eoc;
    wire [7:0] output_arr [0:7];

    // Instantiate the theta module
    theta uut (
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
        msg_arr[0] = 8'h00;
        msg_arr[1] = 8'h01;
        msg_arr[2] = 8'h02;
        msg_arr[3] = 8'h03;
        msg_arr[4] = 8'h04;
        msg_arr[5] = 8'h05;
        msg_arr[6] = 8'h06;
        msg_arr[7] = 8'h07;
        
        // Reset the design
        #10 reset_ = 1;
        
        // Test vector 1
        soc = 1;  // Start calculation
        #20 soc = 0;  // Stop calculation after 1 cycle
        
        wait (eoc == 1);  // Wait for EOC before checking the output

        // Check result of the first test vector
        if (output_arr[0] == 8'h07 && output_arr[1] == 8'h06 && output_arr[2] == 8'h05 && output_arr[3] == 8'h04 &&
            output_arr[4] == 8'h03 && output_arr[5] == 8'h02 && output_arr[6] == 8'h01 && output_arr[7] == 8'h00) begin
            $display("Test vector 1 passed: Output = %p", output_arr);
        end else begin
            $display("Test vector 1 failed: Output = %p", output_arr);
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
        #20 soc = 0;  // Stop calculation after 1 cycle
        
        wait (eoc == 1);  // Wait for EOC before checking the output

        // Check result of the second test vector
        if (output_arr[0] == 8'h88 && output_arr[1] == 8'h99 && output_arr[2] == 8'hAA && output_arr[3] == 8'hBB &&
            output_arr[4] == 8'hCC && output_arr[5] == 8'hDD && output_arr[6] == 8'hEE && output_arr[7] == 8'hFF) begin
            $display("Test vector 2 passed: Output = %p", output_arr);
        end else begin
            $display("Test vector 2 failed: Output = %p", output_arr);
        end

        // End simulation
        $stop;
    end

endmodule
