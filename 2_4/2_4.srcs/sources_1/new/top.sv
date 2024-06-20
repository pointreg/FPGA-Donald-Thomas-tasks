module top;

logic [10:0] year; //up to 2047 (7ff)
logic [3:0] month;
logic [5:0] dayOfMonth; // can be [4:0] 31=5'b1_1111
logic [8:0] dayOfYear;
logic isLeapYear;

DayOfYrCalc uut(.*);

initial begin
	dayOfMonth=25;
	month=3;
	for (int i = 0; i<=(2**$size(year))-2; i++) begin
	    year = i;
	    dayOfMonth = $urandom_range(31,1);
	    month = $urandom_range(12,1);
		#1;
		if (isLeapYear!=(year%4==0&&(year%100!=0||(year%400==0)))) $display("Oops year %d is(not) a leap year (isLeapYear=%b)", year, isLeapYear);
	end
	#10;
	$finish;
end

endmodule


module DayOfYrCalc (
input logic [5:0] dayOfMonth,
input logic [3:0] month,
input logic [10:0] year,
output logic [8:0] dayOfYear,
output logic isLeapYear);

parameter W=$size(year);
logic [W+(W-4)/3:0] bcd; 
logic [8:0] temp;

Bin2BCD_conv #(W) uut (.bin(year),.*);

assign isLeapYear = (year[1:0]==0 && //dividable by 4
(bcd[7:0]!=0 || //not dividable by 100
(bcd[7:0]==0 && //dividable by 100 and...
(bcd[12]? (bcd[11:8]==4'h2 | bcd[11:8]==4'h6) : (bcd[11:8]==0 | bcd[11:8]==4'h4 | bcd[11:8]==4'h8) ) ) ) ); //...  dividable by 400

always_comb begin

    unique case (month)
        4'b0001: temp = 0; 	 	//January 31
        4'b0010: temp = 5'd31 ; //February 28(29)
        4'b0011: temp = 6'd59 ; //March 31
        4'b0100: temp = 7'd90 ; //April 30
        4'b0101: temp = 7'd120; //May 31
        4'b0110: temp = 8'd151; //June 30
        4'b0111: temp = 8'd181; //July 31
        4'b1000: temp = 8'd212; //August 31
        4'b1001: temp = 8'd243; //September 30
        4'b1010: temp = 9'd273; //October 31
        4'b1011: temp = 9'd304; //November 30
        4'b1100: temp = 9'd334; //December 31
        default: temp = 9'h1FF; //error
    endcase
end

assign dayOfYear = temp!=9'h1FF ? (temp + (month>2?isLeapYear:0) + dayOfMonth) : 'b0;

endmodule
