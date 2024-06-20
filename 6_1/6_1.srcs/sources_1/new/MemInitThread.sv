module MemInitThread #(bit [3:0] page_addr=4'h04)(
input logic clock, resetN,
input logic start, read,
inout logic dataValid,
input logic [7:0] address,
inout logic [7:0] data);

logic [7:0] Mem [16'hFFFF:0], MemData;
logic ld_AddrUp, ld_AddrLo,
      memDataAvail=0, en_Data, ld_Data, dv;
logic [7:0] DataReg;
logic [15:0] AddrReg;

enum {SA,SB,SC,SD} State, NextState;

initial begin
    for(int i=0; i<16'hFFFF; i++)
        Mem[i]=i[7:0];
end

assign data = (en_Data)?MemData:'bz;
assign dataValid = (State==SC)?dv:1'bz;

always @(AddrReg, ld_Data)
    MemData=Mem[AddrReg];
    
always_ff @(posedge clock)
    if(ld_AddrUp) AddrReg[15:8]<=address;
 
//always_ff @(posedge clock)   
always_comb //changed
    if(ld_AddrLo) AddrReg[7:0]<=address;
    
always @(posedge clock) begin
    if(ld_Data) begin
        DataReg <= data;
        Mem [AddrReg] <= data;
    end
end

always @(posedge clock, negedge resetN)
    if(~resetN) State <= SA;
    else State <= NextState;

always_comb begin
ld_AddrUp = 0;
ld_AddrLo = 0;
dv        = 0;
en_Data   = 0;
ld_Data   = 0;

    case (State)
        SA: begin
                NextState = (start & address[7:4]==page_addr)?(read)?SC:SD:SA; //addited
                ld_AddrUp = (start & address[7:4]==page_addr)?1:0; //addited
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
                NextState   = (dataValid)?SA:SD;
                ld_Data     = (dataValid)?1:0;
            end
    endcase
end


always @(State) begin
    bit [2:0] delay;
    memDataAvail <= 0;
    if(State == SC) begin
        delay = $random;
        repeat (2+delay)
            @(posedge clock);
        memDataAvail <= 1;
    end
end

endmodule: MemInitThread
