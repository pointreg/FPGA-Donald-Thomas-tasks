module p3_4 (input logic x, clk, reset, output logic y,z); //Moore FSM

////commented rows are for comparison to see no functional difference between state machine realizations. 
////make comment inversion for a check.

//enum logic [2:0] {A=3'b001,B=3'b010,C=3'b110,D=3'b111} state, nextState; //D state is for correct displaying of state transitions in State Machine Viewer (Quartus 2 ver.13.0.1)
logic [2:0] q; // output's based encoding state variable

always_ff@(posedge clk, negedge reset) begin
//	if (~reset)  state<=A; 
//	else 			 state<=nextState;
	if (~reset)  q<=1; 
	else 		 q<={x,(!q[2]) | (x&q[2]),q[2]&!x};
end

always_comb begin
	y=q[1];
	z=q[0];

//	unique case (state)	//casex if make A=3'bx01 (contains x)
//	A: begin{y,z}=state;
//		nextState= (x)?C:B;
//		end
//	B: begin{y,z}=state; 
//		nextState= (x)?C:B;
//		end
//	C: begin{y,z}=state;
//		nextState= (x)?C:A;
//		end
//	D: begin{y,z}=state;  //D state is for correct displaying of state transitions in State Machine Viewer (Quartus 2 ver.13.0.1)
//		nextState= D;
//		end
//	endcase
end

endmodule: p3_4

