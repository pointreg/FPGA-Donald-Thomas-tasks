module top;

logic [3:0] a, b, sum;
logic carryIn, carryOut;

bcdAdd uut(.*);

initial begin
	for (int k = 0; k<=1; k++)
		for (int i = 0; i<=4'b1001; i++) 
			for (int j = 0; j<=4'b1001; j++) begin
                carryIn = k;
                a = i;
                b = j;
                #1;
                if (((carryIn+a+b)>9) ?!((carryIn+a+b-10)==sum && carryOut):!((carryIn+a+b)==sum && !carryOut)) $display("oops (carryIn+a+b!=(carryOut)sum) %b+%d+%d!=(%b)%d",carryIn,a,b,carryOut,sum);
            end
    $finish;
end

endmodule: top

//  BCD 8421
// 4'b0000 //0
// 4'b0001 //1
// 4'b0010 //2
// 4'b0011 //3
// 4'b0100 //4
// 4'b0101 //5
// 4'b0110 //6
// 4'b0111 //7
// 4'b1000 //8
// 4'b1001 //9
