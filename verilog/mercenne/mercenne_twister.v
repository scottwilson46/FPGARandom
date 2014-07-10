


module mercenne_twister (
    input            clk,
    input            reset,

    output    [31:0] rand_out,
    output reg       rand_out_valid
);

parameter INIT_SEED               = 32'd19650218;
parameter N                       = 624;
parameter MATRIX_A                = 32'h9908b0df;
parameter UPPER_MASK              = 32'h80000000;
parameter LOWER_MASK              = 32'h7fffffff;
parameter KEY_LENGTH              = 4;
parameter INIT_GENRAND            = 8'd0;
parameter INIT_BY_ARRAY_PRE       = 8'd1;
parameter INIT_BY_ARRAY_ST1       = 8'd2;
parameter INIT_BY_ARRAY_ST2       = 8'd3;
parameter INIT_BY_ARRAY_WR_0      = 8'd4;
parameter INIT_BY_ARRAY_END       = 8'd5;
parameter INIT_BY_ARRAY_WR_0_ST2  = 8'd6;
parameter INIT_BY_ARRAY_WR0_FINAL = 8'd7;
parameter GENRAND_REFRESH_PRE1    = 8'd8;
parameter GENRAND_REFRESH_PRE2    = 8'd9;
parameter GENRAND_REFRESH_PT1     = 8'd10;
parameter GENRAND_REFRESH_PT2     = 8'd11;
parameter GENRAND_GEN_DATA_PRE    = 8'd12;
parameter GENRAND_GEN_DATA        = 8'd13;

reg  [7:0]  next_state, state;
reg  [9:0]  next_iter_count, iter_count;
reg  [9:0]  next_i_count, i_count;
reg  [9:0]  next_j_count, j_count;
reg  [9:0]  next_rd_addr, rd_addr;
reg  [9:0]  next_wr_addr, wr_addr;
reg  [31:0] mt_data, mt_data_reg, next_rd_data_reg, next_rd_data_reg2;
reg  [63:0] mt_data_pt1;
reg  [31:0] mt_data_pt2;
reg  [31:0] mt_data_pt3;
reg         wr_en;
wire [31:0] mt_rd_data;
reg  [31:0] mt_rd_data_reg;
reg  [31:0] mt_rd_data_reg2;

reg  [31:0] init_key[0:3];
reg  [31:0] mag01[0:1];
reg  [31:0] y;

assign rand_out = y;

initial
begin
    init_key[0] = 32'h123;
    init_key[1] = 32'h234;
    init_key[2] = 32'h345;
    init_key[3] = 32'h456;
    mag01[1]    = MATRIX_A;
    mag01[0]    = 32'h0;
end

