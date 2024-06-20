module p3_5 (input logic x, clk, reset, output logic y, z); //Mealy FSM

////commented rows are for comparison to see no functional difference between state machine realizations. 
////make comment inversion for a check.

//enum logic [2:0] {A=3'b001,B=3'b010,C=3'b100} state, nextState;
logic [2:0] q; // unitary coding state variable

always_ff@(posedge clk, negedge reset) begin
//	if (~reset)  state<=A; 
//	else 		 state<=nextState;
	if (~reset) q	<=	1; 
	else 		q	<=	{x,!q[2]&!x,!x&q[2]};
end

always_comb begin
	y	=	(q[0]&x) | q[1] | (q[2]&!x);
	z	=	q[0] | (q[2]&x);

//	unique case (state)
//	A: if (!x) begin
//			{y,z} 	 = 2'b01;
//			nextState = B;
//		end
//		else  begin
//			{y,z} 	 = 2'b11;
//			nextState = C;
//		end
//	B: if (!x) begin
//			{y,z} 	 = 2'b10;
//			nextState = B;
//		end
//		else begin
//			{y,z} 	 = 2'b10;
//			nextState = C;
//		end
//	C: if (!x) begin
//			{y,z} 	 = 2'b10;
//			nextState = A;
//		end
//		else begin
//			{y,z} 	 = 2'b01;
//			nextState = C;
//		end
//	endcase
end

endmodule: p3_5

