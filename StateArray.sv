module SA(
    input  wire [63:0] m,
    input  wire [63:0] IV,
    output reg  [63:0] H
);
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            H[(i*8) +: 8] = (m >> (56 - i*8)) & 8'hFF;
            H[(i*8) +: 8] = H[(i*8) +: 8] ^ IV[(i*8) +: 8];
        end
    end
endmodule
