module program_counter(in, out, clk, reset);

    input [31:0] in;
    input clk, reset;

    output [31:0] out;

    dffe_ref dff_0(out[0], in[0], clk, reset);
    dffe_ref dff_1(out[1], in[1], clk, reset);
    dffe_ref dff_2(out[2], in[2], clk, reset);
    dffe_ref dff_3(out[3], in[3], clk, reset);
    dffe_ref dff_4(out[4], in[4], clk, reset);
    dffe_ref dff_5(out[5], in[5], clk, reset);
    dffe_ref dff_6(out[6], in[6], clk, reset);
    dffe_ref dff_7(out[7], in[7], clk, reset);
    dffe_ref dff_8(out[8], in[8], clk, reset);
    dffe_ref dff_9(out[9], in[9], clk, reset);
    dffe_ref dff_10(out[10], in[10], clk, reset);
    dffe_ref dff_11(out[11], in[11], clk, reset);
    dffe_ref dff_12(out[12], in[12], clk, reset);
    dffe_ref dff_13(out[13], in[13], clk, reset);
    dffe_ref dff_14(out[14], in[14], clk, reset);
    dffe_ref dff_15(out[15], in[15], clk, reset);
    dffe_ref dff_16(out[16], in[16], clk, reset);
    dffe_ref dff_17(out[17], in[17], clk, reset);
    dffe_ref dff_18(out[18], in[18], clk, reset);
    dffe_ref dff_19(out[19], in[19], clk, reset);
    dffe_ref dff_20(out[20], in[20], clk, reset);
    dffe_ref dff_21(out[21], in[21], clk, reset);
    dffe_ref dff_22(out[22], in[22], clk, reset);
    dffe_ref dff_23(out[23], in[23], clk, reset);
    dffe_ref dff_24(out[24], in[24], clk, reset);
    dffe_ref dff_25(out[25], in[25], clk, reset);
    dffe_ref dff_26(out[26], in[26], clk, reset);
    dffe_ref dff_27(out[27], in[27], clk, reset);
    dffe_ref dff_28(out[28], in[28], clk, reset);
    dffe_ref dff_29(out[29], in[29], clk, reset);
    dffe_ref dff_30(out[30], in[30], clk, reset);
    dffe_ref dff_31(out[31], in[31], clk, reset);

endmodule
