module alu_plusn(in, n, out);

    input  [31:0] in, n;
    output [31:0] out;
    wire isNotEqual, isLessThan, overflow;

    alu alu0(in, n, 5'b00000, 5'b00000, out, isNotEqual,
        isLessThan, overflow);

endmodule
