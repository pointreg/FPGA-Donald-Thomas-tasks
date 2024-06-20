program sumItUp_TB(input logic ck, reset_l, error, input logic [15:0] sum, output logic [15:0] inA, output logic go_l);

initial begin
    @(posedge reset_l);
    repeat($urandom_range(50, 10)) begin
        sendRandSequence;
        repeat($urandom_range(MAX_DELAY_BTW_SEQ, 0)) @(posedge ck);
    end
    @(posedge ck);
    go_l <= 0;
    inA  <= 16'h1fff;
    @(posedge ck);
    go_l <= 1;
    @(posedge ck);
    @(posedge ck);
	$stop;
end

task sendRandSequence; //task 7.7.
    automatic bit ovflw=0;
    @(posedge ck);
    go_l <= 0;  
    inA  <= getValue();
    ovflw = (ovflw)?1:(($sampled(sum) + inA)>16'hFFFF ?1:0);
    repeat ($urandom_range(MAX_LENGTH_SEQ-1, 0)) begin
        @(posedge ck); 
        go_l <=1;
        inA  <= getValue();
        ovflw = (ovflw)?1:(($sampled(sum) + inA)>16'hFFFF ?1:0);
    end   
    @(posedge ck);
    go_l <= 1;  
    inA <= 0;
    if(!error & ovflw)  $display ("\n[TASK ERROR]: overflow wasn't caught. Time: %t\n", $time);
endtask

function int getValue();
    getValue = $urandom_range(1024*16,1);
    return getValue;
endfunction

endprogram