always @(*)
begin
    next_state        = state;
    next_iter_count   = iter_count;
    mt_data           = mt_data_reg;
    wr_en             = 1'b0;
    next_rd_addr      = rd_addr;
    next_wr_addr      = wr_addr;
    next_rd_data_reg  = mt_rd_data_reg;
    next_rd_data_reg2 = mt_rd_data_reg2;
    rand_out_valid    = 1'b0;
    case (state)
        INIT_GENRAND:
        begin
            wr_en        = 1'b1;
            if (iter_count == 0)
                mt_data = INIT_SEED & 32'hffffffff;
            else begin
                mt_data = 32'd1812433253 * (mt_data_reg ^ (mt_data >> 30)) + iter_count;
                mt_data = mt_data & 32'hffffffff;
            end

            if (iter_count == N-2)
            begin
                next_i_count    = 1;
                next_j_count    = 0;
                next_rd_addr    = 10'd1;
            end
            if (iter_count == N-1)
            begin
                next_iter_count  = 0;
                next_state       = INIT_BY_ARRAY_ST1;
                next_rd_addr     = 10'd2;
                next_rd_data_reg = mt_rd_data;
            end
            else begin
                next_iter_count = iter_count + 10'd1;
            end
            next_wr_addr = next_iter_count;
        end
        INIT_BY_ARRAY_ST1:
        begin
            wr_en            = 1'b1;
            mt_data_pt1      = (mt_rd_data ^ ((mt_rd_data_reg ^ (mt_rd_data_reg >> 30)) * 1664525));
            mt_data_pt2      = (init_key[j_count] + j_count);
            mt_data          = mt_data_pt1 + mt_data_pt2;
            mt_data          = mt_data & 32'hffffffff;
            next_rd_data_reg = mt_data; 

            if (i_count==N-1)
            begin
                next_state   = INIT_BY_ARRAY_WR_0;
                next_i_count = 'd1;
                next_wr_addr = 'd0;
            end
            else
            begin
                next_i_count  = i_count+1;
                next_wr_addr  = next_i_count;
            end

            if (i_count>=N-2)
            begin
                next_rd_addr = 'd0;
            end
            else
            begin
                next_rd_addr = rd_addr + 'd1;
            end

            if (j_count==KEY_LENGTH-1)
                next_j_count = 'd0;
            else begin
                next_j_count = j_count+1;
            end

            if (iter_count == N-1)
            begin
                next_iter_count = 'd0;
                next_state = INIT_BY_ARRAY_ST2;
            end
            else		
                next_iter_count = iter_count + 4'd1;
        end
        INIT_BY_ARRAY_WR_0:
        begin
            wr_en        = 1'b1;
            mt_data      = mt_data_reg;
            next_wr_addr = 'd1;
            next_state   = INIT_BY_ARRAY_ST1;
            next_rd_addr = 'd2;
        end
        INIT_BY_ARRAY_ST2:
        begin
            wr_en            = 1'b1;
            mt_data_pt1      = (mt_rd_data ^ ((mt_rd_data_reg ^ (mt_rd_data_reg >> 30)) * 1566083941));
            mt_data          = mt_data_pt1 - i_count;
            mt_data          = mt_data & 32'hffffffff;
            next_rd_data_reg = mt_data; 

            if (i_count>=N-2)
                next_rd_addr = 'd1;
            else
                next_rd_addr = rd_addr + 'd1;

            if (i_count==N-1)
            begin
                next_state   = INIT_BY_ARRAY_WR_0_ST2;
                next_i_count = 'd1;
                next_wr_addr = 'd0;
            end
            else
            begin
                next_i_count  = i_count+1;
                next_wr_addr  = next_i_count;
            end

            if (iter_count == N-2)
            begin
                next_iter_count = 'd0;
                next_state      = INIT_BY_ARRAY_WR0_FINAL;
                next_wr_addr    = 'd0;
            end
            else		
                next_iter_count = iter_count + 4'd1;
        end

        INIT_BY_ARRAY_WR0_FINAL:
        begin
            wr_en           = 1'b1;
            mt_data         = 32'h80000000;
            next_state      = GENRAND_REFRESH_PRE1; 
            next_j_count    = 'd397;
            next_i_count    = 'd0;
            next_rd_addr    = next_i_count;
        end 

        INIT_BY_ARRAY_WR_0_ST2:
        begin
            wr_en        = 1'b1;
            mt_data      = mt_data_reg;
            next_wr_addr = 'd1;
            next_state   = INIT_BY_ARRAY_ST2;
            next_rd_addr = 'd1;
        end

        GENRAND_REFRESH_PRE1:
        begin
            next_i_count      = i_count + 'd1;
            next_rd_addr      = next_i_count;
            next_state        = GENRAND_REFRESH_PRE2; 
        end

        GENRAND_REFRESH_PRE2:
        begin
            next_rd_addr      = j_count;
            next_j_count      = j_count + 'd1;
            next_state        = GENRAND_REFRESH_PT1;  
            next_rd_data_reg  = mt_rd_data;
        end

        GENRAND_REFRESH_PT1:
        begin
            next_i_count      = i_count + 'd1;
            next_rd_addr      = next_i_count;
            next_rd_data_reg  = mt_rd_data;
            next_rd_data_reg2 = mt_rd_data_reg;
            next_state        = GENRAND_REFRESH_PT2;  
            next_wr_addr      = iter_count;
        end 

        GENRAND_REFRESH_PT2:
        begin
            wr_en             = 1'b1;
            next_rd_addr      = j_count;
            next_j_count      = (j_count == 32'd623) ? 32'd0 : j_count + 'd1;
            next_state        = GENRAND_REFRESH_PT1;
            y                 = (mt_rd_data_reg2&UPPER_MASK)|(mt_rd_data_reg&LOWER_MASK);
            mt_data           = mt_rd_data ^ (y>>1) ^ mag01[y & 32'h1];
            next_iter_count   = iter_count + 'd1;
            if (iter_count == 32'd622)
            begin
                next_state    = GENRAND_GEN_DATA_PRE; 
                next_rd_addr  = 'd0;
            end
        end

        GENRAND_GEN_DATA_PRE:
        begin
            next_rd_addr = rd_addr + 'd1;
            next_state   = GENRAND_GEN_DATA;
        end

        GENRAND_GEN_DATA:
        begin
            next_rd_addr = rd_addr + 'd1;
            if (rd_addr == 'd623)
            begin
                next_state = GENRAND_REFRESH_PRE1;
                next_j_count = 'd397;
                next_i_count = 'd0;
                next_iter_count = 'd0;
                next_wr_addr    = 'd0;
                next_rd_addr = next_i_count;
            end
            else
                next_state   = GENRAND_GEN_DATA;
            y            = mt_rd_data;
            y            = y ^ (y >> 11);
            y            = y ^ ((y << 7 ) & 32'h9d2c5680);
            y            = y ^ ((y << 15) & 32'hefc60000);
            y            = y ^ (y >> 18);
            rand_out_valid = 1'b1;
        end

    endcase
    end

    simple_memory #(.DATA_SIZE(32), .ADDR_SIZE(10)) i_simple_memory (
        .clk       (clk),
        .wr_data   (mt_data),
        .wr_addr   (wr_addr),
        .rd_addr   (rd_addr),
        .wr_en     (wr_en),
        .rd_data   (mt_rd_data));

    always @(posedge clk or posedge reset)
        if (reset)
        begin
            state           <= INIT_GENRAND;
            iter_count      <= 10'd0;
            mt_data_reg     <= 32'd0;
            rd_addr         <= 10'd0;
            wr_addr         <= 10'd0;
            mt_rd_data_reg  <= 32'd0;
            mt_rd_data_reg2 <= 32'd0;
            i_count         <= 32'd0;
            j_count         <= 32'd0;
        end
        else 
        begin
            state           <= next_state;
            iter_count      <= next_iter_count;
            mt_data_reg     <= mt_data;
            rd_addr         <= next_rd_addr;
            wr_addr         <= next_wr_addr;
            mt_rd_data_reg  <= next_rd_data_reg;
            mt_rd_data_reg2 <= next_rd_data_reg2;
            i_count         <= next_i_count;
            j_count         <= next_j_count;
        end 

        endmodule
