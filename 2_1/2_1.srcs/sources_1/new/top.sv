module top;

logic a,b;

initial begin
	a=0;
	b=1;
	#3;
	a=1;
	b=0;
	#3;
	b=1;
	#2;
	a=0;
	#3;
	a=1;
	b=0;
	#1;
	a=0;
	#4;
	$finish;
end
endmodule