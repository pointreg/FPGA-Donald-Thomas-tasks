module top;
logic clock=1, resetN=0;

always #5 clock=~clock;
initial #2 resetN=1;

SimpleBus MS(clock, resetN);

ProcInitThread M (MS.M);
MemInitThread #(4'h0) S1 (MS.S); //# - 4bit page's address
MemInitThread #(4'h1) S2 (MS.S); //# - 4bit page's address

TBProc tbp (MS.M, M);
TBMem tbm1 (MS.S, S1);
TBMem tbm2 (MS.S, S2);

endmodule: top

interface SimpleBus(input clock, resetN);
tri dataValid, start, read;
tri [7:0] data, address;

modport M ( input clock, resetN,
            inout data, dataValid,
            output start, read, address);
modport S ( input clock, resetN,
            inout data, dataValid,
            input start, read, address);        

endinterface: SimpleBus
