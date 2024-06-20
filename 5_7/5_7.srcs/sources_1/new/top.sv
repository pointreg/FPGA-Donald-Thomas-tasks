module top;

logic ck=0, r=0, countEnable=0;
logic carryOut;
logic [3:0] DCBA10, DCBA1;

always #1 ck=~ck;
zeroTo99 uut (.*);
 
initial begin
	#1;
	#1 r = 1;
	countEnable=1;
	#198;
	countEnable=0;
	#5;
	countEnable=1;
	#210;
	$finish;
end

endmodule


