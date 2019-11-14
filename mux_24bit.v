module mux_24bit(in1, in2, en, out);

	input  [23:0] in1, in2;
	input  en;

	output [23:0] out;

	assign out = en ? in2 : in1;

endmodule
