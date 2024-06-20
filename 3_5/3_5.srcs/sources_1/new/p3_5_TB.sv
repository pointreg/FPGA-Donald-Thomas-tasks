module p3_5_TB (input logic clk, reset, output logic y,z,x);

p3_5 dut (.*);

initial begin: J
    //$monitor($time, " Current State = %s, x = %b, yz = %b%b", dut.state, x, y, z);
    $monitor($time, " Current State = %b, x = %b, yz = %b%b", dut.q, x, y, z);
	#1 x<=1'b0;			 //yz=01
	@(posedge clk); //B	
						 //yz=10
	@(posedge clk); //B	
	#1 x<=1'b1;			 //yz=10
	@(posedge clk); //C	
						 //yz=01
	@(posedge clk); //C	
	#1 x<=1'b0;			 //yz=10
	@(posedge clk); //A	
	#1 x<=1'b1;			 //yz=11
	@(posedge clk); //C
	
	#1 $finish;
end

endmodule: p3_5_TB