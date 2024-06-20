module mem #(parameter DW = 16, W = 256, AW = $clog2(W)) (memInterface.mM mem); 
//(input logic re, we, clk, 
//input logic [AW-1:0] Addr,
//inout tri [DW-1:0] Data);

logic [DW-1:0] M[W];
logic [DW-1:0] out;

initial
	for (int i = 0; i < W; i++)
		M[i] = i;
		
assign mem.Data = (mem.re) ? out: 'bz;

always @(posedge mem.clk)
	if (mem.we) M[mem.Addr] <= mem.Data;
	
always_comb
	out = M[mem.Addr];

endmodule: mem