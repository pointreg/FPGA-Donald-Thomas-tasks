module bcdAdd
(input logic [3:0] a,b,
input logic carryIn,
output logic [3:0] sum,
output logic carryOut);

logic [3:0] sum1;
logic co, co1;

fullAdd_4bit add1 (a,b,carryIn,sum1,co);
fullAdd_4bit add2 ({1'b0,carryOut,carryOut,1'b0},sum1,1'b0,sum,co1);

and(q1,sum1[3],sum1[2]),(q2,sum1[3],sum1[1]);
or(carryOut,co,q1,q2);


endmodule: bcdAdd