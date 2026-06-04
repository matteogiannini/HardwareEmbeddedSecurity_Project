module hash_round(
    input wire [63:0] msg_block,
    output reg [7:0] output_block [0:7],
    output reg [63:0] linear_out
);

    reg [7:0] SA_r [0:7];
    reg [7:0] theta_r [0:7];
    reg [7:0] rho_r [0:7];
    reg [63:0] aux_conv_r;

    SA SA_inst (
        .msg_block(msg_block),
        .output_block(SA_r)
    );

    theta theta_inst (
        .msg_arr(SA_r),
        .output_arr(theta_r)
    );

    rho rho_inst (
        .msg_arr(theta_r),
        .output_arr(rho_r)
    );

    aux_conv aux_conv_inst (
        .msg_arr(rho_r),
        .linear_arr(aux_conv_r)
    );

    assign output_block = rho_r;
    assign linear_out = aux_conv_r;

endmodule


