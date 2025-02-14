module alu_ov (a, b, aluc, r, z, v);
input  [31:0]  a, b;                                // aluc[3:0]
input  [3:0]   aluc;                                //
output [31:0]  r;                                   //x000 ADD
output         z,v;                                 //x10 SUB
wire   [31:0]  d_and  = a & b;                      //x001 AND .
wire   [31:0]  d_or   = a | b;                      //x101 OR
wire   [31:0]  d_xor  = a ^ b;                      //x01 0 XOR
wire   [31:0]  d_lui  = {b[15:0], 16'h0};           //x110 LUI
wire   [31:0]  d_and_or  = aluc[2] ? d_or  : d_and; //0011 SLL
wire   [31:0]  d_xor_1ui = aluc[2] ? d_lui : d_xor; //0111 SRL
wire   [31:0]  d_as, d_sh;                          //1111 SRA

addsub32  as32     (a, b, aluc[2], d_as);
shift     shifter  (b, a[4:0], aluc[2], aluc[3], d_sh);
mux4x32   select   (d_as, d_and_or, d_xor_1ui, d_sh, aluc[1:0], r);
assign    z = ~|r;//1为两个操作数相等0为不相等
assign    v = ~aluc[2] & ~a[31] & ~b[31] &  r[31] & ~aluc[1] & ~aluc[0] |
              ~aluc[2] &  a[31] &  b[31] & ~r[31] & ~aluc[1] & ~aluc[0] |
               aluc[2] & ~a[31] &  b[31] &  r[31] & ~aluc[1] & ~aluc[0] |
               aluc[2] &  a[31] & ~b[31] & ~r[31] & ~aluc[1] & ~aluc[0];
endmodule
