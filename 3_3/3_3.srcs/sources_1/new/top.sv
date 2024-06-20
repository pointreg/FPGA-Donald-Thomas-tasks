typedef enum logic [1:0] {A=2'b00,B=2'b01,C=2'b10,D=2'b11} state_t;

module top;

logic clk=0, rstN=0, i, j, x, y;
state_t state, nextState;

FSMprob2 dut (.*);
////***use one of TB to test***////
//FSMprob2_TB tb (.*); //task 7.3. 
FSMprob2_TB2 fc (.*); //task 7.5., 10.2.

always #5 clk=~clk;

initial begin: I
    $monitor($time, " Current State = %s, ij = %b%b, xy = %b%b", state, i,j,x,y);
    rstN <= #1 1;
end 

endmodule: top

module FSMprob2 (input logic clk, rstN, i, j, output logic x,y, output state_t state, nextState); //Moore FSM

always_ff@(posedge clk, negedge rstN) begin
	if (~rstN)  state<=A; 
	else 		state<=nextState;
end

always_comb begin
	unique case (state)
	A: begin {x,y}=2'b11;
		nextState= (i)?B:A;
		end
	B: begin{x,y}=2'b01;
		nextState= (i)?C:D;
		end
	C: begin{x,y}=2'b10;
		nextState= (i)?B:(j)?C:D;
		end
	D: begin{x,y}=2'b10;
		nextState= (i)?D:(j)?C:A;
		end
	endcase
end
endmodule: FSMprob2


program FSMprob2_TB2 (input logic clk, rstN, x,y, input state_t state, output logic i, j); // no difference in coverage calculation between Moore and Mealy FSMs?

bit[1:0] invals;

covergroup  FSMprob2_fc @(posedge clk);
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

FSMprob2_fc fcover = new;

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
endprogram: FSMprob2_TB2