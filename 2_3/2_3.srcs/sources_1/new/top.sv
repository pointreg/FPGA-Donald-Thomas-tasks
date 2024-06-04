typedef enum bit [1:0] {ADD=2'b00, AND=2'b01, OR=2'b10, XOR=2'b11} aluInst_t;

module top;

parameter W = 3;

logic signed [W-1:0] result, a, b;
logic cIn, cOut, N, Z, V;
aluInst_t fn;

ALU #(W) uut (.*);

initial begin
    a = 0;
    b = 0;
    cIn = 0;
	fn=fn.first;
	$monitor($time, "(pref)sec, %d %s %d (+ %b)=%d, cOut=%b, [Z,N,V]=[%b,%b,%b]",a,fn.name,b,cIn,result,cOut,Z,N,V);
	
	for(int k=0; k<=1; k++) begin //cIn
		for (int i = -(2**(W-1)-1); i<=(2**(W-1)-1); i++) begin //a
			for (int j = -(2**(W-1)-1); j<=(2**(W-1)-1); j++) begin //b
			    a = i;
			    b = j;
			    cIn = k;
				#1;
				if ((a+b+$signed({1'b0,cIn}))==0 && Z!=1) $display ("oops, Z!=0"); //zero check
				
				if (((-a)+(-b)-$signed({1'b0,cIn})>(2**(W-1)-1))) begin //overflow check (valid only for negative numbers)
				    if(V!=1 && N!=1) $display ("oops, V!=1 && N!=1");
				end
				else begin
				    if ((a+b+$signed({1'b0,cIn})!= result+$signed({1'b0,cOut,{W-1{1'b0}}}))) $display ("oops, error calc");
				end
			end
		end
	end	
	
    for(aluInst_t k=AND; k!=k.first; k=k.next) begin // bit logical operations check
		for (int i = -(2**(W-1)-1); i<=(2**(W-1)-1); i++) begin
			for (int j = -(2**(W-1)-1); j<=(2**(W-1)-1); j++) begin
			    a = i;
			    b = j;
			    fn = k;
				#1;
				case (fn)
                    AND: if (((a&b)!=result)) $display ("oops, (and)%b %s %b != %b", a, fn.name, b, result);
                    OR:  if (((a|b)!=result)) $display ("oops, (or)%b %s %b != %b",  a, fn.name, b, result);
                    XOR: if (((a^b)!=result)) $display ("oops, (xor)%b %s %b != %b", a, fn.name, b, result);
				endcase
			end
		end
	end
	
    $finish;
end

endmodule: top



module ALU #(parameter width = 2)(
input aluInst_t fn,
input logic cIn,
input logic signed [width-1:0] a,b,
output logic signed[width-1:0] result,
output logic cOut, N, Z, V
);
logic signed [width:0] temp=0;

always_comb begin
temp = a + b + $signed({1'b0,cIn});
unique case (fn)
	ADD: begin
		result = {temp[width],temp[width-2:0]}; 
		end
	AND: begin
		result = a & b;
		end
	OR:  begin
		result = a | b;
		end
	XOR: begin
		result = a ^ b;
		end
endcase


end

assign Z = {V,cOut,result}==0?1:0;
assign N = result[width-1]?1:0;
assign V = ((fn==ADD) && ((-a)+(-b)-$signed({1'b0,cIn})>(2**(width-1)-1))) ? 1 : 0;
assign cOut = (fn==ADD && ~temp[width])?temp[width-1]:0;


endmodule: ALU


