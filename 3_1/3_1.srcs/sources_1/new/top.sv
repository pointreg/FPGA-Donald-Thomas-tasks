module top;

parameter W=8;
logic [W-1:0] d, q, q_prev; 
logic rstN=1, ck=1, clr=0, ld=0, shl=0, shIn=0;
always #1 ck=~ck;

regWithBenefits uut (.*);

initial begin
    
	for (int i=0; i<=13'h1FFF; i++) begin
	    q_prev = q;
		{clr,ld,shl,shIn,d}=i;
		#1;
			if (rstN==0 && q!=0) 	 $display ($time, "ns, oops1, d=%d, q=%d, {clr,ld,shl,shIn}={%b,%b,%b,%b}", d, q, clr,ld,shl,shIn);
			else if (clr==1 && q!=0) $display ($time, "ns, oops2, d=%d, q=%d, {clr,ld,shl,shIn}={%b,%b,%b,%b}", d, q, clr,ld,shl,shIn);
			else if (clr==0 && ld==1 && q!=d)  $display ($time, "ns, oops3, d=%d, q=%d, {clr,ld,shl,shIn}={%b,%b,%b,%b}", d, q, clr,ld,shl,shIn);
			else if (clr==0 && ld==0 && shl==1 && {q_prev[W-2:0],shIn}!=q)  $display ($time, "ns, oops4, d=%d, q=%d, {clr,ld,shl,shIn}={%b,%b,%b,%b}", d, q, clr,ld,shl,shIn);
			#1;
			if(rstN==0 && q!=0 ) $display ("oops q(%d)!=0", q);
	end
	$finish;
end

endmodule


module regWithBenefits #(parameter W=8) (input logic [W-1:0] d, input logic rstN, ck, clr, ld, shl, shIn, output logic [W-1:0] q);

always_ff@ (posedge ck, negedge rstN)begin
	if (~rstN) 		q<=0;
	else if (clr) 	q<=0;
	else if (ld) 	q<=d;
	else if (shl) 	q<={q,shIn};
	else 		    q<=0;
end 

endmodule