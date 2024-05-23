module display(sum,HEX0);
input [3:0] sum;
output reg [6:0] HEX0;
always @(*)
begin
	case(sum)
	4'd0:HEX0=7'b0000001;
	4'd1:HEX0=7'b1001111;
	4'd2:HEX0=7'b0010010;
	4'd3:HEX0=7'b0000110;
	4'd4:HEX0=7'b1001100;
	4'd5:HEX0=7'b0100100;
	4'd6:HEX0=7'b0100000;
	4'd7:HEX0=7'b0001111;
	4'd8:HEX0=7'b0000000;
	4'd9:HEX0=7'b0001100;
	4'd10:HEX0=7'b0001000;
	4'd11:HEX0=7'b1100000;
	4'd12:HEX0=7'b0110001;
	4'd13:HEX0=7'b1000010;
	4'd14:HEX0=7'b0110000;
	4'd15:HEX0=7'b0111000;
	default:HEX0=7'h7F;
	endcase
end
endmodule
