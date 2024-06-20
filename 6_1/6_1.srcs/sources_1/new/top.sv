module top;

logic clock=0, resetN=0;
tri dataValid, start, read;
tri [7:0] data, address;

always #5 clock=~clock;
initial #2 resetN=1;

ProcInitThread M (.*);
MemInitThread #(4'h0) S1 (.*); //# - 4bit page's address
MemInitThread #(4'h1) S2 (.*); //# - 4bit page's address

endmodule: top