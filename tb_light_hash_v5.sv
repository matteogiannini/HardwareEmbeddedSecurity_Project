module tb_light_hash_v5;

    // Testbench signals
    reg        clk;
    reg        rst_n;
    reg        start;
    reg        valid_in;
    reg  [63:0] m;
    wire [63:0] final_digest;
    wire       valid_out;

    // Instantiate the DUT (Device Under Test)
    light_hash_v5 dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .valid_in(valid_in),
        .m(m),
        .final_digest(final_digest),
        .valid_out(valid_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz clock
    end

    // Testbench procedure
    initial begin
        // Initialize inputs
        rst_n = 1'b0;
        start = 1'b0;
        valid_in = 1'b0;
        m = 64'h0000000000000000;

        // Apply reset
        #10;
        rst_n = 1'b1;

        // Test Case 1: Simple message
        #10;
	$display("Starting Test Case 1");
        @(posedge clk);
        start = 1'b1;
        valid_in = 1'b1;
        m = 64'h123456789ABCDEF0;  // Example message input

        @(posedge clk);
        start = 1'b0;
        valid_in = 1'b0;

        // Wait for the hash computation to complete
        wait(valid_out);
        #10;
        $display("Test Case 1: final_digest = %h", final_digest);

        // Test Case 2: Another simple message
        @(posedge clk);
        start = 1'b1;
        valid_in = 1'b1;
        m = 64'h0F1E2D3C4B5A6978;  // Example message input

        @(posedge clk);
        start = 1'b0;
        valid_in = 1'b0;

        // Wait for the hash computation to complete
        wait(valid_out);
        #10;
        $display("Test Case 2: final_digest = %h", final_digest);

        // Test Case 3: All zeroes message
        @(posedge clk);
        start = 1'b1;
        valid_in = 1'b1;
        m = 64'h0000000000000000;  // All zeroes message input

        @(posedge clk);
        start = 1'b0;
        valid_in = 1'b0;

        // Wait for the hash computation to complete
        wait(valid_out);
        #10;
        $display("Test Case 3: final_digest = %h", final_digest);

        // Add more test cases as needed

        // End of simulation
        #10;
        $stop;
    end

endmodule
