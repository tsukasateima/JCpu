module sccpu_intr (clock , resetn, inst, mem, pc, wmem, alu, data, intr, inta,overflow);
input   [31:0] inst, mem; 
input          clock, resetn, intr; 
output  [31:0] pc, alu, data;
output         wmem, inta, overflow;

parameter EXC_BASE = 32'h00000008;
wire  [31:0]  p4, bpc, npc, adr, ra, alua, alub, res, alu_mem; 
wire  [3:0]   aluc;
wire  [4:0]   reg_dest, wn;
wire  [1:0]   pcsource;//下一条指令的地址选择信号，00为选择PC+4，01为beq和bne转移，11为无条件转移
wire          zero, //两个操作数是否相等
				  wmem, //weme是否写入数据存储器
				  wreg, //wreg是否写入寄存器堆
				  regrt, m2reg, shift, aluimm, jal, sext;//sext 1进行符号扩展 0进行零扩展
				  //, overflow; 
				  
//指令中sa部分，高位用0补齐
wire  [31:0]  sa ={27'b0,inst[10:6]};
//符号扩展的偏移量左移两位的结果
wire  [31:0]  offset ={ imm [13:0], inst [15:0],1'b0,1'b0};

sccu_intr     cu ( inst [31:26], inst [25:21], inst [15:11], inst [5:0], zero, wmem,
	                wreg, regrt, m2reg, aluc, shift, aluimm, pcsource, jal, sext, intr,
	                inta, overflow, sta, cause, exc, wsta, wcau, wepc, mtc0, mfc0, selpc);

						 
//若是符号扩展则获取符号位，若是0扩展则默认为01		 
wire          e = sext & inst [15];
//符号扩展的高16位
wire  [15:0]  imm = {16{ e }};
//符号扩展后的立即数
wire  [31:0]  immediate = {imm,inst[15:0]};
//每次时钟上升沿到来时更新pc当前指向的地址的值
dff32         ip       (next_pc, clock, resetn, pc);
cla32         pcplus4  (pc,    //加数a
								32'h4, //加数b
								1'b0,  //无低位进位
								p4     //PC+4后的结果
								);
cla32         br_adr   (p4,    //PC+4后的结果，加数a
								offset,//符号扩展到偏移量左移两位的结果，加数b
								1'b0,  //无低位进位
								adr    //beq和bne转移后的结果
								);			
//j和jal指令转移到目标地址，PC+4的高四位和addr地址左移两位
wire  [31:0]  jpc = {p4[31:28], inst[25:0], 1'b0, 1'b0};
mux2x32       alu_b    (data,      //0：add指令，寄存器堆qb堆
								immediate, //1：addi指令，符号扩展后的立即数
								aluimm,    //选择信号
								alub       //选择结果
								);     
mux2x32       alu_a    (ra,    //0：add指令，寄存器堆qa堆
								sa,    //1：sll指令，指令中sa部分
								shift, //选择信号
								alua   //选择结果
								);
								
								
								
mux2x32       result   (alu,    //alu计算结果
								mem,    //从数据存储器读来的数据
								m2reg,  //选择信号
								alu_mem //选择结果
								);
mux2x32       link     (alu_mem_c0,  //add指令alu计算结果或者lw指令从存储器取来的数据（待补充）
								p4,          //jal指令，PC+4
								jal,         //选择信号
								res          //选择结果
								);           
mux2x5        reg_wn   (inst[15:11], //指令中rd寄存器地址
								inst[20:16], //指令中rt寄存器地址
								regrt,       //选择信号
								reg_dest     //选择结果
								); 

//若为jal指令，则固定存入r31寄存器中
assign        wn = reg_dest | {5{jal}};
//正常情况下，下一条指令地址的选择
mux4x32       nextpc   (p4,       //00：PC+4
								adr,      //01：beq和bne转移
								ra,       //10：jr指令
								jpc,      //11：j和jal指令
								pcsource, //选择信号
								npc       //选择结果
								);					
//32位寄存器堆
regfile       rf       (inst [25:21], //读取数据a的地址
							   inst [20:16], //读取数据b的地址
								res,          //要存入寄存器堆的数据
								wn,           //要存入的寄存器的编号
								wreg,         //使能信号，是否写入
								clock,        //时钟信号
								resetn,       //复位信号
								ra ,          //输出qa
								data          //输出qb
								); 
alu_ov        al_unit  (alua, alub, aluc, alu, zero, overflow);

//新增异常处理功能
wire          exc,  //是否有异常，0没有1有
				  wsta, //status寄存器使能信号
				  wcau, //cause寄存器使能信号
				  wepc, //epc寄存器使能信号
				  mtc0; //status_in，cause_in，epc_in选择信号
wire  [31:0]  sta, 
				  cau,       //存储异常和中断发生源信息的寄存器
				  epc,       //保存返回地址的寄存器
				  sta_in,    //status寄存器值下一个周期的值
				  cau_in,    //cause寄存器值下一个周期的值
				  epc_in,    //epc寄存器值下一个周期的值
				  sta_l1_a0, //status寄存器值下一个周期的值
				  epc_l1_a0, //epc寄存器值下一个周期的值
				  cause,     //异常和中断类型
				  alu_mem_c0,//要存入寄存器堆数据的选择结果
				  next_pc;   //下一条指令的地址
wire  [1:0]   mfc0, selpc;
dffe32        c0_Status(sta_in, clock, resetn, wsta, sta); 
dffe32        c0_Cause (cau_in, clock, resetn, wcau, cau);
dffe32        c0_EPC   (epc_in, clock, resetn, wepc, epc);

mux2x32       sta_12   ({4'h0, sta[31:4]},//Status寄存器右移结果
							   {sta [27:0],4'h0},//Status寄存器左移结果
								exc,              //选择信号
								sta_l1_a0         //选择结果
								);
mux2x32       epc_12   (pc,       //当前指令地址
								npc,      //正常情况下，下一条指令地址
								inta,     //选择信号，外部中断，
								epc_l1_a0 //选择结果
								);

mux2x32       sta_11   (sta_l1_a0, data, mtc0, sta_in);   
mux2x32       cau_11   (cause, data, mtc0, cau_in );      
mux2x32       epc_11   (epc_l1_a0, data, mtc0, epc_in);  


//决定下一条指令的地址 
mux4x32       irq_pc   (npc,      //正常情况下，下一条指令地址
								epc,      //异常或中断后的返回地址
								EXC_BASE, //异常或中断处理程序入口
								32'h0,    //系统复位
								selpc,    //选择信号
								next_pc   //选择结果
								); 
mux4x32       fromc0   (alu_mem,   //alu计算结果或者从存储器里读取的数据
								sta,
								cau,
								epc,
								mfc0,      //选择信号
								alu_mem_c0 //选择结果
								);
endmodule



