module linear_cordic_pipe #(parameter BIT_WIDTH=27) (

  input                           clk,
  input                           reset,
  input       [BIT_WIDTH-1:0]     x,
  input       [BIT_WIDTH-1:0]     y,
  input       [BIT_WIDTH-1:0]     z,
  input                           valid_in,
  input       [4:0]               shift,

  output reg  [BIT_WIDTH-1:0]     x_pipe,
  output reg  [BIT_WIDTH-1:0]     y_pipe,
  output reg  [BIT_WIDTH-1:0]     z_pipe,
  output reg                      valid_out
);

wire [BIT_WIDTH-1:0] next_x;
wire [BIT_WIDTH-1:0] next_y, next_y_1, next_y_2;
wire [BIT_WIDTH-1:0] next_z, next_z_1, next_z_2;
wire [BIT_WIDTH-1:0] y_tmp, x_tmp;
wire [BIT_WIDTH-1:0] sub_val;
wire top;

assign x_tmp = $signed(x)>>>(shift);
assign sub_val = (27'd1<<(23-shift));

assign next_x   = x;

assign next_z_1 = $signed(z) - sub_val;
assign next_y_1 = $signed(y) + $signed(x_tmp); 

assign next_z_2 = $signed(z) + sub_val;
assign next_y_2 = $signed(y) - $signed(x_tmp);

assign top = y[BIT_WIDTH-1];

assign next_z = top ? next_z_1 : next_z_2;
assign next_y = top ? next_y_1 : next_y_2; 

always @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    z_pipe    <= 'd0;
    x_pipe    <= 'd0; 
    y_pipe    <= 'd0;
    valid_out <= 1'b0;
  end
  else 
  begin
    z_pipe    <= next_z;
    x_pipe    <= next_x; 
    y_pipe    <= next_y;
    valid_out <= valid_in;
  end
end
 
endmodule
  

