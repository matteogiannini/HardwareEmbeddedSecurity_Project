module hash_processor (
    input          clk,
    input          rst_n,
    input  [63:0]  msg_block,
    input          dav_,               // Start of conversion signal, triggers processing when high
    output         rfd,               // End of conversion signal, indicates when output is ready
    output reg [7:0]   ctxt [0:7]     // Processed output as an array of 8 1-byte elements
);

    reg [63:0]   round_buffer;        // Register to hold the current data
    reg [5:0]    round_count;         // Counter for the number of rounds completed
    reg [1:0]    state;               // State register
    reg          RFD; assign rfd=RFD;             // RFD signal register

    parameter IDLE = 2'b00, 
              PROCESS = 2'b01, 
              FINALIZE = 2'b10, 
              DONE = 2'b11;
    
    // Intermediate signals for hash round output
    wire [63:0] hash_round_out;
    wire [7:0]  round_output_arr [0:7];    // Intermediate round output array from hash_round
    wire [7:0]  fpx_output_arr [0:7];      // Output array from FPX module

    // Instantiate the hash round module
    hash_round hash_round_i (
        .msg_block(round_buffer),
        .output_block(round_output_arr),   // Outputs the array that needs to be permuted
        .linear_out(hash_round_out)
    );

    // Instantiate the FPX module
    FPX fpx_inst (
        .msg_arr(round_output_arr),        // Connecting the output of hash_round to FPX
        .output_arr(fpx_output_arr)
    );

    // FSM for processing hash rounds
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            round_buffer  <= 64'd0;
            round_count   <= 6'd0;
            eoc_reg       <= 1'b0; // Set EOC to 1 during reset
        end else begin
            case (state)
                IDLE: begin
                    $display("IDLE: SOC = %b", soc);
                    eoc_reg <= 1'b0; // Set EOC to 1 when idle
                    round_buffer  <= msg_block; // Initial round input
                    round_count   <= 6'd0;
                    state         <= (soc==1)? PROCESS : IDLE; // Start processing when SOC is high
                end
                PROCESS: begin
                    $display("PROCESS: Round %d", round_count);
                    eoc_reg <= 1'b0; // Clear EOC when processing
                    if (round_count < 6'd36) begin
                        round_buffer <= hash_round_out;  // Update buffer with the output of the current round
                        round_count  <= round_count + 1;
                    end else begin
                        state <= FINALIZE;
                    end
                end
                FINALIZE: begin
                    // Transfer the FPX output to the ctxt array
                    ctxt[0] <= fpx_output_arr[0];
                    ctxt[1] <= fpx_output_arr[1];
                    ctxt[2] <= fpx_output_arr[2];
                    ctxt[3] <= fpx_output_arr[3];
                    ctxt[4] <= fpx_output_arr[4];
                    ctxt[5] <= fpx_output_arr[5];
                    ctxt[6] <= fpx_output_arr[6];
                    ctxt[7] <= fpx_output_arr[7];
                    eoc_reg <= 1'b1; // Set EOC to 1 when processing is done
                    state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // waits for next SOC to start processing again
                end
            endcase
        end
    end

    // Output assignments
    assign eoc = eoc_reg;

endmodule
