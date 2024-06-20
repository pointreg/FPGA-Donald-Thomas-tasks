`include "pay_pkg.sv"
module producer (input logic clk, rst, cFree, input pay_pkg::pay valueToSend, output logic [7:0] payload, output logic pPut);

enum bit {sA,sB} state;
logic [1:0] transPos;

always_ff @(posedge clk, negedge rst) begin
	if(~rst) state <= sA;
	else begin
		if (state == sA & cFree) state <=sB;
		else if (transPos == 3)  state <=sA;
	end
end

always_ff @(posedge clk, negedge rst) begin
	if(~rst)  begin transPos <=0; end 
	else begin
		if (state == sA & cFree) begin transPos <= 0; end
		else if (pPut) begin transPos <= transPos + 1; end
	end
end

always_comb begin
    if (!pPut) payload = 'bz;
    else
	case (transPos)
		2'b00: payload = valueToSend.a;
		2'b01: payload = valueToSend.b;
		2'b10: payload = valueToSend.c;
		2'b11: payload = valueToSend.d;
		default: payload = 'bz;
	endcase
end

assign pPut = state == sB;

endmodule