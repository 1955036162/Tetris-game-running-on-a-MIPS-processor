module alu_plus1(in, out);

    input [31:0] in;
    output [31:0] out;
    wire isNotEqual, isLessThan, overflow;

    alu alu0(in, 32'h00000001, 5'b00000, 5'b00000, out, isNotEqual, 
        isLessThan, overflow);

endmodule
