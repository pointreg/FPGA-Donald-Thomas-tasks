module top;

logic clk=0, reset=0, x, y, z;

p3_5_TB tb (.*);

always #5 clk=~clk;

initial begin: I
    reset <= #1 1;
end 

endmodule: top