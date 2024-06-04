module top;

not #1 (anot,A),(bnot,B);
or  #3 (f1,B,anot);
xor #5 (f3,A,bnot);
nand#4 (f2,anot,B);
and #6 (f,f1,f2,f3);

logic A,B;
initial begin
	A=0;
	B=1;
	#15 A=1;
	B=0;
	#15 $finish;
end

endmodule