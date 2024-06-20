module transceiver 
(input clk, rst, msg, crc_en,
output logic data_out, //done, OK,
output logic [4:0] crc_out);
    
logic [5:0] counter, cntr;

crc_calc uut (.data_in(data_out),.done(),.OK(),.*);

assign cntr       = counter + 1;
assign data_out   = (cntr>=12 & cntr<=16)?~crc_out[16-cntr]:msg;
     

always_ff @ (posedge clk, posedge rst) begin
    if (rst) counter <= 0;
    else begin
        if(crc_en) counter <= cntr;
        else       counter <= 0;
    end
end
    
endmodule: transceiver