parameter MAX_DELAY_BTW_SEQ = 5;
parameter MAX_LENGTH_SEQ = 20;

module top;

logic ck=0, reset_l=1, go_l=1;
logic [15:0] inA;
logic done, error; //error
logic [15:0] sum=0;
 
always #1 ck=~ck;

sumItUp uut (.*);
sumItUp_TB tb(.*);

//property & assert section// task 9.3.
property A_prop;
    @(posedge ck) (done or error) |-> ((done and !error) or (!done and error)) ;
endproperty
property B_prop;
bit [16:0] temp=0;
    @(posedge ck) (go_l ##1 ~go_l, temp=inA) |=> (temp+inA<=16'hFFFF,temp+=inA)  [*0:MAX_LENGTH_SEQ] ##1 ((error && (temp+inA>16'hFFFF)) or (done && (temp+inA<=16'hFFFF)));
endproperty
property C_prop;
    @(posedge ck) ~error ##1 error |=> error throughout go_l[*1:$];
endproperty

assert property (A_prop) else $error("(A) oops, done and error at same time");
assert property (B_prop) else $error("(B) oops, no correct error flag");
assert property (C_prop) else $error("(C) oops, error has not held until go_l");
//end of property & assert section//

initial begin
    #1 reset_l=0;
    #3 reset_l=1;
end
endmodule

