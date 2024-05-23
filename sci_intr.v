/*module sci_intr (a, inst);
input [31:0] a;
output [31:0] inst;
lpm_rom  lpm_rom_component(
	.address (a[6:2]),
	.q (inst)
);
defparam lpm_rom_component.lpm_width    = 32,
         lpm_rom_component.lpm_widthad  = 5,
         lpm_rom_component.lpm_numwords = "unused",
	      lpm_rom_component.lpm_file     = "sci_intr.mif",
         lpm_rom_component.lpm_indata   = "unused", 
			lpm_rom_component.lpm_outdata  = "unregistered",
			lpm_rom_component.lpm_address_control = "unregistered";
endmodule*/

module sci_intr (a,inst); 
	input [31:0] a; 
	output [31:0] inst; 
	wire [31:0] rom [0:63];
 	assign   rom[6'h00] = 32'h0800001d; // 
	assign   rom[6'h01] = 32'h00000000; // 
	
	assign   rom[6'h02] = 32'h401a6800; // 
	assign   rom[6'h03] = 32'h335b000c; //
	assign   rom[6'h04] = 32'h8f7b0020; // 
	assign	rom[6'h05] = 32'h00000000;	//
	assign	rom[6'h06] = 32'h03600008;	//
	assign	rom[6'h07] = 32'h00000000;	//	
	
	assign   rom[6'h08] = 32'h00000000; // 
	assign   rom[6'h09] = 32'h00000000; // 
	assign   rom[6'h0A] = 32'h00000000; // 
	assign   rom[6'h0B] = 32'h00000000; // 
	
	assign	rom[6'h0C] = 32'h00000000;	//	
	assign	rom[6'h0D] = 32'h42000018;	//
	assign	rom[6'h0E] = 32'h00000000;	//	
	
	assign	rom[6'h0F] = 32'h00000000;	//
	assign	rom[6'h10] = 32'h401a7000;	//
	assign	rom[6'h11] = 32'h235a0004;	//	
	assign	rom[6'h12] = 32'h409a7000;	//	
	assign	rom[6'h13] = 32'h42000018;	//	
	assign	rom[6'h14] = 32'h00000000;	//	
	
	assign	rom[6'h15] = 32'h00000000;	//
	assign	rom[6'h16] = 32'h08000010;	//	
	assign	rom[6'h17] = 32'h00000000;	//	
	
	assign   rom[6'h18] = 32'h00000000; // 
	assign   rom[6'h19] = 32'h00000000; // 
	
	assign	rom[6'h1A] = 32'h00000000;	//
	assign	rom[6'h1B] = 32'h08000010;	//
	assign	rom[6'h1C] = 32'h00000000;	//	
	
	assign	rom[6'h1D] = 32'h2008000f;	//	
	assign	rom[6'h1E] = 32'h40886000;	//	
	
	assign	rom[6'h1F] = 32'h8c080048;	//	
	assign	rom[6'h20] = 32'h8c09004c;	//
	
	assign	rom[6'h21] = 32'h01094020;	//
	assign	rom[6'h22] = 32'h00000000;	//	
	
	assign	rom[6'h23] = 32'h0000000c;	//	
	assign	rom[6'h24] = 32'h00000000;	//
	
	assign	rom[6'h25] = 32'h0128001a;	//	
	assign	rom[6'h26] = 32'h00000000;	//	
	
	assign	rom[6'h27] = 32'h34040050;	//	
	assign	rom[6'h28] = 32'h20050004;	//
	assign	rom[6'h29] = 32'h00004020;	//
	
	assign	rom[6'h2A] = 32'h8c890000;	//	
	assign	rom[6'h2B] = 32'h20840004;	//
	assign	rom[6'h2C] = 32'h01094020;	//
	assign	rom[6'h2D] = 32'h20a5ffff;	//	
	assign	rom[6'h2E] = 32'h14a0fffb;	//	
	assign	rom[6'h2F] = 32'h00000000;	//	
	
	assign	rom[6'h30] = 32'h08000030;	//	end	
	
	assign	rom[6'h31] = 32'h00000000;	//	49
	assign	rom[6'h32] = 32'h00000000;	//
	assign	rom[6'h33] = 32'h00000000;	//
	assign	rom[6'h34] = 32'h00000000;	//
	assign	rom[6'h35] = 32'h00000000;	//
	assign	rom[6'h36] = 32'h00000000;	//
	assign	rom[6'h37] = 32'h00000000;	//
	assign	rom[6'h38] = 32'h00000000;	//
	assign	rom[6'h39] = 32'h00000000;	//
	assign	rom[6'h3A] = 32'h00000000;	//
	assign	rom[6'h3B] = 32'h00000000;	//
	assign	rom[6'h3C] = 32'h00000000;	//
	assign	rom[6'h3D] = 32'h00000000;	//
	assign	rom[6'h3F] = 32'h00000000;	//
	assign inst = rom[a[7:2]];

endmodule