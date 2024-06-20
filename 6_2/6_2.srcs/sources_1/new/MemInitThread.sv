module TBMem (SimpleBus.S s, MemInitThread v);
    initial begin
        v.MemInit; 
    end
    always @(v.State) begin
        bit [2:0] delay;
        v.memDataAvail <= 0;
            if(v.State == v.SC) begin
                delay = $random;
                repeat (2+delay)
                    @(posedge s.clock);
                v.memDataAvail <= 1;
            end
    end
endmodule: TBMem

interface MemInitThread #(bit [3:0] page_addr=4'h04)(SimpleBus.S s);
//(
//input logic clock, resetN,
//input logic start, read,
//inout logic dataValid,
//input logic [7:0] address,
//inout logic [7:0] data);

logic [7:0] Mem [16'hFFFF:0], MemData;
logic ld_AddrUp, ld_AddrLo,
      memDataAvail=0, en_Data, ld_Data, dv;
logic [7:0] DataReg;
logic [15:0] AddrReg;

enum {SA,SB,SC,SD} State, NextState;

modport mem_cmnd(import MemInit);
task MemInit;
    begin
        for(int i=0; i<16'hFFFF; i++)
            Mem[i]=i[7:0];
    end
endtask: MemInit

assign s.data = (en_Data)?MemData:'bz;
assign s.dataValid = (State==SC)?dv:1'bz;

always @(AddrReg, ld_Data)
    MemData=Mem[AddrReg];
    
always_ff @(posedge s.clock)
    if(ld_AddrUp) AddrReg[15:8]<=s.address;
 
//always_ff @(posedge clock)   
always_comb //changed
    if(ld_AddrLo) AddrReg[7:0]<=s.address;
    
always @(posedge s.clock) begin
    if(ld_Data) begin
        DataReg <= s.data;
        Mem [AddrReg] <= s.data;
    end
end

always @(posedge s.clock, negedge s.resetN)
    if(~s.resetN) State <= SA;
    else State <= NextState;

always_comb begin
ld_AddrUp = 0;
ld_AddrLo = 0;
dv        = 0;
en_Data   = 0;
ld_Data   = 0;

    case (State)
        SA: begin
                NextState = (s.start & s.address[7:4]==page_addr)?(s.read)?SC:SD:SA; //addited
                ld_AddrUp = (s.start & s.address[7:4]==page_addr)?1:0; //addited
            end
//        SB: begin
//                NextState = (read)?SC:SD;
//                ld_AddrLo = 1;
//            end
        SC: begin //read
                ld_AddrLo   = 1;//(~memDataAvail)?1:0; //added
                NextState   = (memDataAvail)?SA:SC;
                dv          = (memDataAvail)?1:0;
                en_Data     = (memDataAvail)?1:0;
            end
        SD: begin //write
                ld_AddrLo   = 1;//(~dataValid)?1:0; //added
                NextState   = (s.dataValid)?SA:SD;
                ld_Data     = (s.dataValid)?1:0;
            end
    endcase
end

endinterface: MemInitThread
