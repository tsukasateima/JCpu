module dffe32(d, clk, clrn, e, q);
input      [31:0] d;
input             clk, clrn, e;
output reg [31:0] q;

always@(posedge clk or negedge clrn)
begin
	if(clrn == 0) begin 
		q <= 0;
	end else if(e == 1) begin 
		q <= d;
	end
end
endmodule
