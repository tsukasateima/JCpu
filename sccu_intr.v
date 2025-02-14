module sccu_intr (op, op1, rd, func, z, wmem, wreg, regrt, m2reg, aluc,
                  shift, aluimm, pcsource, jal, sext, 
						intr, inta, ov, sta, cause, exc, wsta, wcau, wepc, mtc0, mfc0, selpc);
input   [5:0]  op,func;
input   [4:0]  op1,rd;
input          z;
output         wreg, regrt, jal, m2reg, shift, aluimm, sext, wmem;
output  [3:0]  aluc;
output  [1:0]  pcsource;

//与异常或中断有关的信号：
input          intr, ov;
input   [31:0] sta;
output         inta, exc, wsta, wcau, wepc, mtc0;
output  [1:0]  mfc0, selpc;
output  [31:0] cause;

//区别异常和中断的类型，4种：外部中断、系统调用、未实现的指令以及溢出。
wire           overflow = ov & (i_add | i_sub | i_addi);
assign         inta = int_int;
wire           int_int = sta[0] & intr;
wire           exc_sys = sta[1] & i_syscall;
wire           exc_uni = sta[2] & unimplemented_inst;
wire           exc_ovr = sta[3] & overflow;
assign         exc = int_int | exc_sys | exc_uni | exc_ovr;

//产生ExcCode:00:外部中断、01:系统调用、10:未实现的指令、11:溢出。
wire           ExcCode0 = i_syscall | overflow;
wire           ExcCode1 = unimplemented_inst | overflow;
assign         cause = {28'h0, ExcCode1, ExcCode0, 2'b00};

//产生3个寄存器的写使能信号：
assign         mtc0 = i_mtc0;
assign         wsta = exc | (mtc0 & rd_is_status) | i_eret;
assign         wcau = exc | (mtc0 & rd_is_cause);
assign         wepc = exc | (mtc0 & rd_is_epc);

//执行mfc0指令时选择寄存器:00:原来的、01:Status、10:Cause、11:EPC。
wire           rd_is_status = (rd == 5'd12);//0 Status register
wire           rd_is_cause  = (rd == 5'd13);//0 Cause register
wire           rd_is_epc    = (rd == 5'd14);//0 EPC register
assign         mfc0[0] = (i_mfc0 & rd_is_status) | (i_mfc0 & rd_is_epc);
assign         mfc0[1] = (i_mfc0 & rd_is_cause)  | (i_mfc0 & rd_is_epc);
//PC 的选择:00:原来的、01:EPC、10:异常或中断处理程序的入口。
assign         selpc[0] = i_eret;
assign         selpc[1] = exc;
//对新加的4条指令译码以及确定是否为未实现的指令：
wire    c0_type   = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
wire    i_mfc0    = c0_type & ~op1[4] & ~op1[3] & ~op1[2] & ~op1[1] & ~op1[0];
wire    i_mtc0    = c0_type & ~op1[4] & ~op1[3] &  op1[2] & ~op1[1] & ~op1[0];
wire    i_eret    = c0_type &  op1[4] & ~op1[3] & ~op1[2] & ~op1[1] & ~op1[0]
                  & ~func[5] & func[4] & func[3] & ~func [2] & ~func[1] & ~func[0];
wire    i_syscall = r_type & ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & ~func[0];

wire    unimplemented_inst = ~(i_mfc0 | i_mtc0 | i_eret | i_syscall |
                               i_add | i_sub | i_and  | i_or   | i_xor | i_sll  | i_srl |
                               i_sra | i_jr  | i_addi | i_andi | i_ori | i_xori | i_lw  |
                               i_sw  | i_beq | i_bne  | i_lui  | i_j   | i_jal);

wire    r_type = ~|op;//按位取反
wire    i_add  = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
wire    i_sub  = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
wire    i_and  = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0];
wire    i_or   = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] &  func[0];
wire    i_xor  = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0];
wire    i_sll  = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
wire    i_srl  = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0];
wire    i_sra  = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0];
wire    i_jr   = r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0];
wire    i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
wire    i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
wire    i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
wire    i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
wire    i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
wire    i_sw   =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
wire    i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
wire    i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
wire    i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0];
wire    i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0];
wire    i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];


assign  wreg    = i_add  | i_sub  | i_and | i_or   | i_xor | i_sll | i_srl | i_sra
                | i_addi | i_andi | i_ori | i_xori | i_lw  | i_lui | i_jal | i_mfc0;
assign  regrt   = i_addi | i_andi | i_ori | i_xori | i_lw  | i_lui | i_mfc0;
assign  jal     = i_jal;
assign  m2reg   = i_lw;
assign  shift   = i_sll  | i_srl  | i_sra;
assign  aluimm  = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui | i_sw;
assign  sext    = i_addi | i_lw   | i_sw  | i_beq  | i_bne;
assign  aluc[3] = i_sra;
assign  aluc[2] = i_sub | i_or  | i_srl | i_sra | i_ori  | i_lui;
assign  aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq  | i_bne | i_lui;
assign  aluc[0] = i_and | i_or  | i_sll | i_srl | i_sra  | i_andi | i_ori;
assign  wmem    = i_sw;

assign  pcsource[1] = i_jr | i_j | i_jal;
assign  pcsource[0] = (i_beq & z) | (i_bne & ~z) | i_j | i_jal;
endmodule
