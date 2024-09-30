module FPX(
    input wire [7:0] msg_arr [0:7],
    output reg [7:0] output_arr [0:7]
);

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

    always @* begin  
        // d[i] = H[7-i] ^ IV[i] for i = 0 to 7
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            output_arr[i] <= IV[i] ^ msg_arr[7-i];
        end
    end
endmodule
