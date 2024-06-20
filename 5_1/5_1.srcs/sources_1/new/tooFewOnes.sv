module tooFewOnes (input clk, in, rst, output logic valid); //tooFewOnes

logic [2:0] fivesCounter, onesCounter;
bit isTwoOfFive, isFive;

assign valid = isTwoOfFive & isFive; //status point?/output 
assign isTwoOfFive = onesCounter == 2; //status point ?
assign isFive 	   = fivesCounter== 4; //control point ?

always_ff @(posedge clk, negedge rst)  begin: counting
	if(~rst) begin 
		fivesCounter <= 4;
		onesCounter  <= 0;
	end
	else begin
		if(~isFive) begin
			fivesCounter <= fivesCounter + 1;
			onesCounter  <= onesCounter + in;
		end
		else if (isFive) begin
			fivesCounter <= 0;
			onesCounter  <= in;
		end
	end
end: counting

	
endmodule: tooFewOnes