module FPX(
    input  wire [63:0] H_in,
    input  wire [63:0] IV,
    output reg  [63:0] digest
);
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            digest[(i*8) +: 8] = H_in[(56 - i*8) +: 8] ^ IV[(i*8) +: 8];
        end
    end
endmodule
