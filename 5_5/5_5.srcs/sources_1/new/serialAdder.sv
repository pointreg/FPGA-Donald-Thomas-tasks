module serialAdder
(input logic a, b, start, reset, clock,
output logic [5:0] sum,
output logic done, cout, zero, neg, twosOFlow);
//assuming that a & b are bits of two's complement binary number

logic cin, carryOut, load, sumRes, clear;
bit [2:0] pos, cnt;

fullAdd DUTfullAdd (.a(a),.b(b),.cin(cin),.sum(sumRes),.cout(carryOut));

enum bit {sA, sB} state;

always_ff @(posedge clock, negedge reset) begin: st_machine
	if (~reset) state <= sA;
	else begin
		if 	    ((state==sB && cnt!=6) || (state==sA && start))  state <= sB;
		else if ((state==sB && cnt==6) || (state==sA && ~start)) state <= sA;
	end
end: st_machine

always_ff @(posedge clock, negedge reset) begin: reg_sum
	if (~reset) begin sum<=0; pos<=0; cin <= 0; end
	else begin 		
		done <= pos==5;
	    if (load) begin 
          if (pos==0) sum <= sumRes;
          else if (pos==5) sum [pos] <= a^b?(sumRes):(a&b);
          else sum [pos] <= sumRes;
          pos       <= (cnt==6)?0:cnt; 
          cin       <= (pos==5)?0:carryOut; 
          cout      <= (pos==5 & !a & !b)?cin:0;
          twosOFlow	<= cnt==6 & neg & (carryOut & ~sumRes);
		end
		else begin
		  done<= 0;
		  sum <= 0;
		  cin <= 0;
		  pos <= 0;
		  cout<= 0;
		  twosOFlow<=0;
		end
	end
end: reg_sum

assign   load  = ((state==sB) & (cnt!=7)) | ((state==sA) & start),
		 cnt         = pos+1,
		 neg	 	 = done & sum[5],
		 zero	     = done & sum==0 & ~twosOFlow & ~cout;

endmodule: serialAdder