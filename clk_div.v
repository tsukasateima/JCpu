module clk_div (clk_in, clk_out);
input clk_in;
output reg clk_out = 0;
reg[30:0] cnt;
always @ (posedge clk_in)
begin
	if (cnt == 'd12500000)
	begin
		cnt = 0;
		clk_out = ~clk_out;
	end
	else
		cnt = cnt + 1;
end
endmodule
