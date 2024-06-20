module p3_4_TB (input logic clk, reset, output logic y,z,x);

p3_4 dut (.*);

initial begin: J
    //$monitor($time, " Current State = %s, state[1:0]=%b, x = %b, yz = %b%b", dut.state, dut.state[1:0], x, y, z);
    $monitor($time, " Current State = %b, x = %b, yz = %b%b", dut.q, x, y, z);
	#1 x<=1'b0;
	@(posedge clk); //B
	@(posedge clk); //B
	#1 x<=1'b1;
	@(posedge clk); //C
	@(posedge clk); //C
	#1 x<=1'b0;
	@(posedge clk); //A
	#1 x<=1'b1;
	@(posedge clk); //C
    #1 $finish;
end

endmodule: p3_4_TB
