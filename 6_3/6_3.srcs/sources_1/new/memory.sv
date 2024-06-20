interface MemThread #(bit [3:0] page_addr=4'h0) (FastBus.S s);
//(input clock, resetN, slave_ans, start, read,
//inout tri [15:0] data, address,
//output slave_req, dataReady);


logic [15:0] Mem [12'hFFF:0], MemData, AddrReg;
logic ld_Addr, memDataAvail=0, en_Data, ld_Data, dv;
//logic [15:0] DataReg;
enum {SA,SB,SC,SD} State, NextState;

initial begin
    MemInit; 
    forever begin
        @(State) begin
            bit [1:0] delay;
            memDataAvail <= 0;
                if(State == SC) begin
                    delay = $random;
                    repeat (1+delay) @(posedge s.clock);
                    memDataAvail <= 1;
                    wait(s.slave_ans[page_addr]);
                end
        end
    end
end

assign s.address                = (en_Data)?{page_addr,12'bz}:'bz;
assign s.data                   = (en_Data)?MemData:'bz;
assign s.dataReady              = (State==SC)?dv:1'bz;
assign s.slave_req [page_addr]  = memDataAvail?1:'bz; //replace to number of slave

always_comb begin
     AddrReg = (ld_Addr)?s.address:AddrReg;
     MemData = (ld_Addr)?Mem[AddrReg[11:0]]:MemData;
 end
         
always_ff @(posedge s.clock) begin
    if(ld_Data) begin
        //DataReg         <= s.data;
        Mem [AddrReg[11:0]]   <= s.data;
        $display($time, ", Mem [AddrReg[11:0]]=%h, s.data=%h", Mem [AddrReg[11:0]], s.data);
    end
end

always_ff @(posedge s.clock, negedge s.resetN)
    if(~s.resetN) State <= SA;
    else          State <= NextState;

always_comb begin
ld_Addr   = 0;
dv        = 0;
en_Data   = 0;
ld_Data   = 0;

    case (State)
        SA: begin
                NextState   = (s.start & s.address[15:12]==page_addr & s.read)?SC:SA; 
                ld_Addr     = (s.start & s.address[15:12]==page_addr)?1:0;
                ld_Data     = (s.address[15:12]==page_addr & ~s.read)?1:0;
            end
//        SB: begin
//                NextState = (read)?SC:SD;
//                ld_AddrLo = 1;
//            end
        SC: begin //read
                NextState   = (memDataAvail & s.slave_ans[page_addr])?SA:SC;
                dv          = (memDataAvail & s.slave_ans[page_addr])?1:'bz;
                en_Data     = (memDataAvail & s.slave_ans[page_addr])?1:0;
            end
    endcase
end

modport mem_cmnd(import MemInit);

task MemInit;
    begin
        for(int i=0; i<$size(Mem); i++)
            Mem[i]=$size(Mem)-i[15:0];
    end
endtask: MemInit

endinterface: MemThread
