module tb_hash_round;

    reg [63:0] msg_block;
    wire [7:0] output_block [0:7];
    wire [63:0] linear_out;

    // Instantiate the hash_round module
    hash_round uut (
        .msg_block(msg_block),
        .output_block(output_block),
        .linear_out(linear_out)
    );

    // Declare internal wires to capture intermediate outputs
    wire [7:0] SA_out [0:7];
    wire [7:0] theta_out [0:7];
    wire [7:0] rho_out [0:7];
    wire [63:0] aux_conv_out;

    // Instantiate internal modules for debugging
    SA SA_inst (
        .msg_block(msg_block),
        .output_block(SA_out)
    );

    theta theta_inst (
        .msg_arr(SA_out),
        .output_arr(theta_out)
    );

    rho rho_inst (
        .msg_arr(theta_out),
        .output_arr(rho_out)
    );

    aux_conv aux_conv_inst (
        .msg_arr(rho_out),
        .linear_arr(aux_conv_out)
    );

    // Expected Intermediate Outputs
    reg [7:0] expected_SA [0:7];
    reg [7:0] expected_theta [0:7];
    reg [7:0] expected_rho [0:7];
    reg [63:0] expected_linear_out;

    initial begin
        // Test Case 1: All zeros
        msg_block = 64'h0000000000000000;
        #10;

        // Set expected values for Test Case 1
        expected_SA = {8'h34, 8'h55, 8'h0F, 8'h14, 8'hCC, 8'hAA, 8'hF0, 8'hE3};
        expected_theta = {8'hE3, 8'hF0, 8'hAA, 8'hCC, 8'h14, 8'h0F, 8'h55, 8'h34};
        expected_rho = {8'h6B, 8'h78, 8'h32, 8'h54, 8'h99, 8'h94, 8'hDA, 8'hB9};
        expected_linear_out = 64'h6B7832549994DAB9;

        #10;

        $display("Test Case 1: All zeros:");
        $display("msg_block = %h", msg_block);
        $display("SA output = %p (Expected: %p)", SA_out, expected_SA);
        $display("Theta output = %p (Expected: %p)", theta_out, expected_theta);
        $display("Rho output = %p (Expected: %p)", rho_out, expected_rho);
        $display("Aux Conv output = %h (Expected: %h)", aux_conv_out, expected_linear_out);

        // Check results for Test Case 1
        if (SA_out !== expected_SA) $display("Test Case 1 FAILED: SA output mismatch.");
        else if (theta_out !== expected_theta) $display("Test Case 1 FAILED: Theta output mismatch.");
        else if (rho_out !== expected_rho) $display("Test Case 1 FAILED: Rho output mismatch.");
        else if (aux_conv_out !== expected_linear_out) $display("Test Case 1 FAILED: Aux Conv output mismatch.");
        else $display("Test Case 1 PASSED!");

        // Test Case 2: Random values
        msg_block = 64'hFFABCD1234567890;
        #10;

        // Set expected values for Test Case 2
        expected_SA = {8'hCB, 8'hFE, 8'hC2, 8'h06, 8'hF8, 8'hFC, 8'h88, 8'h73};
        expected_theta = {8'h73, 8'h88, 8'hFC, 8'hF8, 8'h06, 8'hC2, 8'hFE, 8'hCB};
        expected_rho = {8'hF8, 8'h10, 8'h84, 8'h80, 8'h8B, 8'h4A, 8'h86, 8'h53};
        expected_linear_out = 64'hF81084808B4A8653;

        #10;

        $display("Test Case 2: Random values:");
        $display("msg_block = %h", msg_block);
        $display("SA output = %p (Expected: %p)", SA_out, expected_SA);
        $display("Theta output = %p (Expected: %p)", theta_out, expected_theta);
        $display("Rho output = %p (Expected: %p)", rho_out, expected_rho);
        $display("Aux Conv output = %h (Expected: %h)", aux_conv_out, expected_linear_out);

        // Check results for Test Case 2
        if (SA_out !== expected_SA) $display("Test Case 2 FAILED: SA output mismatch.");
        else if (theta_out !== expected_theta) $display("Test Case 2 FAILED: Theta output mismatch.");
        else if (rho_out !== expected_rho) $display("Test Case 2 FAILED: Rho output mismatch.");
        else if (aux_conv_out !== expected_linear_out) $display("Test Case 2 FAILED: Aux Conv output mismatch.");
        else $display("Test Case 2 PASSED!");

        // Test Case 3: New random message
        msg_block = 64'h1234567890ABCDEF;
        #10;

        // Set expected values for Test Case 3
        expected_SA = {8'h26, 8'h61, 8'h59, 8'h6C, 8'h5C, 8'h01, 8'h3D, 8'h0C};
        expected_theta = {8'h0C, 8'h3D, 8'h01, 8'h5C, 8'h6C, 8'h59, 8'h61, 8'h26};
        expected_rho = {8'h91, 8'hC2, 8'h86, 8'hE1, 8'hF1, 8'hDE, 8'hE6, 8'hAB};
        expected_linear_out = 64'h91C286E1F1DEE6AB;

        #10;

        $display("Test Case 3: New random message:");
        $display("msg_block = %h", msg_block);
        $display("SA output = %p (Expected: %p)", SA_out, expected_SA);
        $display("Theta output = %p (Expected: %p)", theta_out, expected_theta);
        $display("Rho output = %p (Expected: %p)", rho_out, expected_rho);
        $display("Aux Conv output = %h (Expected: %h)", aux_conv_out, expected_linear_out);

        // Check results for Test Case 3
        if (SA_out !== expected_SA) $display("Test Case 3 FAILED: SA output mismatch.");
        else if (theta_out !== expected_theta) $display("Test Case 3 FAILED: Theta output mismatch.");
        else if (rho_out !== expected_rho) $display("Test Case 3 FAILED: Rho output mismatch.");
        else if (aux_conv_out !== expected_linear_out) $display("Test Case 3 FAILED: Aux Conv output mismatch.");
        else $display("Test Case 3 PASSED!");

        $stop;
    end

endmodule
