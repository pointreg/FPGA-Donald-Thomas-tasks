module receiver(input logic clk, rst, msg_err, crc_en, output logic done, OK, output logic [10:0] rcvd_msg);
        
crc_calc uut (.data_in(msg_err),.crc_out(),.*);

logic [5:0] cntr;
logic [10:0] temp;

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin 
        cntr <= 0;
        temp <= 0;
    end
    else begin
        if (crc_en && cntr<=11) begin
            cntr <= cntr + 1;
            temp [10-cntr] <= msg_err;
        end
        else if (~crc_en) begin
            cntr <= 0;
            temp <= 0;
        end
    end
end
assign  rcvd_msg = cntr>=11?temp:'bz;

    
endmodule: receiver
