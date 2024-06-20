program findMax_TB(
output logic start,
output logic [7:0] inputA,
input logic [7:0] maxValue,
input logic clk, rst
);

initial begin
    @(negedge rst)
    while(fcover.get_coverage() < 100 || fcover_2.get_coverage() < 100) begin //task 10.3. & 10.4. 
        sendRandSequence;
        repeat($urandom_range(MAX_DELAY_BTW_SEQ, 0)) @(posedge clk);
    end
    $display("Functional cover of: fcoveris is %d%%, fcover_2 is %d%%", fcover.get_coverage(),fcover_2.get_coverage());
    @(posedge clk);
    @(posedge clk);
	$finish;
end

task sendRandSequence; //task 7.6.
    automatic logic [7:0] isMax=0;
    repeat ($urandom_range(MAX_LENGTH_SEQ, 1)) begin
        @(posedge clk); 
        inputA = $urandom_range(255,1);
        start <=1;
        isMax = (isMax<inputA)?inputA:isMax;
    end   
    @(posedge clk);
    start <= 0;    
    inputA <= 0;
    if (isMax!=maxValue) $display ("\n[TASK ERROR]: maxValue is not max value at time: %t\n", $time);
endtask



//// task 10.3. section
covergroup findMax_cg @(posedge clk);
    option.at_least = 15;
    coverpoint inputA
    {
        wildcard bins b0 = { 8'b????_???1 };
        wildcard bins b1 = { 8'b????_??1? };
        wildcard bins b2 = { 8'b????_?1?? };
        wildcard bins b3 = { 8'b????_1??? };
        wildcard bins b4 = { 8'b???1_???? };
        wildcard bins b5 = { 8'b??1?_???? };
        wildcard bins b6 = { 8'b?1??_???? };
        wildcard bins b7 = { 8'b1???_???? };
        //bins b8 = default; //for unexpected values
    }
endgroup
findMax_cg fcover = new;
//// task 10.3. end section

//// task 10.4. section
covergroup is2ones_cg with function sample(input logic [7:0] in);    
    option.at_least = 10;
    coverpoint in {bins bx = {[0:1023]} with (item[7]+item[6]+item[5]+item[4]+item[3]+item[2]+item[1]+item[0]==2);    }
endgroup
is2ones_cg fcover_2 = new;

property J_prop; //task 10.4
    @(posedge clk) (inputA[7]+inputA[6]+inputA[5]+inputA[4]+inputA[3]+inputA[2]+inputA[1]+inputA[0]==2, fcover_2.sample(inputA));
endproperty

a1: assert property (J_prop) $display ("[J_prop DONE], inputA=%8b\n", $sampled(inputA));
    else $display ("[J_prop ERROR]: oops, prop fail, inputA=%8b\n", $sampled(inputA)); 
//c1: cover property (J_prop) fcover.sample($sample(inputA)); //calling sample method from cover operator doesn't work (example 10.8. in the book is wrong?)
//// task 10.4. end section

endprogram
