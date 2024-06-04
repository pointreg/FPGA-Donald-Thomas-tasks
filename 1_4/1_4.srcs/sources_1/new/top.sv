module top;

logic a,b,c,d,e,f,g;
fourBitTest tb (.*);

endmodule


module fourBitTest (output logic a,b,c,d,e,f,g);

task_1_3 uut (.*);

initial begin
	$monitor($time,", Inputs {e,d,c,b,a} = %b, Outputs {g,f} = %b", {e,d,c,b,a}, {g,f});
    for (bit [6:0] i = 0; i<=5'b11111; i++) begin
        {e,d,c,b,a} = i;
        #1; 
    end
    $finish();
end

endmodule
