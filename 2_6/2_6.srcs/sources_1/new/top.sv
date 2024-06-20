module top;

logic [3:0] cost, paid, remaining;  //in amount of 5 cents
logic [1:0] quaters, dimes, nickels; //qtty of 25, 10, 5 cents
logic [2:0] firstCoin, secondCoin;  //3'b000 - 0; 3'b001 - 5 cent; 3'b010 - 10 cent; 3'b101 - 15 cent;
logic exactAmount, notEnoughChange, coughUpMore; //flags

giveMeChange uut (.*);
int temp=0;

initial begin
    for (int c = 0; c<=15; c++) begin // cost
        for (int p = 0; p<=15; p++) begin // paid
            for (int ndq = 0; ndq<=6'h3F; ndq++) begin // qtty of {nickels,dimes,quaters} inside
                {cost,paid,nickels,dimes,quaters} = {c[3:0],p[3:0],ndq[5:0]};
                #1;
                if (c!=0) begin
                    temp = p[3:0]-c[3:0]-firstCoin-secondCoin;
                    if (c==p) begin
                        if (~exactAmount) $display ($time, ", oops, !exactAmount"); // exactAmount check
                    end
                    else if (c>p) begin
                        if(~coughUpMore) $display ($time, ", oops, !coughUpMore");  // coughUpMore check
                    end
                    else if (c<p) begin
                        if (temp!=remaining) $display ($time, ", oops, paid(%d)-cost(%d)-firstCoin(%d)-secondCoin(%d)!=remain(%d)",p[3:0],c[3:0],firstCoin,secondCoin,remaining); // remaining check
                        if (temp>0 && ~notEnoughChange) $display ($time, ", oops, !notEnoughChange"); // notEnoughChange check
                        if (firstCoin!=((p-c>=5 && ndq[1:0]!=0) ? 3'b101 : (p-c>=2 & ndq[3:2]!=0)?3'b010:(p-c>=1 && ndq[5:4]!=0)? 3'b001 : 0)) 
                            $display ($time, ", oops, firstCoin error"); // firstCoin check
                        else if (secondCoin != ( (p-c-firstCoin>=5 & (ndq[1:0]-(firstCoin[2]&firstCoin[0]))>0) ?3'b101:
                                                 (p-c-firstCoin>=2 & (ndq[3:2]-firstCoin[1])>0)                ?3'b010:
                                                 (p-c-firstCoin>=1 & (ndq[5:4]-(firstCoin[2]^firstCoin[0]))>0) ?3'b001: 0) )
                            $display ($time, ", oops, secondCoin error"); // secondCoin check
                    end
                end
            end
        end
    end
	$finish;
end


endmodule

module giveMeChange (
input logic [3:0] cost, paid, 
input logic [1:0] quaters, dimes, nickels,
output logic [2:0] firstCoin, secondCoin, 
output logic exactAmount, notEnoughChange, coughUpMore,
output logic [3:0] remaining);

logic [3:0] diff; 

always_comb begin
	if(diff!=0) begin
		if		(diff>=5 && quaters!=0) firstCoin=3'b101; 
		else if (diff>=2 && dimes!=0)   firstCoin=3'b010;
		else if (diff>=1 && nickels!=0) firstCoin=3'b001;
		else						    firstCoin=3'b000;
	end
	else firstCoin=0;
end

always_comb begin
	if(firstCoin!=0) begin
		if	    (diff-firstCoin>=5 && (quaters-(firstCoin[2]&firstCoin[0]))>0) secondCoin=3'b101;
		else if (diff-firstCoin>=2 && (dimes-firstCoin[1])>0) 	 			   secondCoin=3'b010;
		else if (diff-firstCoin>=1 && (nickels-(firstCoin[2]^firstCoin[0]))>0) secondCoin=3'b001;
		else												 			       secondCoin=3'b000;
	end
	else secondCoin=0;
end

assign diff 	       = (cost<paid & cost!=0) ? (paid-cost) :0;

assign exactAmount     = cost==paid & cost!=0;
assign notEnoughChange = (remaining==0)?0:1;
assign coughUpMore     = (cost>paid)?1:0;
assign remaining 	   = diff - (firstCoin==0?0:firstCoin) - (secondCoin==0?0:secondCoin);

endmodule

