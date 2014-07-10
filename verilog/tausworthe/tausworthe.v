module tausworth (

  input    clk,
  input    reset,
  
  output [31:0]  random_out,
  output reg     valid_out
);

parameter S0 = 32'hffffffff;
parameter S1 = 32'hcccccccc;
parameter S2 = 32'h00ff00ff;

wire [31:0] b1,b2,b3;
wire [31:0] next_S0, next_S1, next_S2;
reg  [31:0] S0_reg, S1_reg, S2_reg;

assign b1      = (((S0_reg << 13) ^ S0_reg) >> 19);
assign next_S0 = (((S0_reg & 32'hfffffffe) << 12) ^ b1);
assign b2      = (((S1_reg << 2 ) ^ S1_reg) >> 25);
assign next_S1 = (((S1_reg & 32'hfffffff8) << 4 ) ^ b2);
assign b3      = (((S2_reg << 3 ) ^ S2_reg) >> 11);
assign next_S2 = (((S2_reg & 32'hfffffff0) << 17) ^ b3);

assign random_out = S0_reg ^ S1_reg ^ S2_reg;

always @(posedge clk or posedge reset)
  if (reset)
  begin
    S0_reg <= S0;
    S1_reg <= S1;
    S2_reg <= S2;
    valid_out <= 1'b0;
  end
  else
  begin 
    S0_reg <= next_S0;
    S1_reg <= next_S1;
    S2_reg <= next_S2;
    valid_out <= 1'b1;
  end

endmodule
