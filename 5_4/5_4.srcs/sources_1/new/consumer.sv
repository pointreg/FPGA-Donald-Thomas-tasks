`include "pay_pkg.sv"
module consumer (input logic clk, rst, pPut, output pay_pkg::pay valueReceived, input logic [7:0] payload, output logic cFree);

enum bit {sA,sB} state;
logic [1:0] transPos2;

always_ff @(posedge clk, negedge rst) begin
	if(~rst) state <= sA;
	else begin
		if 	  (state == sA & pPut)    state <=sB;
		else if (state == sB & ~pPut) state <=sA;
	end
end

always_ff @(posedge clk, negedge rst) begin
	if(~rst)  begin transPos2 <='b0; end 
	else begin
		if (~pPut)     begin transPos2 <= 0; end
		else if (pPut) begin transPos2 <= transPos2 + 1; end
	end
end

always_comb begin
    if (~pPut) valueReceived = 0;
    else 
	case (transPos2)
		2'b00: valueReceived.a = payload;
		2'b01: valueReceived.b = payload;
		2'b10: valueReceived.c = payload;
		2'b11: valueReceived.d = payload;
		default: valueReceived = 0;
	endcase
end

assign  cFree   = state == sA || (state == sB & ~pPut);

endmodule