module arbitrator  #(parameter slaves_qtty=4) (FastBus.A a);
//(input clock, resetN,
//input master_req, read_req,
//input [slaves_qtty-1:0] slave_req, 
//output logic master_ans, 
//output logic [slaves_qtty-1:0] slave_ans);

bit [slaves_qtty-1:0] new_slave_ans, q, temp2;
bit [$clog2(slaves_qtty):0] qtty_of_requests=0, temp;
bit [$clog2(slaves_qtty)-1:0]  pos, pos1;

always_ff @(posedge a.clock, negedge a.resetN) begin
    if (~a.resetN) begin
        pos             <= 0;
        a.master_ans    <= 0;
        a.slave_ans     <= 0;
        qtty_of_requests<= 0;
    end
    else begin
        if      (a.master_req && (qtty_of_requests!=slaves_qtty || ~a.read_req)) begin 
            a.master_ans        <= 1;
            a.slave_ans         <= 0;
            qtty_of_requests  <= (a.read_req)?(temp + 1):temp;
        end
        else if (a.slave_req && qtty_of_requests!=0) begin 
            a.master_ans      <= 0;
            a.slave_ans       <= new_slave_ans;
            qtty_of_requests  <= temp - 1;
            pos               <= pos1;
        end
        else begin
            a.master_ans  <= 0;
            a.slave_ans   <= 0;
        end
    end
end

always_comb begin
    new_slave_ans = 0;
    new_slave_ans [pos] = 1;
end



always_comb begin
    pos1 = pos;
    q =  a.slave_req & ~a.slave_ans;
    if (q) for (temp2 = 0; temp2 < slaves_qtty; temp2++) begin
        if(q[temp2 + pos]!=1) begin 
            pos1 = temp2 + pos;
            break;
        end
    end
end

assign  temp = qtty_of_requests;

endmodule: arbitrator