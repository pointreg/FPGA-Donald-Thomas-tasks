`include "pay_pkg.sv"
 
module top;
 
import pay_pkg::*;

logic clk=0, rst=1, cFree, pPut;
logic [7:0] payload;

always #1 clk=~clk;
pay valueToSend, valueReceived;

producer uut (.valueToSend(valueToSend),.*);
consumer uut2 (.valueReceived(valueReceived),.*);
top_TB tb (.valueToSend(valueToSend),.*);

///**property & assert section**/// task 9.4.
property A_prop;
    @(posedge clk) (!rst ##1 rst) |-> ~pPut && cFree [*1:$] ##1 pPut;
endproperty
property B_prop;
    @(posedge clk) cFree && ~pPut |=> (pPut && cFree) [*1] |=> pPut && ~cFree;
endproperty

assert property (A_prop) else $error("(A) oops, cFree isn't first after rst");
assert property (B_prop) else $error("(B) oops, cFree and pPut in wrong order");
///**end of property & assert section**///

initial begin
	#1 rst = 0;
	#1 rst = 1;
end

endmodule