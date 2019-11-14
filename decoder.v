module decoder(addr, x, y);

	input [18:0] addr;

	output [9:0] x, y;

	assign x = addr % 640;
	assign y = addr / 640;

endmodule
