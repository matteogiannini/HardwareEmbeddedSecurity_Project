module Theta(
    input  wire [63:0] H_in,
    output reg  [63:0] H_out
);
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            H_out[(i*8) +: 8] = H_in[(56 - i*8) +: 8];
        end
    end
endmodule
