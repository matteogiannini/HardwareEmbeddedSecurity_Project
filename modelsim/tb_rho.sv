module tb_rho;

    reg [7:0] msg_arr [0:7];
    wire [7:0] output_arr [0:7];

    // Instantiate the rho module
    rho uut (
        .msg_arr(msg_arr),
        .output_arr(output_arr)
    );

    initial begin
        // Test Case 1: All zeros
        msg_arr[0] = 8'h00;
        msg_arr[1] = 8'h00;
        msg_arr[2] = 8'h00;
        msg_arr[3] = 8'h00;
        msg_arr[4] = 8'h00;
        msg_arr[5] = 8'h00;
        msg_arr[6] = 8'h00;
        msg_arr[7] = 8'h00;
        #10;

        $display("Test Case 1: All zeros");
        $display("msg_arr = { %h, %h, %h, %h, %h, %h, %h, %h }", 
            msg_arr[0], msg_arr[1], msg_arr[2], msg_arr[3], 
            msg_arr[4], msg_arr[5], msg_arr[6], msg_arr[7]);
        $display("output_arr = { %h, %h, %h, %h, %h, %h, %h, %h }", 
            output_arr[0], output_arr[1], output_arr[2], output_arr[3], 
            output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        $display("Expected output_arr = { 85, 85, 85, 85, 85, 85, 85, 85 }");
        if (output_arr[0] !== 8'h85 || output_arr[1] !== 8'h85 || output_arr[2] !== 8'h85 ||
            output_arr[3] !== 8'h85 || output_arr[4] !== 8'h85 || output_arr[5] !== 8'h85 ||
            output_arr[6] !== 8'h85 || output_arr[7] !== 8'h85) 
        begin
            $display("Output mismatch!");
        end

        // Test Case 2: Random values
        msg_arr[0] = 8'hFF;
        msg_arr[1] = 8'hAB;
        msg_arr[2] = 8'hCD;
        msg_arr[3] = 8'h12;
        msg_arr[4] = 8'h34;
        msg_arr[5] = 8'h56;
        msg_arr[6] = 8'h78;
        msg_arr[7] = 8'h90;
        #10;

        $display("Test Case 2: Random values");
        $display("msg_arr = { %h, %h, %h, %h, %h, %h, %h, %h }", 
            msg_arr[0], msg_arr[1], msg_arr[2], msg_arr[3], 
            msg_arr[4], msg_arr[5], msg_arr[6], msg_arr[7]);
        $display("output_arr = { %h, %h, %h, %h, %h, %h, %h, %h }", 
            output_arr[0], output_arr[1], output_arr[2], output_arr[3], 
            output_arr[4], output_arr[5], output_arr[6], output_arr[7]);
        $display("Expected output_arr = { 87, 33, 55, 97, B9, DB, 00, 18 }");
        if (output_arr[0] !== 8'h87 || output_arr[1] !== 8'h33 || output_arr[2] !== 8'h55 ||
            output_arr[3] !== 8'h97 || output_arr[4] !== 8'hB9 || output_arr[5] !== 8'hDB ||
            output_arr[6] !== 8'h00 || output_arr[7] !== 8'h18) 
        begin
            $display("Output mismatch!");
        end

        $finish;
    end

endmodule
