module serialBCDadder 
(input logic [3:0] a,b,
input logic start, done, reset, clock,
output logic [3:0] sum);
								
logic [3:0] res;							
logic carryIn, carryOut, cout, load;							
bcdAdd uut (.sum(res),.*);

enum bit {sA,sB} state;

always_ff@ (posedge clock, negedge reset) begin
	if (~reset) begin
		state <= sA;
	end
	else begin
		if ((start & state==sA)|(!start & state==sB)) state <= sB;
		if ((done & state==sB) |(!start & state==sA)) state <= sA;
	end
end

always_ff@ (posedge clock, negedge reset) begin
	if (~reset) begin
		carryIn <= 0;
	end
	else begin
		if (load) carryIn <= done?0:carryOut; 
		else      carryIn <= 0;
	end
end

assign load = ((start & state==sA)|(!start & state==sB)),
       sum  = load?res:'bz,
       cout = done && carryOut;

endmodule: serialBCDadder


module bcdAdd
	(input logic [3:0] a,b,
	input logic carryIn,
	output logic [3:0] sum,
	output logic carryOut);

	logic [3:0] sum1, temp;
	logic co, co1;

	fullAdd_4bit add1 (a,b,carryIn,sum1,co); //module from task 1_7
	and(q1,sum1[3],sum1[2]),(q2,sum1[3],sum1[1]);
	or(carryOut,co,q1,q2);
	assign temp={1'b0,carryOut,carryOut,1'b0};
	fullAdd_4bit add2 (temp,sum1,1'b0,sum,co1); //module from task 1_7

endmodule: bcdAdd