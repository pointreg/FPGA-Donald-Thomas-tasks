module top;

logic clock=0, reset=0, a=0, b=0, start=0;
logic done, cout, zero, neg, twosOFlow;
logic [5:0] sum;

logic signed [5:0] i=0, k=0; //assuming that a & b are bits of two's complement binary number
    
always #1 clock=~clock;
serialAdder uut (.*);

initial begin
    #3 reset = 1;
    for (k=1;k!=0;k++) begin
        for (i=1;i!=0;i++) begin
            a=i[0];
            b=k[0];
            start=1;
            #2;
            a=i[1];
            b=k[1];
            start=0;
            #2;
            a=i[2];
            b=k[2];
            #2;
            a=i[3];
            b=k[3];
            #2;
            a=i[4];
            b=k[4];
            #2;
            a=i[5];
            b=k[5];
            #2;
            if      ((i+k)<-(2**5-1) && (~neg && sum[5] && ~twosOFlow || zero || cout))                             show_var(0);
            else if ((i+k)>=-(2**5-1) && (i+k)<0 && ((i+k)!=sum && ~neg && ~sum[5] || twosOFlow || zero || cout))   show_var(1);
            else if ((i+k)==0 && ((sum!=0 || ~zero) || twosOFlow || cout || neg))                                   show_var(2);
            else if ((i+k)>0 && ((i+k)!={cout,sum[4:0]} && !sum[5] || twosOFlow || zero || neg))                    show_var(3);
            
            //#4;
        end
    end
    #8;
    $finish;
end

endmodule


function void show_var (input bit [2:0] error_n);
static string e_n [4] = '{"OVERFLOW", "NEGATIVE", "ZERO", "POSITIVE"};
    $display($time, "[%s ERROR] a=%d, b=%d, sum=%d, cout=%b, twosOFlow=%b, neg=%b, zero=%b", e_n[error_n], top.i, top.k, $signed(top.sum), top.cout, top.twosOFlow, top.neg, top.zero);
endfunction
