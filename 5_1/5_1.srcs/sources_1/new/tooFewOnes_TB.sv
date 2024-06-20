program tooFewOnes_TB (input logic clk, rst, valid, output logic in);

bit [5:0] i;

/* 
//task 9.1. (concurrent assertion)
property bit2of5;
bit [2:0] ones_cntr;
	@(posedge clk) disable iff (~rst)
		(top.uut.fivesCounter==0, ones_cntr=in) |=> (~valid, ones_cntr=ones_cntr+in)[*3] ##1 (ones_cntr+in==2 & valid);
endproperty

assert property (bit2of5) else $error ("oops, seq = %4b, %d, valid=%0b", i[4:0], top.uut.fivesCounter, valid);  //(concurrent assertion)
*/

initial begin
    @(posedge rst)
    for (i=0; i<=5'b11111; i++) begin: loop
        check: assert ((i[4]+i[3]+i[2]+i[1]+i[0])==2) 
        begin // task 9.1. (immediate assertion)
            in=i[0];
            #2;
            in=i[1];
            #2;
            in=i[2];
            #2;
            in=i[3];
            #2;
            in=i[4];
            #2;
            //if ((i[4]+i[3]+i[2]+i[1]+i[0])==2 && ~valid) $display("oops, i=%b, valid=%b",i,valid);
        end
        else $error ("oops, seq(%b) hasn`t 2 one bits", i[4:0]); 
    end: loop
    $stop;
end

endprogram