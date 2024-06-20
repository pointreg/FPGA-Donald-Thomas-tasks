module TBProc(SimpleBus.M m, ProcInitThread.proc_cmnd p_c);
    initial begin
        repeat (2) @(posedge m.clock);

        p_c.WriteMem (16'h0306, 8'hDC);
        p_c.ReadMem (16'h0306);
        p_c.WriteMem (16'h1406, 8'hAB);
        p_c.ReadMem (16'h1406);
        p_c.ReadMem (16'h0306);
        $finish;
    end
endmodule: TBProc

interface ProcInitThread (SimpleBus.M m);

logic start, read;
//logic dataValid;
logic [7:0] address;
//logic [7:0] data;
assign  m.address = address,
        m.start = start,
        m.read=read;

logic en_AddrUp, en_AddrLo,
              ld_Data, en_Data, access=0,
              doRead, wDataRdy, dv;
    logic [7:0] DataReg;
    logic [15:0] AddrReg;
    
    enum {MA,MB,MC,MD} State, NextState;
    
    assign m.data = (en_Data)?DataReg:'bz;
    assign m.dataValid = (State == MD)?dv:1'bz;
    
    always_comb
        if(en_AddrLo) address = AddrReg[7:0];
        else if (en_AddrUp) address = AddrReg[15:8];
        else address = 'bz;
    
    always @(posedge m.clock)
        if(ld_Data) DataReg <= m.data;
    
    always_ff @(posedge m.clock, negedge m.resetN)
        if(~m.resetN) State <= MA;
        else        State <= NextState;
    always_comb begin
        start=0;
        en_AddrLo=0;
        en_AddrUp=0;
        read=0;
        ld_Data=0;
        en_Data=0;
        dv=0;
        case(State)
            MA: begin
                NextState   =(access)?((doRead)?MC:MD):MA; //addited
                start       =(access)?1:0;
                read        =(access & doRead)?1:0; //added
                en_AddrUp   =(access)?1:0;
                end
    //        MB: begin
    //            NextState   = (doRead)?MC:MD;
    //            en_AddrLo   = 1;
    //            read = (doRead)?1:0;
    //        end
            MC: begin //read
                en_AddrLo   = 1;//(~dataValid)?1:0; //added
                NextState   = (m.dataValid)?MA:MC;
                ld_Data     = (m.dataValid)?1:0;
            end
            MD: begin //write
                en_AddrLo   = 1;//(~wDataRdy)?1:0; //added
                NextState   = (wDataRdy)?MA:MD;
                en_Data     = (wDataRdy)?1:0;
                dv          = (wDataRdy)?1:0;
            end
        endcase
    end

modport proc_cmnd(import WriteMem, ReadMem);

task WriteMem 
(input [15:0] Avalue,
input [7:0] Dvalue);
    begin
        access <= 1;
        doRead <=0;
        wDataRdy <= 1;
        AddrReg <= Avalue;
        DataReg <= Dvalue;
        @(posedge m.clock) access <= 0;
        @(posedge m.clock);
        wait (State == MA);
        repeat (2) @(posedge m.clock);
    end
endtask
    
task ReadMem
(input [15:0] Avalue);
    begin
        access <= 1;
        doRead <= 1;
        wDataRdy <= 0;
        AddrReg <= Avalue;
        @(posedge m.clock) access <= 0;
        @(posedge m.clock);
        wait (State == MA);
        repeat (2) @(posedge m.clock);
    end
endtask 

endinterface: ProcInitThread

