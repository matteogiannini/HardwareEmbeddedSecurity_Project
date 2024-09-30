module tb_hash_processor;

    // Signals
    reg clk;
    reg rst_n;
    reg [63:0] msg_block;
    reg dav_;               // Active low signal
    wire rfd;               // Ready for data signal
    wire [7:0] ctxt [0:7];  // Processed output

    // Instantiate the hash_processor
    hash_processor uut (
        .clk(clk),
        .rst_n(rst_n),
        .msg_block(msg_block),
        .dav_(dav_),
        .rfd(rfd),
        .ctxt(ctxt)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz clock
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        rst_n = 0;
        dav_ = 1; // Data not valid (inactive)
        msg_block = 64'h0;

        // Apply reset
        #10 rst_n = 1;
        $display("Reset released");

        // Test 1: Provide a message block for processing
        @(posedge clk);
        dav_ = 0;             // Data valid (active low)
        msg_block = 64'h123456789ABCDEF0; // Example input block
        $display("Providing msg_block = %h", msg_block);

        // Wait until rfd is low (indicating processing has started)
        wait (rfd == 0);
        dav_ = 1; // Data not valid (inactive)
        $display("Processing started");

        // Wait for processing to complete (rfd goes high again)
        wait (rfd == 1);
        $display("Processing complete, checking results");

        // Display the result
        $display("ctxt[0] = %h", ctxt[0]);
        $display("ctxt[1] = %h", ctxt[1]);
        $display("ctxt[2] = %h", ctxt[2]);
        $display("ctxt[3] = %h", ctxt[3]);
        $display("ctxt[4] = %h", ctxt[4]);
        $display("ctxt[5] = %h", ctxt[5]);
        $display("ctxt[6] = %h", ctxt[6]);
        $display("ctxt[7] = %h", ctxt[7]);

        // Test 2: Provide another block
        @(posedge clk);
        dav_ = 0;
        msg_block = 64'hFEDCBA9876543210; // Another example input block
        $display("Providing another msg_block = %h", msg_block);

        // Wait until rfd is low (indicating processing has started)
        wait (rfd == 0);
        dav_ = 1; // Data not valid (inactive)
        $display("Processing started");

        // Wait for processing to complete
        wait (rfd == 1);
        $display("Processing complete for the second block");

        // Display the result
        $display("ctxt[0] = %h", ctxt[0]);
        $display("ctxt[1] = %h", ctxt[1]);
        $display("ctxt[2] = %h", ctxt[2]);
        $display("ctxt[3] = %h", ctxt[3]);
        $display("ctxt[4] = %h", ctxt[4]);
        $display("ctxt[5] = %h", ctxt[5]);
        $display("ctxt[6] = %h", ctxt[6]);
        $display("ctxt[7] = %h", ctxt[7]);

        // End simulation
        $finish;
    end

endmodule

