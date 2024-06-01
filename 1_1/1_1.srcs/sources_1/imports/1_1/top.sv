module top;

logic a,b,c,f;
trueBoole uut(.*);
trueBoole_TB tb (.*);

endmodule


module trueBoole 
(output logic f, 
input logic a,b,c);

nor(f,f1,f2,f5);

or(f2,f3,f4,f5);
not(f1,a);
xor(f3,a,f1);
and(f4,f3,c,a,b),(f5,a,c);
//same as assign f=0; 

endmodule

module trueBoole_TB (output logic a,b,c, input logic f);

initial begin
    for (bit [3:0] i=0; i<=3'b111; i++)
        #1 {a,b,c} = i;
    #1 $finish;
end

endmodule