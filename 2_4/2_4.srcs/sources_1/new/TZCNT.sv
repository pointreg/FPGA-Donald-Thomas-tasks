module TZCNT #(parameter N=8)(
input logic [N-1:0] x,
output logic [$clog2(N)-1:0] c); // Count the Number of Trailing Zero Bits

logic [N-1:0] t=0;
bit [N-1:0] temp [0:$clog2(N)-1];

bit [64-1:0] mask [0:5] = '{
64'h5555555555555555,
64'h3333333333333333,
64'h0F0F0F0F0F0F0F0F,
64'h00FF00FF00FF00FF,
64'h0000FFFF0000FFFF,
64'h00000000FFFFFFFF
};

always_comb begin
	t = ~x & (x - 1);  //# mask where all the trailing zeroes are now 1s
	temp [0] = t - ((t >> 1) & mask [0]);  //# count 1s in the mask

		for (int i=1;i<$clog2(N);i++) begin
			temp [i] = (temp [i-1] & mask [i]) + ((temp [i-1] >> 2**i) & mask [i]);
		end
end
assign c=temp[$clog2(N)-1][N-1:0];


//bit [N-1:0] q=0;
//initial begin
//	x = 0;
//	#1;
//	$display("x=%b, c=%d",x,c);
//	for (x = 1; x!=0; x++) begin
//		#1;
//		q [N-1:0] = x<<(N-c);
//		if(q!=0 && (x[c]!=0 && c!=0)) $monitor("Opps, x[c-1:0]!=0 at x=%b, c=%d, %b",x,c, q);
//	end
//	$finish();
//end

endmodule


//https://stackoverflow.com/questions/25757415/bit-shifting-until-first-1-in-a-bit-string
//t = ~x & (x - 1)  # mask where all the trailing zeroes are now 1s
//c = t - ((t >> 1) & 0x55555555)  # count 1s in the mask
//c = (c & 0x33333333) + ((c >> 2) & 0x33333333)
//c = (c & 0x0F0F0F0F) + ((c >> 4) & 0x0F0F0F0F)
//c = (c & 0x00FF00FF) + ((c >> 8) & 0x00FF00FF)
//c = (c & 0x0000FFFF) + ((c >> 16) & 0x0000FFFF)
//result = x >> c   # shift right by the number of trailing zeroes