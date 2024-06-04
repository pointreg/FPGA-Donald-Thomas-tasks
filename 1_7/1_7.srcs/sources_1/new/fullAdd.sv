module fullAdd(input logic a,b,cin, output logic sum, cout); // 1.7. A task

xor(sum,a,b,cin);
and(ab,a,b),(ac,a,cin),(bc,b,cin);
or(cout,ab,ac,bc);

endmodule