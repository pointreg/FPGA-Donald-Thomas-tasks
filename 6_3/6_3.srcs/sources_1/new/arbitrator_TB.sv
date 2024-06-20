program arbitrator_TB #(parameter slaves_qtty=3) 
(input clock, resetN, master_ans, 
input logic [slaves_qtty-1:0] slave_ans, 
output logic master_req, read_req,
output logic [slaves_qtty-1:0] slave_req);


class srrw;
    rand bit read_req;
    rand bit [slaves_qtty-1:0] sl_req;
    rand bit ms_req;
    int maxOnes = 0;
    int slave_req = 0;
    int temp=0;
    
    constraint data 
    {
      read_req dist   {0:=20, 1:=80 };
      //sl_req inside {[0:slaves_qtty-1]};
      ms_req dist {0:=50, 1:=80 };
    }    
    constraint data2 
    {
        if (this.slave_req) this.slave_req & sl_req == this.slave_req;
        SumBits(sl_req) <= maxOnes;
      //if (&slave_req) {foreach (slave_req[i]) {if (slave_req[i]) sl_req[i] == 1;}}
    }
    
    function bit[$clog2(slaves_qtty):0] SumBits (input  bit [slaves_qtty-1:0] toCount); 
        int temp=0;
        for(int i = 0; i<$size(toCount); i++) temp = toCount[i]==1?temp+1:temp;
        return temp;
    endfunction    
endclass


bit [$clog2(slaves_qtty)+1:0] reqCounter, prevReq;
srrw rnd;

initial begin
    rnd = new();
    read_req = 0;
    master_req= 0;
    slave_req = 0;
    @(posedge resetN);
    repeat (50) begin
        @(posedge clock);
        prevReq = reqCounter;
        //with {~(slave_req & ~slave_ans)|sl_req != ~(slave_req & ~slave_ans); };
        reqCounter = (master_req & read_req & master_ans)?(reqCounter + 1):reqCounter;
        reqCounter = (reqCounter!=0 && slave_ans)?(reqCounter - 1):reqCounter;
        if (master_req & master_ans) $display ($time, "[PROC] got [%0s] transmission access, request's counter: %d", read_req?"READ":"WRITE", reqCounter);
        if (slave_req & slave_ans)   $display ($time, "[MEM:%b] got transmission access(%b), request's counter: %d", slave_req, slave_ans, reqCounter);
        rnd.maxOnes = reqCounter;
        rnd.slave_req = slave_req& ~slave_ans;
        if((reqCounter && rnd.SumBits(slave_req)<slaves_qtty && rnd.SumBits(slave_req)<reqCounter)) assert (rnd.randomize(sl_req)); //with {   
                                    //(~slave_ans)&sl_req==sl_req; 
                                    //(slave_ans^slave_req)&sl_req==(slave_ans^slave_req); 
                                    //if(rnd.SumBits(slave_req)!=0) 
                                    //(slave_req)&sl_req==(slave_req);
                                    //rnd.SumBits(sl_req)<=reqCounter; 
                                    //(slave_req & ~slave_ans)&sl_req==(slave_req & ~slave_ans); 
                                    //rnd.SumBits(sl_req)<=reqCounter;
                                    //sl_req[0]+sl_req[1]+sl_req[2]+sl_req[3]<=reqCounter;
                                //};
        //else rnd.randomize();
        //rnd.randomize(sl_req);
        rnd.randomize(ms_req, read_req);
        
        $display("rnd.SumBits(slave_req)=%d,   slave_req=%b,     reqCounter=%d  ", rnd.SumBits(slave_req), slave_req, reqCounter);
        ///[MEM] section
        slave_req   = reqCounter!=0? (prevReq!=reqCounter) ? (rnd.sl_req & ~slave_ans) : slave_req
                                    //(slave_ans | !slave_req)?(rnd.sl_req):slave_req
                                    :0;
                                    //$display(rnd.SumBits(slave_req));
        ///[MEM] section end
        
        ///[PROC] section
        master_req  = (master_ans | !master_req)?rnd.ms_req:master_req;
        read_req        = (master_ans)? master_req?rnd.read_req:0 :read_req;
        ///[PROC] section end
        
        
        //slave_req = reqCounter!=0 & ?$random:0slave_req;
        //reqCounter = slave_req?(reqCounter - 1):reqCounter;
        //if (reqCounter==slaves_qtty) $finish;
    end
    $finish;
end

    
endprogram: arbitrator_TB

