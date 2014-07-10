module calc_pi (

  input         clk,
  input         rst,

  output [28:0] pi_out

);

wire [30:0] rand_31;
wire [31:0] rand_32;
wire        rand_valid;
wire        op_lt_1_p2;
wire        coord_valid_p2;
reg         coord_valid_p3;
reg  [26:0] op_count;
reg  [26:0] lt_count;
wire [26:0] divide_out;

`ifdef PRBS_RAND
prbs i_rand (
    .clk         (clk),
    .rst         (rst),
    .prbs_out    (rand_31),
    .valid_out   (rand_valid));
`else
mercenne_twister i_mercenne (
    .clk               (clk),
    .reset             (rst),
    .rand_out          (rand_32),
    .rand_out_valid    (rand_valid));
assign rand_31 = rand_32[30:0];
`endif

coord_pl #(.IP_BIT_WIDTH(31)) i_coord (
    .clk               (clk),
    .rst               (rst),
    .rand_num          (rand_31),
    .rand_valid        (rand_valid),
    .coord_valid_out   (coord_valid_p2),
    .op_lt_1_out       (op_lt_1_p2));

always @(posedge clk or posedge rst)
    if (rst)
    begin
        op_count       <= 32'd0;
        lt_count       <= 32'd0;
        coord_valid_p3 <= 1'b0;
    end
    else 
    begin
        op_count       <= (coord_valid_p2) ? op_count + 32'd1 : op_count;
        lt_count       <= (coord_valid_p2 & op_lt_1_p2) ? lt_count + 32'd1 : lt_count; 
        coord_valid_p3 <= coord_valid_p2;
    end

linear_cordic ulinear_cordic (
    .clk           (clk),
    .reset         (rst),
    .x_in          (op_count),
    .y_in          (lt_count),
    .z_in          (27'd0),
    .valid_in      (coord_valid_p3),

    .x_out         (),
    .y_out         (),
    .z_out         (divide_out),
    .valid_out     (divide_valid));

assign pi_out = {divide_out,2'b00};

endmodule
