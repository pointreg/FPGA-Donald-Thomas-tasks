module top;

logic [6:0] code;
logic is_cap, is_lc, is_num, is_printable;

charType uut (.*);

initial begin
	$display ("code		is_cap	is_lc	is_num	is_printable");
	$monitor ("code=%h:	%b\t	%b\t	%b\t	%b", code, is_cap, is_lc, is_num, is_printable);
	for(int i = 0; i<=126; i++) #1 code=i;
	#10;
	$finish;
end

endmodule

module charType (input logic [6:0] code, output logic is_cap, is_lc, is_num, is_printable);

always_comb begin
	if 	    (code>=7'h41 & code<=7'h5A) {is_cap, is_lc, is_num, is_printable}=4'b1000; //capital
	else if (code>=7'h61 & code<=7'h7A) {is_cap, is_lc, is_num, is_printable}=4'b0100; //lowercase
	else if (code>=7'h30 & code<=7'h39) {is_cap, is_lc, is_num, is_printable}=4'b0010; //number 
	else if (code>=7'h20 & code<=7'h7e) {is_cap, is_lc, is_num, is_printable}=4'b0001; //printable 
	else 								{is_cap, is_lc, is_num, is_printable}=4'b0000; //other 
end

endmodule