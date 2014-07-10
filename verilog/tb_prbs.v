module tb();

	reg clk, reset;
        wire [28:0] pi_out;
        real pi_real;

	initial
	begin
		reset = 1'b0;
		clk   = 1'b0;
		#10 reset = 1'b1;
		#10 reset = 1'b0;

		while(1)
			#10 clk = ~clk;
	end




initial
begin
	$dumpfile("new.vcd");
	$dumpvars();
	#10000000
        
        $display("pi = %f", pi_real);
        $finish();
end

calc_pi _i_calc_pi (
    .clk       (clk),
    .rst       (reset),
    .pi_out    (pi_out));

always @(*)
begin
    pi_real = ($itor(pi_out)) / (2**23);
end
endmodule
