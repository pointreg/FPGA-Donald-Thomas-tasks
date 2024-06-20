module top;
logic clk=0, in=0, rst=0, valid;

always #1 clk=~clk;

tooFewOnes uut (.*);
tooFewOnes_TB tb (.*);
	
initial begin
    #5 rst=1;
end

endmodule