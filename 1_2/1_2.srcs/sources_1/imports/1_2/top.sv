module top;
localparam outSize = 4;
logic [outSize-1:0] abcd;
fourBitTest #(outSize) tb (.*);

endmodule


module fourBitTest #(parameter outSize = 4) (output logic [outSize-1:0] abcd); //task 1.2./7.1.

initial begin
	$monitor($time,", abcd = %b", abcd);
    for (bit [outSize:0] i = 0; i<=2**(outSize)-1; i++) begin
        abcd = i;
        #1; 
    end
    $finish();
end

endmodule
