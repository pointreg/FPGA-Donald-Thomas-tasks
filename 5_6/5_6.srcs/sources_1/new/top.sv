module top;

logic clock=0, reset=0, start, done;
logic [3:0] a,b,sum;

always #1 clock=~clock;

serialBCDadder dut (.*);
serialBCDadder_TB tb (.*);
	
initial begin
	#1 reset = 1;
end

endmodule
