module findMax (input logic start,
input logic [7:0] inputA,
output logic done,
output logic [7:0] maxValue=0, minValue=255,
output logic [2:0] crc,
input logic clk, rst);

logic [7:0] max, min;
enum bit {sA,sB} state, NextState;

parameter N=3;
logic [7+N:0] crcSum;
logic [N:0] crcPolynom = 4'b1011;
logic [N-1:0] crcTemp;

assign done = state==sB & ~start;
assign max = (inputA>=maxValue)?inputA:maxValue; //control point
assign min = (inputA<=minValue)?inputA:minValue; //control point
assign crcTemp=crcSum[7+N:8];

always_comb begin: crc_calc
	crcSum={inputA,3'b0};
	for(int i=0; i<=7; i++) begin 
		crcSum=crcSum[7+N]?{crcSum[7+N:7]^crcPolynom,crcSum[6:0]}<<1:crcSum<<1;
	end
end: crc_calc

always_ff @(posedge clk, posedge rst) begin
	if(rst)
		state<=sA;
	else begin
	   if(start) state <= sB;
	   else      state <= sA;
	end
end

always_ff @(posedge clk, posedge rst) begin
	if(rst) begin minValue <=8'b11111111; maxValue <= 0; crc <= 0;  end
	else begin
		if (start) begin 
			maxValue <= max;
			minValue <= min;
			crc      <= crcTemp;
		end
		else begin 
            maxValue <= 0; 
            minValue <= 8'b11111111; 
            crc      <= 0; 
		end
	end
end

endmodule: findMax