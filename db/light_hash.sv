module light_hash (
    input clk,
    input rst_n,
    input [7:0] msg_byte,           // 1-byte message input
    input byte_valid,               // Byte is valid and stable
    input msg_start,                // Indicates the message is still being provided
    output eoc,                     // End of conversion signal (output digest ready)
    output reg [7:0] ctxt [0:7]     // Processed output as an array of 8 byte elements
);

    reg [63:0] msg_block;           // Register to accumulate 64-bit (8-byte) blocks
    reg [2:0] byte_count;           // Counter for the number of bytes in the current block
    reg [1:0] state;                // State register
    reg processing_n;               // Indicates if a block is being processed
    reg eoc_reg;                    // EOC signal register
    wire hash_rfd;                  // RFD signal from hash_processor
    wire [7:0] hash_output [0:7];   // Output from hash_processor

    // State encoding
    parameter IDLE = 2'b00, 
              PROCESS = 2'b01, 
              FINALIZE = 2'b10, 
              DONE = 2'b11;

    // Instantiate the hash_processor
    hash_processor hash_proc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .msg_block(msg_block),     // Provide the accumulated 64-bit block
        .dav_(processing_n),       // Start processing the block when it's ready
        .rfd(hash_rfd),            // Get the end-of-conversion signal
        .ctxt(hash_output)         // Get the processed output
    );

    // FSM logic for processing blocks and handling byte input
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            msg_block   <= 64'd0;
            byte_count  <= 3'd0;
            processing_n  <= 1'b1;
            eoc_reg     <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    eoc_reg <= 1'b1;        // Set EOC high when idle
                    if (msg_start && byte_valid && byte_count<=7) begin
                        // Accumulate bytes into the 64-bit block
                        $display("IDLE: Received msg_byte = %h, byte_count = %d", msg_byte, byte_count);
                        msg_block <= {msg_block[55:0], msg_byte};
                        byte_count <= (byte_count == 3'd7)?byte_count:byte_count + 1;
                        state <= IDLE;
                    end 
                    else if (byte_count == 7 || (!msg_start && byte_count>0))begin
                        // If msg_start goes low and we have an incomplete block
                        processing_n <= 1'b0;
                        state <= (hash_rfd==0) ? PROCESS : IDLE; // Wait for hash_processor to start processing data
                        eoc_reg <= (hash_rfd==0) ? 1'b0:1'b1; // Clear EOC when processing
                        $display("IDLE: Block completed or incomplete message provided. Transitioning to PROCESS state.");
                    end
                    else begin
                        msg_block <= msg_block; 
                        byte_count <= byte_count;
                        state <= IDLE;
                    end
                end

                PROCESS: begin
                    // $display("PROCESS: Processing block, msg_block = %h", msg_block);
                    processing_n  <= 1'b1;
                    eoc_reg <= 1'b0;            // Clear EOC when processing data
                    if (hash_rfd==1) begin      // Wait for hash_processor to finish processing
                        $display("PROCESS: Hash processing complete. Transitioning to DONE state.");
                        for(int i = 0; i < 8; i = i + 1) begin
                            ctxt[i] <= hash_output[i];
                        end
                        state <= DONE;
                    end
                end
                DONE: begin
                    eoc_reg <= 1'b1;         // Set EOC high to indicate output is ready
                    msg_block <= 64'd0;      // Clear the message block
                    byte_count <= 3'd0;      // Reset the byte count
                    state <= IDLE;           // Go back to IDLE state
                    $display("DONE: Transitioning to IDLE state.");
                end
            endcase
        end
    end

    // Output assignment
    assign eoc = eoc_reg;

endmodule

