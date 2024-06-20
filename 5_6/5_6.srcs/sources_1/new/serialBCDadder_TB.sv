program serialBCDadder_TB (input clock, reset, output logic [3:0] a,b, output logic start, done);

initial begin
    @(reset);
    repeat ($urandom_range(5,15)) begin //number of sequences
        sendBCDseq();
        repeat ($urandom_range(0,2)) begin //delay between sequences
            @(posedge clock);
            done <= 0;
        end
    end
    @(posedge clock);
    @(posedge clock);
    $finish;
end

task sendBCDseq();
    @(posedge clock);
    done <= 0;
    start <= 1; 
    repeat ($urandom_range(2,9)) //quantity of numbers in sequence
        begin
            a <= $urandom_range(0,9);
            b <= $urandom_range(0,9);
            @(posedge clock);
            start <= 0; 
        end
    a <= $urandom_range(0,9);
    b <= $urandom_range(0,9);
    done <= 1;
endtask

endprogram: serialBCDadder_TB

