parameter DW = 16;
parameter W = 256;
parameter AW = $clog2(W);

module memController #(parameter logic [7:0] page = 8'h02) (procInterface.slave p_i);
//(inout tri [15:0] addrData,
//input logic addrValid, rw, clk, reset);

enum {stb,read,write} state, nextState;
bit [15:0] basicAddr;
bit [1:0] counter;
bit isMemCntrlr;

memInterface #(.DW(DW), .W(W), .AW(AW)) mIntrfc (.clk(p_i.clk));

mem #(.DW(DW), .W(W), .AW(AW)) uut1 (mIntrfc.mM);
//(.re(mIntrfc.re),.we(mIntrfc.we),.clk(mIntrfc.clk),.Addr(mIntrfc.Addr),.Data(mIntrfc.Data));


always_ff @(posedge p_i.clk) begin
    if(p_i.reset) begin
        state     <= stb;
        counter   <= 0;
        basicAddr <= 0;
    end
    else begin
        basicAddr <= isMemCntrlr?p_i.addrData:basicAddr;
        state     <= nextState;
        counter   <= (state!=stb)?counter+1:0;
    end
end

always_comb begin
    case (state)
        stb:     nextState = (isMemCntrlr)?((p_i.rw)?read:write):stb;
        read:    nextState = (counter!=3)?read:stb;
        write:   nextState = (counter!=3)?write:stb;
        default: nextState = stb;
    endcase
end

assign  mIntrfc.Data = mIntrfc.we?p_i.addrData:'bz,
        p_i.addrData = mIntrfc.re?mIntrfc.Data:'bz,
        isMemCntrlr  = (p_i.addrValid && p_i.addrData[15:8]==page),
        mIntrfc.Addr = (state==read || state==write)?basicAddr+counter:'bz,
        mIntrfc.re   = (state==read),
        mIntrfc.we   = (state==write);

endmodule: memController

interface memInterface #(parameter DW = 16, W = 256, AW = $clog2(W)) (input clk);
logic re, we;
logic [AW-1:0] Addr;
tri [DW-1:0] Data;

modport mC (input clk, output re, we, Addr, inout Data);
modport mM (input re, we, clk, Addr, inout Data);

endinterface: memInterface