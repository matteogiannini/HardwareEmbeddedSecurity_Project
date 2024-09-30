module light_hash (
    input          clk,
    input          rst_n,
    input  [7:0]   msg_byte,        // 1-byte message input
    input          byte_valid,      // Byte is valid and stable
    input          msg_start,       // Indicates the message is still being provided
    output         eoc,             // End of conversion signal (output digest ready)
    output reg [7:0]   ctxt [0:7]   // Processed output as an array of 8 1-byte elements
);

    reg [63:0]   msg_block;         // Register to accumulate 64-bit (8-byte) blocks
    reg [2:0]    byte_count;        // Counter for the number of bytes in the current block
    reg [1:0]    state;             // State register
    reg          processing;        // Indicates if a block is being processed
    reg          eoc_reg;           // EOC signal register
    wire         hash_eoc;          // EOC signal from hash_processor
    wire [7:0]   hash_output [0:7]; // Output from hash_processor

    // State encoding (same as hash_processor)
    parameter IDLE = 2'b00, 
              PROCESS = 2'b01, 
              FINALIZE = 2'b10, 
              DONE = 2'b11;

    // Instantiate the hash_processor
    hash_processor hash_proc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .msg_block(msg_block),     // Provide the accumulated 64-bit block
        .soc(processing),          // Start processing the block when it's ready
        .eoc(hash_eoc),            // Get the end-of-conversion signal
        .ctxt(hash_output)         // Get the processed output
    );

    // FSM logic for processing blocks and handling byte input
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            msg_block   <= 64'd0;
            byte_count  <= 3'd0;
            processing  <= 1'b0;
            eoc_reg     <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    eoc_reg <= 1'b1;        // Set EOC high when idle
                    if (msg_start && byte_valid) begin
                        // Accumulate bytes into the 64-bit block
                        msg_block   <= {msg_block[55:0], msg_byte};
                        byte_count  <= byte_count + 1;
                        $display("IDLE: Received msg_byte = %h, byte_count = %d", msg_byte, byte_count + 1);

                        // Move to PROCESS state when a full block (8 bytes) is ready
                        if (byte_count == 7) begin
                            state       <= PROCESS;
                            processing  <= 1'b1;  // Trigger hash_processor processing
                            byte_count  <= 0;
                             $display("IDLE: Full block ready. Transitioning to PROCESS state.");
                        end
                    end else if (!msg_start && byte_count > 0) begin
                        // If msg_start goes low and we have an incomplete block
                        state       <= PROCESS;
                        processing  <= 1'b1;
                        byte_count  <= 0;
                         $display("IDLE: Incomplete block ready. Transitioning to PROCESS state.");
                    end
                end

                PROCESS: begin
                      $display("PROCESS: Processing block, msg_block = %h", msg_block);
                    processing  <= 1'b0;
                    eoc_reg <= 1'b0;         // Clear EOC when processing
                    if (hash_eoc) begin      // Wait for hash_processor to finish processing
                        state       <= FINALIZE;
                        processing  <= 1'b0;
                            $display("PROCESS: Hash processing complete. Transitioning to FINALIZE state.");
                            $display("PROCESS: hash_output = {%h, %h, %h, %h, %h, %h, %h, %h}", 
                                     hash_output[0], hash_output[1], hash_output[2], hash_output[3], 
                                     hash_output[4], hash_output[5], hash_output[6], hash_output[7]);
                    end
                end

                FINALIZE: begin
                    // Transfer the hash_processor output to the ctxt array
                    ctxt[0] <= hash_output[0];
                    ctxt[1] <= hash_output[1];
                    ctxt[2] <= hash_output[2];
                    ctxt[3] <= hash_output[3];
                    ctxt[4] <= hash_output[4];
                    ctxt[5] <= hash_output[5];
                    ctxt[6] <= hash_output[6];
                    ctxt[7] <= hash_output[7];
                    state   <= DONE;
                    $display("FINALIZE: Transfer complete. Transitioning to DONE state.");
                end

                DONE: begin
                    eoc_reg <= 1'b1;         // Set EOC high to indicate output is ready
                    if (msg_start && byte_valid) begin
                        // Start collecting the next block when new data arrives
                        msg_block   <= {msg_block[55:0], msg_byte};
                        byte_count  <= byte_count + 1;
                        eoc_reg     <= 1'b0; // Clear EOC as we're starting a new block
                        $display("DONE: Starting new block with msg_byte = %h, byte_count = %d", msg_byte, byte_count + 1);

                        // If a full block is ready, move to PROCESS state
                        if (byte_count == 7) begin
                            state       <= PROCESS;
                            processing  <= 1'b1;
                            byte_count  <= 0;
                            $display("DONE: Full block ready. Transitioning to PROCESS state.");
                        end else begin
                            state <= IDLE;  // Wait for more bytes
                        end
                    end else begin
                        state <= IDLE;      // Stay in DONE if no more data
                    end
                end
            endcase
        end
    end

    // Output assignment
    assign eoc = eoc_reg;

endmodule

