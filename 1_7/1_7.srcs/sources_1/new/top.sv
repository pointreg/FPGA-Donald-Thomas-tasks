module top;

logic [3:0] a, b, sum;
logic cin, cout;

fullAdd_4bit fa4 (.*);
fullAdd_4bit_TB tb (.*);

endmodule

module fullAdd_4bit_TB (output logic [3:0] a,b, output logic cin, input logic [3:0] sum, input logic cout);

initial begin
    $monitor($time, ", cin=%b + a=%b + b=%b = sum=%b, cout=%b", cin, a, b, sum, cout);
    for(bit [9:0] i=0; i<=9'b111111111; i++) begin
        {cin,a,b} = i;
        #1;
        if(cin+a+b!={cout,sum}) $display("oops, %d+%d+%d!=%d", cin,a,b,{cout,sum});
    end
    $finish;
end
endmodule