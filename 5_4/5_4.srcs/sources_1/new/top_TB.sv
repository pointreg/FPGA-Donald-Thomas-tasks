`include "pay_pkg.sv"
program top_TB (input logic clk, rst, output pay_pkg::pay valueToSend);

initial begin
    @(posedge rst);
    repeat($urandom_range(20, 10)) begin
        sendRandSequence;
    end
    @(posedge clk);
    @(posedge clk);
	$finish;
end

task sendRandSequence;
    @(posedge uut2.cFree);
    @(posedge clk);
    valueToSend  <= getValue();
endtask

function int getValue();
    getValue = $urandom_range(2**32-1,2**30);
    return getValue;
endfunction

endprogram

