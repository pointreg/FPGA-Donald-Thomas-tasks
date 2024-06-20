program FSMprob_TB (input logic clk, output logic  i, j); // task 7.2.

initial begin: I
	{i,j}<=2'b0x;	//A
	@(posedge clk);
	{i,j}<=2'b1x;	//B
	@(posedge clk);
	{i,j}<=2'bx1;	//C
	@(posedge clk);
	{i,j}<=2'b01;	//C
	@(posedge clk);
	{i,j}<=2'b00;	//D
	@(posedge clk);
	{i,j}<=2'b01;	//C
	@(posedge clk);
	{i,j}<=2'b1x;	//B
	@(posedge clk);
	{i,j}<=2'bx0;	//D
	@(posedge clk);
	{i,j}<=2'b1x;	//D
	@(posedge clk);
	{i,j}<=2'b00;	//A
	@(posedge clk);
	#1 $finish;
end 
endprogram: FSMprob_TB