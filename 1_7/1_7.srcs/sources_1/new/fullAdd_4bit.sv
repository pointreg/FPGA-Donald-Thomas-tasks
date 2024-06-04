module fullAdd_4bit (input logic [3:0] a,b, input logic cin, output logic [3:0] sum, output logic cout); //1.7. B task

fullAdd fullAdd1 (a[0],b[0],cin,sum[0],c1);
fullAdd fullAdd2 (a[1],b[1], c1,sum[1],c2);
fullAdd fullAdd3 (a[2],b[2], c2,sum[2],c3);
fullAdd fullAdd4 (a[3],b[3], c3,sum[3],cout);

endmodule