module top;

logic [10:0] data = 11'b0101_1100_101, rcvd_msg; // 10100111010  0101_1100_101
logic clk=0, rst=0, data_in, crc_en=0;
logic [4:0] crc_out;
logic msg, data_out, msg_err;
logic done, OK;

always #1 clk=~clk;
  
transceiver dut (.*); //task 5_8
receiver dut2 (.*); //task 5_9
transceiver_TB tb (.*); //task 5_8
receiver_TB tb2 (.data_in(data_out),.*); //task 5_9
//crc_calc uut (.data_in(data_in),.*);

initial begin
	#1;
	rst = 1;
	#1;
	rst = 0;
end

endmodule


