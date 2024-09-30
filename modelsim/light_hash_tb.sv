module tb_light_hash;

    // Testbench signals
    reg          clk;
    reg          rst_n;
    reg  [7:0]   msg_byte;        // 1-byte message input
    reg          byte_valid;      // Byte is valid and stable
    reg          msg_start;       // Indicates the message is still being provided
    wire         eoc;             // End of conversion signal (output digest ready)
    wire [7:0]   ctxt [0:7];      // Processed output as an array of 8 1-byte elements

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
    always #5 clk = ~clk;  // Generate a 100 MHz clock

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        msg_byte = 8'h00;
        byte_valid = 0;
        msg_start = 0;

        // Reset the design
        #10;
        rst_n = 1;
        #10;

        // Test Case 1: Send 8 bytes with msg_start high
        $display("Test Case 1: Sending 8-byte message");
        
        // Send 8 bytes sequentially
        msg_start = 1; 
        #10
        byte_valid = 1;
        msg_byte = 8'hA1; #10;
        msg_byte = 8'hB2; #10;
        msg_byte = 8'hC3; #10;
        msg_byte = 8'hD4; #10;
        msg_byte = 8'hE5; #10;
        msg_byte = 8'hF6; #10;
        msg_byte = 8'h07; #10;
        msg_byte = 8'h88; #10;

        // Complete the message
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // Wait for processing
        wait(eoc == 1);
        $display("Output ctxt = {%h, %h, %h, %h, %h, %h, %h, %h}", 
                 ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        // Test Case 2: Send a 6-byte message and stop
        $display("Test Case 2: Sending 6-byte message");
        
        // Send 6 bytes sequentially
        msg_start = 1;
        #10
        byte_valid = 1;
        msg_byte = 8'h11; #10;
        msg_byte = 8'h22; #10;
        msg_byte = 8'h33; #10;
        msg_byte = 8'h44; #10;
        msg_byte = 8'h55; #10;
        msg_byte = 8'h66; #10;

        // Complete the message
        msg_start = 0;
        byte_valid = 0;
        
        wait(eoc == 0);
        // Wait for processing
        wait(eoc == 1);
        $display("Output ctxt = {%h, %h, %h, %h, %h, %h, %h, %h}", 
                 ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        // Test Case 3: Send a 3-byte message
        $display("Test Case 3: Sending 3-byte message");
        
        // Send 3 bytes sequentially
        msg_start = 1; 
        #10
        byte_valid = 1;
        msg_byte = 8'h12; #10;
        msg_byte = 8'h34; #10;
        msg_byte = 8'h56; #10;

        // Complete the message
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // Wait for processing
        wait(eoc == 1);
        $display("Output ctxt = {%h, %h, %h, %h, %h, %h, %h, %h}", 
                 ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        // End the simulation
        $stop;
    end

endmodule
