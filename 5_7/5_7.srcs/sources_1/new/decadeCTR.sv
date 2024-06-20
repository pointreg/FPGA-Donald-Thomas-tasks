module decadeCTR
(input logic ck, r, countEnable,
output logic carryOut,
output logic [3:0] DCBA);

logic [3:0] counter;
logic cout;

always_ff@ (posedge ck, negedge r) begin
	if (~r) {carryOut,DCBA} <=0;
	else begin
		if (countEnable) {carryOut,DCBA} <= {cout,counter};
		else             {carryOut,DCBA} <= {1'b0,DCBA};
	end
end

assign  counter  = (DCBA < 4'b1001)?(DCBA + 1):0,
        cout     = (DCBA == 4'b1001);

endmodule: decadeCTR