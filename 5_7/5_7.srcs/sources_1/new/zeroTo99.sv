module zeroTo99
(input logic ck, r, countEnable, // countEnabe для первой декады
output logic carryOut, // перенос из декады десятков
output logic [3:0] DCBA10, DCBA1); // выходы FF двух декад

logic cout1;

decadeCTR count_1 (.DCBA(DCBA1),.carryOut(cout1),.*);
decadeCTR count_2 (.DCBA(DCBA10),.countEnable(cout1),.*);

endmodule: zeroTo99

