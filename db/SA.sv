module SA (
    input [63:0] msg_block,
    output reg [7:0] output_block [0:7]  // Array of 8 bytes (1 byte each)
);

    // Definition of IV
    reg [7:0] IV [0:7];
    initial begin
        IV[0] = 8'h34;
        IV[1] = 8'h55;
        IV[2] = 8'h0F;
        IV[3] = 8'h14;
        IV[4] = 8'hCC;
        IV[5] = 8'hAA;
        IV[6] = 8'hF0;
        IV[7] = 8'hE3;
    end

    always_comb begin
        output_block[0] = IV[0] ^ msg_block[63:56];
        output_block[1] = IV[1] ^ msg_block[55:48];
        output_block[2] = IV[2] ^ msg_block[47:40];
        output_block[3] = IV[3] ^ msg_block[39:32];
        output_block[4] = IV[4] ^ msg_block[31:24];
        output_block[5] = IV[5] ^ msg_block[23:16];
        output_block[6] = IV[6] ^ msg_block[15:8];
        output_block[7] = IV[7] ^ msg_block[7:0];
    end

endmodule
