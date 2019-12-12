module mux_4_1_32bit(in0, in1, in2, in3, s, out);

    input  [31:0] in0, in1, in2, in3;
    input  [1:0]  s;
    output [31:0] out;
    wire   [31:0] out1, out2;

    mux_32bit m0(in0, in1, s[0], out1);
    mux_32bit m1(in2, in3, s[0], out2);
    mux_32bit m2(out1, out2, s[1], out);

endmodule
