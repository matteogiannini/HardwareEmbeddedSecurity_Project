module theta(
    input wire [7:0] msg_arr [0:7],
    output reg [7:0] output_arr [0:7]
);

    integer i;
    always @* begin
        for (i = 0; i < 8; i = i + 1) begin
            output_arr[i] = msg_arr[7-i];  // Direct assignment inside always block
        end
    end

endmodule

