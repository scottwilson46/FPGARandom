module prbs(

    input             clk,
    input             rst,

    output reg [30:0] prbs_out,
    output reg        valid_out
);

always @(posedge clk or posedge rst)
    if (rst)
        prbs_out <= 'd2;
    else
        prbs_out <= {prbs_out[29:0], prbs_out[30]^prbs_out[27]};

always @(posedge clk or posedge rst)
    if (rst)
        valid_out <= 1'b0;
    else
        valid_out <= 1'b1;

endmodule


