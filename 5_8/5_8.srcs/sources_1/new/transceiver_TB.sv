program transceiver_TB
(input clk, rst,
input [10:0] data,
output logic msg, crc_en);

logic [10:0] message; 
    
initial begin
    @(negedge rst);
    $monitor($time, ", message=%b, current crc = %b, crc_en=%b", message, top.dut.uut.lfsr_c, crc_en);
    repeat ($urandom_range(20,50)) begin //number of messages
        sendMsg(); //put data as argument to send data, otherwise random sequence 
        repeat (5) @(posedge clk); //waiting for msg+crc will be transmitted
        crc_en = 0;
        $display("[END OF MESSAGE]\n");
        //repeat ($urandom_range(0,3)) @(posedge clk); //add random delay before next msg
    end 
    @(posedge clk); 
    @(posedge clk);
	$finish();
end


task sendMsg(input logic [10:0] data=0);
    message  = (data==0)?$random():data;
    for (int i = 10; i>=0; i--) begin
        @(posedge clk);
        crc_en <= 1;
        msg = message[i];
    end
    @(posedge clk);
    msg = 'bz;
endtask: sendMsg

endprogram: transceiver_TB