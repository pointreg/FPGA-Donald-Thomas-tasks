module top;

parameter  slaves_qtty = 4; //slaves_qtty = max queue
//parameter  maxqueue = 4;

logic clock=0, resetN=0;
always #1 clock = ~clock;

FastBus #(slaves_qtty) MSA (clock, resetN);    

//proc pc (.clock(MSA.M.clock), .resetN(MSA.M.resetN), .master_ans(MSA.M.master_ans), 
//.data(MSA.M.data), .address(MSA.M.address), .dataReady(MSA.M.dataReady), 
//.start(MSA.M.start), .read(MSA.M.read), .master_req(MSA.M.master_req));


logic master_ans, slave_ans,master_req, slave_req, read;

MasterThread #(slaves_qtty) m (.m(MSA));
//(.clock(MSA.M.clock), .resetN(MSA.M.resetN), .master_ans(MSA.M.master_ans), .dataReady(MSA.M.dataReady), //INPUTS
//.data(MSA.M.data), .address(MSA.M.address), //INOUTS
//.start(MSA.M.start), .read(MSA.M.read), .master_req(MSA.M.master_req), .read_req(MSA.M.read_req)); //OUTPUTS

//genvar i; 
//generate 
//    for (i = 0; i<slaves_qtty; i++) begin: MEM
//    MemThread #(.page_addr(4'b0)) s (.s(MSA));
//    end: MEM
//endgenerate    
MemThread #(.page_addr(4'd0)) s (.s(MSA));
MemThread #(.page_addr(4'd1)) s1 (.s(MSA));
MemThread #(.page_addr(4'd2)) s2 (.s(MSA));
MemThread #(.page_addr(4'd3)) s3 (.s(MSA));
//(.clock(MSA.S.clock), .resetN(MSA.S.resetN), .read(MSA.S.read), .slave_ans(MSA.S.slave_ans), //INPUTS
//.data(MSA.S.data), .address(MSA.S.address), //INOUTS
//.dataReady(MSA.S.dataReady), .slave_req(MSA.S.slave_req)); //OUTPUTS                

                
arbitrator #(.slaves_qtty(slaves_qtty))  a  (.a(MSA));
//(.clock(MSA.A.clock), .resetN(MSA.A.resetN), .master_req(MSA.A.master_req), .slave_req(MSA.A.slave_req), .read_req(MSA.A.read_req), //INPUTS
//.master_ans(MSA.A.master_ans), .slave_ans(MSA.A.slave_ans)); //OUTPUTS


TBProc m_tb (.m(MSA),.p_c(m));
//TBMem  s_tb (.s(MSA),.v(s));
//arbitrator_TB #(.slaves_qtty(slaves_qtty)) a_tb (.clock(MSA.clock), .resetN(MSA.resetN),
//.master_req(MSA.master_req), .slave_req(MSA.slave_req), .read_req(MSA.read_req), .master_ans(MSA.master_ans), .slave_ans(MSA.slave_ans));

initial begin
    #2 resetN = 1;
end

    
endmodule: top


interface FastBus #(parameter slaves_qtty = 2) (input clock, resetN);
tri dataReady, start, read;
tri [15:0] address, data;
logic master_ans, master_req, read_req;
logic [slaves_qtty-1:0] slave_req, slave_ans;

modport M ( input clock, resetN, master_ans, dataReady,
            inout data, address, 
            output start, read, master_req, read_req);
modport S ( input clock, resetN, slave_ans, start, read,
            inout data, address,
            output slave_req, dataReady);
modport A  (input clock, resetN,
            input master_req, read_req, slave_req,
            output master_ans, slave_ans);      

endinterface: FastBus