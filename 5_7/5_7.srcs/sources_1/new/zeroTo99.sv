module zeroTo99
(input logic ck, r, countEnable, // countEnabe ��� ������ ������
output logic carryOut, // ������� �� ������ ��������
output logic [3:0] DCBA10, DCBA1); // ������ FF ���� �����

logic cout1;

decadeCTR count_1 (.DCBA(DCBA1),.carryOut(cout1),.*);
decadeCTR count_2 (.DCBA(DCBA10),.countEnable(cout1),.*);

endmodule: zeroTo99

