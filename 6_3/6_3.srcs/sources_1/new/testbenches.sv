program TBProc(FastBus.M m, MasterThread.proc_cmnd p_c);
    logic [15:0] Avalue='bz, Dvalue='bz;
    
    initial begin
        @(posedge m.resetN)
        @(posedge m.clock);
        p_c.WriteMem (16'h0406, 16'hAAAA);
        repeat (1) @(posedge m.clock);
        p_c.WriteMem (16'h1406, 16'hBBBB);
        p_c.WriteMem (16'h2406, 16'hCCCC);
        p_c.WriteMem (16'h3406, 16'hDDDD);
        
        p_c.ReadMem (16'h0405);
        repeat (1) @(posedge m.clock);
        p_c.ReadMem (16'h1406);
        p_c.ReadMem (16'h2407);
        p_c.ReadMem (16'h3408);
        repeat (5) @(posedge m.clock);
        p_c.ReadMem (16'h4409);
        repeat (1) @(posedge m.clock);
        p_c.ReadMem (16'h0406);
        p_c.ReadMem (16'h1406);
        p_c.ReadMem (16'h2406);
        
        repeat (5) @(posedge m.clock);
        $finish;
    end
    initial begin
        forever p_c.Listen (Avalue, Dvalue);
    end
endprogram: TBProc

program TBMem (FastBus.S s, MemThread v);
    initial begin
        v.MemInit; 
        forever begin
            @(v.State) begin
                bit [1:0] delay;
                v.memDataAvail <= 0;
                    if(v.State == v.SC) begin
                        delay = $random;
                        repeat (2+delay) @(posedge s.clock);
                        v.memDataAvail <= 1;
                        wait(s.slave_ans);
                    end
            end
        end
    end
endprogram: TBMem