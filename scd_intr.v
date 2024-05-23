/*module scd_intr (clk, dataout, datain, addr, we, inclk, outclk);
input	  [31:0]	 datain;
input	  [31:0]	 addr ;
input	 	       clk, we, inclk, outclk;
output  [31:0]	 dataout;
wire            write_enable = we & ~clk;

lpm_ram_dp ram(
	.data(datain),
	.address (addr[6:2]),
	.we(write_enable),
	.inclock(inclk),
	.outclock(outclk),
	.q(dataout)
);
defparam  ram.lpm_width   = 32;
defparam  ram.lpm_widthad = 5;
defparam  ram.lpm_indata  = "registered";
defparam  ram.lpm_outdata = "registered";
defparam  ram.lpm_file    = "scd_intr.mif";
defparam  ram.lpm_address_control = "registered";
endmodule*/

module scd_intr (clk,dataout,datain,addr,we);
input	[31:0]	datain;
input	[31:0]	addr ;
input		clk, we;
output	[31:0]	dataout;
reg [31:0] ram	[0:31];
assign	dataout	=ram[addr[6:2]];
always @ (posedge clk) begin
	if (we) ram[addr[6:2]] = datain;
end
integer i;
initial begin
	for (i = 0;i < 32;i = i + 1)
		ram[i] = 0;
	ram[5'h08] = 32'h00000030;
	ram[5'h09] = 32'h0000003c;
	ram[5'h0a] = 32'h00000054;
	ram[5'h0b] = 32'h00000068;
	ram[5'h12] = 32'h00000002;
	ram[5'h13] = 32'h7fffffff;
	ram[5'h14] = 32'h000000A3;
	ram[5'h15] = 32'h00000027;
	ram[5'h16] = 32'h00000079;
	ram[5'h17] = 32'h00000115;
end
endmodule