
module simple_memory #(parameter DATA_SIZE = 8, ADDR_SIZE = 8)
          (
  input                      clk,
  input      [DATA_SIZE-1:0] wr_data,
  input      [ADDR_SIZE-1:0] wr_addr, 
  input      [ADDR_SIZE-1:0] rd_addr,
  input                      wr_en,
  output reg [DATA_SIZE-1:0] rd_data);


  reg  [DATA_SIZE-1:0] dout;
  reg  [DATA_SIZE-1:0] ram [(1<<ADDR_SIZE) - 1:0];

  always @(posedge clk)
    begin 
      if (wr_en == 1'b1) begin
        ram[wr_addr] <= wr_data;
      end
    end

  always @(posedge clk)
      rd_data <= ram[rd_addr];


endmodule 
