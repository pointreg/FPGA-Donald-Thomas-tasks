typedef enum logic [1:0] {A=2'b00,B=2'b01,C=2'b10,D=2'b11} state_t;

module top;

logic clk=0, rstN=0, i, j, x, y;
state_t state, nextState;

FSMprob dut (.*);
////***use one of TB to test***////
//FSMprob_TB tb(.*); // task 7.2.
FSMprob_TB2 fc (.*); // task 7.4., 10.1.

always #5 clk=~clk;

initial begin: I
    $monitor($time, " Current State = %s, ij = %b%b, xy = %b%b", state, i,j, x,y);
    rstN <= #1 1;
end 
endmodule: top

module FSMprob (input logic clk, rstN, i, j, output logic x,y, output state_t state, nextState); //Mealy FSM

always_ff@(posedge clk, negedge rstN) begin
	if (~rstN) state<=A;
	else state<=nextState;
end

always_comb begin  
	unique case (state)
	A: if (i) begin 
		{x,y}=2'b11;
		nextState=B;
		end
		else begin
		{x,y}=2'b10;
		nextState=A;
		end
	B: if (j) begin 
		{x,y}=2'b01;
		nextState=C;
		end
		else begin
		{x,y}=2'b10;
		nextState=D;
		end
	C: if (i) begin 
		{x,y}=2'b00;
		nextState=B;
		end
		else begin
		{x,y}=(j)?2'b10:2'b11;
		nextState=(j)?C:D;
		end
	D: if (i) begin 
		{x,y}=2'b00;
		nextState=D;
		end
		else begin
		{x,y}=(j)?2'b10:2'b00;
		nextState=(j)?C:A;;
		end
	endcase
end
endmodule: FSMprob


program FSMprob_TB2 (input logic clk, rstN, x,y, input state_t state, output logic i, j);

bit[1:0] invals;

covergroup  FSMprob_fc @(posedge clk);
option.at_least = 2;
coverpoint state
{
    bins a1 = (A => A);
    bins a2 = (A => B);
    bins a3 = (B => D);
    bins a4 = (D => D);
    bins a5 = (D => C);
    bins a6 = (C => C);
    bins a7 = (C => B);
    bins a8 = (B => C);
    bins a9 = (C => D);
    bins a10= (D => A);
    illegal_bins error = default sequence;
}
cross invals, state;
endgroup

FSMprob_fc fcover = new;

class InputTwiddle;
    rand bit[1:0] ins;
endclass

initial begin
static InputTwiddle t = new;
    while(fcover.get_coverage() < 100) begin
        assert (t.randomize());
        {i,j} <= t.ins;
        invals<= t.ins;
        @(posedge clk);
    end
    $display("Functional cover is %d%%", fcover.get_coverage());
    $finish;
end
endprogram: FSMprob_TB2