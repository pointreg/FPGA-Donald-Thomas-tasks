program receiver_TB
(input logic clk, rst, crc_en, data_in,
output logic msg_err);

logic [5:0] cntr = 0, t1=20, t2=20, t3=20;
initial begin
    @(negedge rst);
    @(posedge clk);
    forever begin
       //t1 = cntr==0?$urandom_range(0,5):t1; //uncomment to add error in 
       //t2 = cntr==0?$urandom_range(6,10):t2; //uncomment to add error in 
       //t3 = cntr==0?$urandom_range(0,10):t3; //uncomment to add error in 
       cntr = (cntr==16) || ~crc_en?0:(cntr+1); 
       @(posedge clk); 
    end
end

assign msg_err = (cntr==t1 || cntr==t2|| cntr==t3)?~data_in:data_in;
 
endprogram: receiver_TB
