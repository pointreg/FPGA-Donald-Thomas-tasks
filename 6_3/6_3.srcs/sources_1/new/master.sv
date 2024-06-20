interface MasterThread (FastBus.M m);
//(input clock, resetN, master_ans,
//input dataReady, //from mem
//inout tri [15:0] data, address, 
//output tri start, read, master_req, read_req);

logic M_R_req=0, M_req=0;
logic [15:0] DataReg=0, AddrReg=0;
enum {IDLE, R, W} State, NextState;

always_ff @(posedge m.clock, negedge m.resetN) begin
    if(~m.resetN) begin
        State <= IDLE;
    end
    else begin
        State <= NextState;
    end
end

always_comb begin
    NextState   = M_req?(M_R_req?R:W):IDLE;
end

assign  m.master_req = M_req?1:'bz,
        m.read_req   = M_R_req?1:'bz,
        
        m.start      = (State!=IDLE & m.master_ans)?1:0,
        m.address    = (State!=IDLE & m.master_ans)?AddrReg:'bz,
        m.data       = (State==W & m.master_ans)?DataReg:'bz,
        m.read       = (State==R & m.master_ans)?1:0;
        
modport proc_cmnd(import WriteMem, ReadMem, Listen);

task WriteMem 
(input [15:0] Avalue,
input [15:0] Dvalue);
    begin
        M_req   <= 1;
        @(posedge m.clock);
        wait (m.master_ans);
        AddrReg <= Avalue;
        DataReg <= Dvalue;
        M_req   <= 0;
    end
endtask
    
task ReadMem
(input [15:0] Avalue);
    begin         
        M_req   <= 1;
        M_R_req <= 1;
        @(posedge m.clock);
        wait (m.master_ans);
        AddrReg <= Avalue;
        M_req   <= 0;
        M_R_req <= 0;
    end
endtask 

task Listen 
(output [15:12] Avalue,
output [15:0] Dvalue);
    begin
        wait (m.dataReady);
        Avalue  <= AddrReg[15:12];
        Dvalue  <= DataReg;
        @(posedge m.clock);
    end
endtask

endinterface: MasterThread
