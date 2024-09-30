module rho(
    input wire [7:0] msg_arr [0:7],
    output reg [7:0] output_arr [0:7]
);

    reg [8:0] tmpcalc [0:7]; // Use 9-bit temporary register to avoid overflow

    integer i;
    always @* begin
        // Copy msg_arr to tmpcalc
        for (i = 0; i < 8; i = i + 1) begin
            tmpcalc[i] = msg_arr[i];
        end
    end

    always @* begin
        // Apply the transformation (msg_arr[i] + 0x85) % 0xFD
        for (i = 0; i < 8; i = i + 1) begin
            tmpcalc[i] = (tmpcalc[i] + 9'h85) % 9'hFD; // Ensure the modulo calculation is correct
        end
    end

    always @* begin
        // Copy tmpcalc to output_arr
        for (i = 0; i < 8; i = i + 1) begin
            output_arr[i] = tmpcalc[i][7:0]; // Assign only the lower 8 bits
        end
    end

endmodule
