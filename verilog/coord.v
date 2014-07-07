module coord #(parameter IP_BIT_WIDTH = 31) (

    input                    clk,
    input                    rst,
    input [IP_BIT_WIDTH-1:0] rand_num,
    input                    rand_valid,
    
    output reg               op_lt_1_out,
    output reg               coord_valid_out
);

  wire                        next_coord_sel;
  wire [IP_BIT_WIDTH-1:0]     next_x_coord;
  wire [IP_BIT_WIDTH-1:0]     next_y_coord;
  wire                        next_coord_valid;
  wire [(IP_BIT_WIDTH*2)-1:0] calc_x_sq_p0;
  wire [(IP_BIT_WIDTH*2)-1:0] calc_y_sq_p0;
  reg                         coord_sel;
  reg  [IP_BIT_WIDTH-1:0]     x_coord_p0;
  reg  [IP_BIT_WIDTH-1:0]     y_coord_p0;
  reg  [IP_BIT_WIDTH-1:0]     calc_x_sq_p1;
  reg  [IP_BIT_WIDTH-1:0]     calc_y_sq_p1;
  wire [IP_BIT_WIDTH:0]       sq_add_p1;
  reg                         coord_valid_p0;
  reg                         coord_valid_p1;
  wire                        op_lt_1_p1;


  assign next_coord_sel   = (rand_valid) ? ~coord_sel : coord_sel;

  assign next_x_coord     = (~coord_sel & rand_valid) ? rand_num : x_coord_p0;
  assign next_y_coord     = ( coord_sel & rand_valid) ? rand_num : y_coord_p0;

  assign next_coord_valid = (coord_sel & rand_valid);

  assign calc_x_sq_p0     = $signed(x_coord_p0) * $signed(x_coord_p0);
  assign calc_y_sq_p0     = $signed(y_coord_p0) * $signed(y_coord_p0);

  assign sq_add_p1        = calc_x_sq_p1 + calc_y_sq_p1;

  assign op_lt_1_p1       = ~sq_add_p1[IP_BIT_WIDTH-2];

  always @(posedge clk or posedge rst)
      if (rst)
      begin
          coord_sel       <= 1'b0;
          x_coord_p0      <= {IP_BIT_WIDTH{1'b0}};
          y_coord_p0      <= {IP_BIT_WIDTH{1'b0}};
          coord_valid_p0  <= 1'b0;
          coord_valid_p1  <= 1'b0;
          coord_valid_out <= 1'b0;
          calc_x_sq_p1    <= {IP_BIT_WIDTH{1'b0}};
          calc_y_sq_p1    <= {IP_BIT_WIDTH{1'b0}};
          op_lt_1_out     <= 1'b0;
      end
      else
      begin
          coord_sel       <= next_coord_sel;
          x_coord_p0      <= next_x_coord;
          y_coord_p0      <= next_y_coord;
          coord_valid_p0  <= next_coord_valid;
          coord_valid_p1  <= coord_valid_p0;
          coord_valid_out <= coord_valid_p1;
          calc_x_sq_p1    <= (coord_valid_p0 ? calc_x_sq_p0[(IP_BIT_WIDTH*2)-1:IP_BIT_WIDTH] : calc_x_sq_p1);
          calc_y_sq_p1    <= (coord_valid_p0 ? calc_y_sq_p0[(IP_BIT_WIDTH*2)-1:IP_BIT_WIDTH] : calc_y_sq_p1);
          op_lt_1_out     <= (coord_valid_p1 ? op_lt_1_p1 : op_lt_1_out);
      end

endmodule
