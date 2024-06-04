module task_1_3 (input logic a,b,c,d,e, output logic f,g);

nand #5 (f1,b,c),(f5,~f1,d),(f6,f1,c);
or #4(f3,c,e);
and #4(f2,a,f1),(f4,f2,~f1);
and #6(g,~d,~e,f3,f6);
xor #6(f,f4,f5,~f3);

endmodule