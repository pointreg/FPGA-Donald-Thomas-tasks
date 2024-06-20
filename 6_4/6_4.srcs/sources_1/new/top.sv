typedef struct {
bit [15:0] data1;
bit [15:0] data2;
bit [15:0] data3;
bit [15:0] data4;
} dt;

module top;
logic reset=1, clk=0;
always #1 clk=~clk;

procInterface p_i (.*);
memController #(8'h02) duu1 (p_i.slave);
memController #(8'h03) duu2 (p_i.slave);
// (.addrData(p_i.slave.addrData), .addrValid(p_i.slave.addrValid), .rw(p_i.slave.rw), .clk(p_i.slave.clk), .reset(p_i.slave.reset));
top_TB tb (p_i.master);

initial begin
    reset = 1;
    #5 reset = 0;
end
endmodule: top

program top_TB (procInterface M);
bit [7:0] temp;
bit [15:0] temp2;
    
initial begin
    wait (~M.reset);
    @(posedge M.clk);
    repeat($urandom_range(5,10)) begin
        temp = $urandom();
        temp2 = {8'h02,temp};
        M.sendit(temp2,1); //read
        M.sendit(temp2,0); //write
        M.sendit(temp2,1); //read
    end
        M.sendit({8'h02,8'hA},0);
        M.sendit({8'h02,8'hA},1);
        @(posedge M.clk);
    $finish;
end
endprogram: top_TB

interface procInterface (input logic reset, clk);
// (parameter logic [7:0] page = 8'h02)
tri [15:0] addrData;
logic addrValid = 'bz, rw=0;
bit [15:0] tempAddr;
bit send, RW;
dt data_pack;

assign addrData = addrValid || send?tempAddr:'bz;

modport master (inout addrData,
input clk, reset,
output addrValid, rw,
import sendit);

modport slave (inout addrData,
input clk, reset, addrValid, rw);

task sendit(input logic [15:0] address, input logic RW=1);
    tempAddr = address;
    rw       = RW;
    addrValid= 1;
    if(~rw) begin
        @(posedge clk);
        send = 1;
        rw   = 0;
        addrValid = 0;
        
        data_pack.data1 = $urandom();
        data_pack.data2 = $urandom();
        data_pack.data3 = $urandom();
        data_pack.data4 = $urandom();
        
        tempAddr = data_pack.data1;
        @(posedge clk);
        tempAddr = data_pack.data2;
        @(posedge clk);
        tempAddr = data_pack.data3;
        @(posedge clk);
        tempAddr = data_pack.data4;
    end
    else begin
        @(posedge clk);
        send = 0;
        rw   = 0;
        addrValid<= 0;
        data_pack.data1 <= addrData;
        @(posedge clk);
        data_pack.data2 <= addrData;
        @(posedge clk);
        data_pack.data3 <= addrData;
        @(posedge clk);
        data_pack.data4 <= addrData;
    end
    @(posedge clk);
    send = 0;
    
endtask

endinterface: procInterface