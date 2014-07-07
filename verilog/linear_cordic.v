module linear_cordic #(parameter BIT_WIDTH=27) (

  input                     clk,
  input                     reset,

  input [BIT_WIDTH-1:0]     x_in,
  input [BIT_WIDTH-1:0]     y_in,
  input [BIT_WIDTH-1:0]     z_in,
  input                     valid_in,
 
  output [BIT_WIDTH-1:0]    x_out,
  output [BIT_WIDTH-1:0]    y_out,
  output [BIT_WIDTH-1:0]    z_out,
  output                    valid_out

);

wire [BIT_WIDTH-1:0] x_pipe0;
wire [BIT_WIDTH-1:0] y_pipe0;
wire [BIT_WIDTH-1:0] z_pipe0;
wire [BIT_WIDTH-1:0] x_pipe1;
wire [BIT_WIDTH-1:0] y_pipe1;
wire [BIT_WIDTH-1:0] z_pipe1;
wire [BIT_WIDTH-1:0] x_pipe2;
wire [BIT_WIDTH-1:0] y_pipe2;
wire [BIT_WIDTH-1:0] z_pipe2;
wire [BIT_WIDTH-1:0] x_pipe3;
wire [BIT_WIDTH-1:0] y_pipe3;
wire [BIT_WIDTH-1:0] z_pipe3;
wire [BIT_WIDTH-1:0] x_pipe4;
wire [BIT_WIDTH-1:0] y_pipe4;
wire [BIT_WIDTH-1:0] z_pipe4;
wire [BIT_WIDTH-1:0] x_pipe5;
wire [BIT_WIDTH-1:0] y_pipe5;
wire [BIT_WIDTH-1:0] z_pipe5;
wire [BIT_WIDTH-1:0] x_pipe6;
wire [BIT_WIDTH-1:0] y_pipe6;
wire [BIT_WIDTH-1:0] z_pipe6;
wire [BIT_WIDTH-1:0] x_pipe7;
wire [BIT_WIDTH-1:0] y_pipe7;
wire [BIT_WIDTH-1:0] z_pipe7;

wire valid_pipe0;
wire valid_pipe1;
wire valid_pipe2;
wire valid_pipe3;
wire valid_pipe4;
wire valid_pipe5;
wire valid_pipe6;
wire valid_pipe7;


  linear_cordic_pipe ulinear_cordic_pipe_0 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_in),
    .y          (y_in),
    .z          (z_in),
    .valid_in   (valid_in),
    .shift      (5'd0),

    .x_pipe     (x_pipe0),
    .y_pipe     (y_pipe0),
    .z_pipe     (z_pipe0),
    .valid_out  (valid_pipe0));

  linear_cordic_pipe ulinear_cordic_pipe_1 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe0),
    .y          (y_pipe0),
    .z          (z_pipe0),
    .valid_in   (valid_pipe0),
    .shift      (5'd1),

    .x_pipe     (x_pipe1),
    .y_pipe     (y_pipe1),
    .z_pipe     (z_pipe1),
    .valid_out  (valid_pipe1));

  linear_cordic_pipe ulinear_cordic_pipe_2 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe1),
    .y          (y_pipe1),
    .z          (z_pipe1),
    .valid_in   (valid_pipe1),
    .shift      (5'd2),

    .x_pipe     (x_pipe2),
    .y_pipe     (y_pipe2),
    .z_pipe     (z_pipe2),
    .valid_out  (valid_pipe2));

  linear_cordic_pipe ulinear_cordic_pipe_3 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe2),
    .y          (y_pipe2),
    .z          (z_pipe2),
    .valid_in   (valid_pipe2),
    .shift      (5'd3),

    .x_pipe     (x_pipe3),
    .y_pipe     (y_pipe3),
    .z_pipe     (z_pipe3),
    .valid_out  (valid_pipe3));

  linear_cordic_pipe ulinear_cordic_pipe_4 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe3),
    .y          (y_pipe3),
    .z          (z_pipe3),
    .valid_in   (valid_pipe3),
    .shift      (5'd4),

    .x_pipe     (x_pipe4),
    .y_pipe     (y_pipe4),
    .z_pipe     (z_pipe4),
    .valid_out  (valid_pipe4));

  linear_cordic_pipe ulinear_cordic_pipe_5 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe4),
    .y          (y_pipe4),
    .z          (z_pipe4),
    .valid_in   (valid_pipe4),
    .shift      (5'd5),

    .x_pipe     (x_pipe5),
    .y_pipe     (y_pipe5),
    .z_pipe     (z_pipe5),
    .valid_out  (valid_pipe5));

  linear_cordic_pipe ulinear_cordic_pipe_6 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe5),
    .y          (y_pipe5),
    .z          (z_pipe5),
    .valid_in   (valid_pipe5),
    .shift      (5'd6),

    .x_pipe     (x_pipe6),
    .y_pipe     (y_pipe6),
    .z_pipe     (z_pipe6),
    .valid_out  (valid_pipe6));

  linear_cordic_pipe ulinear_cordic_pipe_7 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe6),
    .y          (y_pipe6),
    .z          (z_pipe6),
    .valid_in   (valid_pipe6),
    .shift      (5'd7),

    .x_pipe     (x_pipe7),
    .y_pipe     (y_pipe7),
    .z_pipe     (z_pipe7),
    .valid_out  (valid_pipe7));

  linear_cordic_pipe ulinear_cordic_pipe_8 (
    .clk        (clk),
    .reset      (reset),
    .x          (x_pipe7),
    .y          (y_pipe7),
    .z          (z_pipe7),
    .valid_in   (valid_pipe7),
    .shift      (5'd8),

    .x_pipe     (x_out),
    .y_pipe     (y_out),
    .z_pipe     (z_out),
    .valid_out  (valid_out));


endmodule
