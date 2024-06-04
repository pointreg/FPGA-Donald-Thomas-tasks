module top;
logic a,b,y;
norTest tb (.*);
endmodule


module norTest (output logic a,b,y);
logic t1 [4] = '{1'b0,1'b1,1'bx,1'bz};

nor(y,a,b);

initial begin
	$display("[NOR gate test for 4-state variable] Inputs (a,b), output (y)\n|  a  |  b  |  y  |");
	foreach(t1[j]) begin
        foreach(t1[i]) begin
            {a,b} = {t1[j],t1[i]};
            #1; 
            $display("|  %b  |  %b  |  %b  |", a,b,y);
        end
    end
    $finish();
end

endmodule