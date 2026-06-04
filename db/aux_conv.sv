module aux_conv(
    input wire [7:0] msg_arr [0:7],
    output reg [63:0] linear_arr
);

    // Convert the 8*8 array into a linear 64 bits output
    integer i;
    always_comb begin
        linear_arr = {msg_arr[0], msg_arr[1], msg_arr[2], msg_arr[3], msg_arr[4], msg_arr[5], msg_arr[6], msg_arr[7]};
    end

endmodule
