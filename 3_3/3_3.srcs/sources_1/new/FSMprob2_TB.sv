program FSMprob2_TB (input logic clk, output logic i, j); //task 7.3. 

initial begin: J
	{i,j}<=2'b0x;
	@(posedge clk); //A
	{i,j}<=2'b1x;
	@(posedge clk); //B
	@(posedge clk); //C
	@(posedge clk); //B
	{i,j}<=2'b0x;
	@(posedge clk); //D
	{i,j}<=2'b1x;
	@(posedge clk); //D
	{i,j}<=2'b01;
	@(posedge clk); //C
	@(posedge clk); //C
	{i,j}<=2'b00;
	@(posedge clk); //D
	@(posedge clk); //A
	#1 $finish;
end
endprogram: FSMprob2_TB