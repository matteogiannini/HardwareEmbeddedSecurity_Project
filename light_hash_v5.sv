module light_hash_v5 (
    input  wire        clk,            // Clock signal
    input  wire        rst_n,          // Asynchronous active-low reset
    input  wire        start,          // Start of a message
    input  wire        valid_in,       // Indicates valid input byte
    input  wire [63:0] m,              // Input message (64-bit)
    output reg  [63:0] final_digest,   // Output digest (64-bit)
    output reg         valid_out       // Indicates when the digest is ready
);

    // Internal registers and wires
    reg [63:0] IV = 64'h34550F14CCAAF0E3;
    reg [63:0] digest;
    reg [5:0]  round_counter;         // 6-bit counter to count up to 36 rounds
    reg        process_complete;      // Indicates completion of all rounds

    // Separate wires for each stage
    wire [63:0] H_sa, H_theta, H_rho;

    // Instantiate the SA module
    SA sa_inst (
        .m(m),
        .IV(IV),
        .H(H_sa)         // Output from SA module
    );

    // Instantiate the Theta module
    Theta theta_inst (
        .H_in(H_sa),     // Input to Theta module from SA
        .H_out(H_theta)  // Output from Theta module
    );

    // Instantiate the Rho module
    Rho rho_inst (
        .H_in(H_theta),  // Input to Rho module from Theta
        .H_out(H_rho)    // Output from Rho module
    );

    // Instantiate the FPX module
    FPX fpx_inst (
        .H_in(H_rho),    // Input to FPX module from Rho
        .IV(IV),
        .digest(digest)  // Final digest output
    );

    // State machine for handling the message processing
    typedef enum reg [1:0] {
        IDLE,
        PROCESS,
        FINALIZE
    } state_t;

    reg [1:0] current_state, next_state;

    // Synchronous state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // State machine logic
    always @(*) begin
        next_state = current_state; // Default is to stay in the current state
        case (current_state)
            IDLE: begin
                valid_out = 1'b0;
                if (start && valid_in) begin
                    next_state = PROCESS;
                    round_counter = 6'd0; // Reset the round counter
                end
            end
            PROCESS: begin
                if (valid_in) begin
                    if (round_counter < 36) begin
                        round_counter = round_counter + 1;
                    end else begin
                        process_complete = 1'b1;
                        next_state = FINALIZE;
                    end
                end
            end
            FINALIZE: begin
                valid_out = 1'b1; // Indicate that the digest is ready
                final_digest = digest;
                next_state = IDLE; // Go back to IDLE after processing
            end
        endcase
    end

    // Asynchronous reset handling and state-specific logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            digest <= 64'd0;
            round_counter <= 6'd0;
            valid_out <= 1'b0;
            process_complete <= 1'b0;
        end else if (valid_in && current_state == PROCESS) begin
            // Perform any additional processing if needed
        end else if (current_state == FINALIZE) begin
            final_digest <= digest;
        end
    end

endmodule

