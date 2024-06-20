module sumItUp
 (input logic ck, reset_l, go_l,
 input logic [15:0] inA,
 output logic done, error, //error
 output logic [15:0] sum);

logic ld_l, cl_l, inAeq, cOut=0;
logic [15:0] addOut=0;

enum bit [1:0] {sA, sB, sC} state=sA; //sC

always_ff @(posedge ck, negedge reset_l) begin: st_machine
	if (~reset_l) state <= sA;
	else begin
		if (((state == sA) & go_l) | (((state == sB)|(state == sC)) & inAeq & ~error))
		state <= sA;
		if ((((state == sA) | (state == sC)) & ~go_l) | ((state == sB) & ~inAeq)) 
		state <= sB;
		if ((state == sB & error) | (state == sC & go_l)) // added
		state <= sC; // added
	end
end: st_machine

always_ff @(posedge ck, negedge reset_l) begin: reg_sum
	if (~reset_l) sum <= 0;
	else if (~ld_l) sum <= addOut;
	else if (~cl_l) sum <= 0;
end: reg_sum

assign {cOut, addOut} = inA + sum,
ld_l = ~(((state == sA) & ~go_l) | (((state == sB)|(state == sC)) & ~inAeq)),  // ((state == sB)|(state == sC))
cl_l = ~(((state == sB)|(state == sC)) & inAeq), // ((state == sB)|(state == sC))
done = (state == sB) & inAeq & ~error, // & ~error
inAeq = inA == 0,
error = (state == sB & cOut) | (state == sC & go_l); //added

endmodule: sumItUp