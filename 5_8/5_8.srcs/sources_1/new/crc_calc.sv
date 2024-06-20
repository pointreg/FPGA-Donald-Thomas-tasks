module crc_calc 
(input clk, rst, data_in, crc_en,
output logic [4:0] crc_out, 
output logic done, OK);
      
logic [4:0] lfsr_q, lfsr_c;
logic [5:0] cntr, cntr2;
logic ld;
enum bit {sA, sB} state;

localparam CRC_START_COND = 5'b11111; //5'b11111

always_ff @(posedge clk, posedge rst) begin
    if (rst) state <= sA;
    else begin
        if     ((state==sA & crc_en)  | (state==sB & cntr2!=15)) state = sB;
        else if((state==sA & ~crc_en) | (state==sB & cntr2==15)) state = sA;
    end
end

always_comb  begin
    lfsr_c[0] = lfsr_q[4] ^ data_in;
    lfsr_c[1] = lfsr_q[0];
    lfsr_c[2] = lfsr_q[4] ^ data_in ^ lfsr_q[1];
    lfsr_c[3] = lfsr_q[2];
    lfsr_c[4] = lfsr_q[3]; 
end

always_ff@ (posedge clk, posedge rst) begin
    if(rst) begin
        cntr2   <= 15;
        lfsr_q  <= CRC_START_COND;
        crc_out <= 0;
    end
    else begin
        if(ld) begin 
            cntr2   <= cntr;  
            lfsr_q  <= lfsr_c;
            crc_out <= cntr==11?lfsr_c:crc_out;
        end
        else begin
            lfsr_q  <= CRC_START_COND;
            crc_out <= 0;
        end
    end
end
assign  ld      = ((state==sA & crc_en) | (state==sB & cntr2!=15)),
        cntr    = cntr2==15?1:cntr2 + 1,
        done    = state==sB & cntr2==15,
        OK      = done & 5'b01100==lfsr_c;
  
endmodule: crc_calc
