parameter MAX_DELAY_BTW_SEQ = 5;
parameter MAX_LENGTH_SEQ = 20;

module top;
logic start=0, done, clk=0, rst=1;
logic [7:0] inputA=0, maxValue, minValue;
logic [2:0] crc;

always #1 clk=~clk;

findMax uut (.*);
findMax_TB tb (.*); // tasks 7.6. 10.3 10.4

begin: assertion_section //task 9.2.
//property & assert section// 
property A_prop;
    @(posedge clk) rst |-> maxValue==0;
endproperty

property B_prop;
    @(posedge clk) (rst ##1 !rst) |-> (!rst and !done)[*0:MAX_DELAY_BTW_SEQ] ##1 (start and !done);
endproperty

property C_prop;
    @(posedge clk) done |=> maxValue==0;
endproperty

property D_prop; //error in task description. maxValue==0 until start + 1clk, not till  inputA!=0
    @(posedge clk) (rst ##1 !rst) or (done ##1 !done) |-> (maxValue==0) [*1:MAX_DELAY_BTW_SEQ] ##1 (start and inputA);
endproperty

property E_prop;
    @(posedge clk)  start |-> ~done;
endproperty

property F_prop;
    @(posedge clk) (start ##1 ~start) |-> done;
endproperty

property G_prop;
    bit [7:0] mvalue;
    @(posedge clk) (!start ##1 (start,mvalue=inputA)) |-> (start, mvalue=mvalue<inputA?inputA:mvalue)[*1:MAX_LENGTH_SEQ] ##1 (done && mvalue==maxValue);
endproperty

assert property(A_prop) else $error("(A) oops, rst doen't work, maxValue=%d", maxValue);
assert property(B_prop) else $error("(B) oops, start is not before done, after rst");
assert property(C_prop) else $error("(C) oops, maxValue is not zero value after done is set");
assert property(D_prop) else $error("(D) oops, maxValue is not zero value after rst or done until start +1 lck");
assert property(E_prop) else $error("(E) oops, done is set while start");
assert property(F_prop) else $error("(F) oops, there is no done after start fell");
assert property(G_prop) else $error("(G) oops, maxValue is not correct");
//end of property & assert section//
end: assertion_section

initial begin
    #5 rst = 0;
end
endmodule
