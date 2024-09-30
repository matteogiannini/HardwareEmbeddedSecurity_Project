module Rho(
    input  wire [63:0] H_in,
    output reg  [63:0] H_out
);
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            H_out[(i*8) +: 8] = (H_in[(i*8) +: 8] + 8'h85) % 8'hFD;
        end
    end
endmodule
