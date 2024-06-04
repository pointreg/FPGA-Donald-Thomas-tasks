module top;

logic a,b,c,d;
fourBitTest tb (.*);

endmodule


module fourBitTest (output logic a,b,c,d);

initial begin
	$monitor($time,", {d,c,b,a} = %b", {d,c,b,a});
    for (bit [5:0] i = 0; i<=4'b1111; i++) begin
        {d,c,b,a} = i;
        #1; 
    end
    $finish();
end

endmodule
