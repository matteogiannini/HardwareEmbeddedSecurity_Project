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
        // create an array of bytes to store the message from test vector files
        reg [7:0] msg_bytes [0:7];
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

        // Test Case 1
        $display("-------------- Test Case 1 --------------");
        
        msg_start = 1; 
        byte_valid = 1;

        // reading from test vector file 1
        $readmemh("../modelsim/tv/test1.hex", msg_bytes);;
        #10;
        // putting the bytes into the hash input byte
        for (int i = 0; i < 8; i++) begin
            msg_byte = msg_bytes[i];
            $display("Processing msg_byte = %h", msg_byte);
            #10;
        end

        // updating the message start and byte valid signals
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // waiting for the end of conversion signal to go high
        wait(eoc == 1);

        // printing output digest
        $display("Output Digest: %h %h %h %h %h %h %h %h", ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        #10;

        
        // Test Case 2
        $display("-------------- Test Case 2 --------------");

        // Send 8 bytes sequentially
        msg_start = 1;
        byte_valid = 1;

        // reading from test vector file 2
        $readmemh("../modelsim/tv/test2.hex", msg_bytes);
        #10;

        // putting the bytes into the hash input byte
        for (int i = 0; i < 8; i++) begin
            msg_byte = msg_bytes[i];
            $display("Processing msg_byte = %h", msg_byte);
            #10;
        end

        // Complete the message
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // waiting for the end of conversion signal to go high
        wait(eoc == 1);

        // printing output digest

        $display("Output Digest: %h %h %h %h %h %h %h %h", ctxt[0], ctxt[1], ctxt[2], ctxt[3],ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        #10;

        // Test Case 3
        $display("-------------- Test Case 3 --------------");

        // Send 8 bytes sequentially
        msg_start = 1;
        byte_valid = 1;

        // reading from test vector file 3
        $readmemh("../modelsim/tv/test3.hex", msg_bytes);
        #10;

        // printing the message bytes
        for (int i = 0; i < 8; i++) begin
            $display("msg_bytes[%0d] = %h", i, msg_bytes[i]);
        end

        // putting the bytes into the hash input byte
        for (int i = 0; i < 8; i++) begin
            msg_byte = msg_bytes[i];
            #10;
        end

        // Complete the message
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // waiting for the end of conversion signal to go high
        wait(eoc == 1);

        // printing output digest
        $display("Output Digest: %h %h %h %h %h %h %h %h", ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);


        #10;

        // Message of 4 bytes with msg_start high and byte_valid low between bytes
        $display("-------------- Test Case 4 --------------");

        // Send 4 bytes sequentially
        msg_start = 1;
        byte_valid = 1;
        msg_byte = 8'hA1; #10;
        byte_valid = 0;
        msg_byte = 8'hB2; #10;
        byte_valid = 1;
        #10
        byte_valid = 0;
        msg_byte = 8'hC3; #10;
        byte_valid = 1;
        #10
        byte_valid = 0;
        msg_byte = 8'hD4; #10;
        byte_valid = 1;
        #10


        // Complete the message
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // Wait for processing
        wait(eoc == 1);
        $display("Output ctxt = {%h, %h, %h, %h, %h, %h, %h, %h}", 
        ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        #10;
        
        // Test Case 5
        $display("-------------- Test Case 5 --------------");
        
        // Send 3 bytes message
        msg_start = 1; 
        byte_valid = 1;
        msg_byte = 8'h12; #10;
        msg_byte = 8'h34; #10;
        msg_byte = 8'h56; #10;

        // Signaling that the message is complete
        msg_start = 0;
        byte_valid = 0;

        wait(eoc == 0);

        // Wait for processing
        wait(eoc == 1);
        $display("Output ctxt = {%h, %h, %h, %h, %h, %h, %h, %h}", 
        ctxt[0], ctxt[1], ctxt[2], ctxt[3], ctxt[4], ctxt[5], ctxt[6], ctxt[7]);

        // Terminating the simulation
        $stop;
    end 

endmodule
