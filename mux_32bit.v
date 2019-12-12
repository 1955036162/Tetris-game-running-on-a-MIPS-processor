module mux_32bit(a, b, s, o);

    input  [31:0] a, b;  // input a, b
    input  s;            // selector
    output [31:0] o;     // o = as + bs'

    mux_1bit mux0(a[0], b[0], s, o[0]);
    mux_1bit mux1(a[1], b[1], s, o[1]);
    mux_1bit mux2(a[2], b[2], s, o[2]);
    mux_1bit mux3(a[3], b[3], s, o[3]);
    mux_1bit mux4(a[4], b[4], s, o[4]);
    mux_1bit mux5(a[5], b[5], s, o[5]);
    mux_1bit mux6(a[6], b[6], s, o[6]);
    mux_1bit mux7(a[7], b[7], s, o[7]);
    mux_1bit mux8(a[8], b[8], s, o[8]);
    mux_1bit mux9(a[9], b[9], s, o[9]);
    mux_1bit mux10(a[10], b[10], s, o[10]);
    mux_1bit mux11(a[11], b[11], s, o[11]);
    mux_1bit mux12(a[12], b[12], s, o[12]);
    mux_1bit mux13(a[13], b[13], s, o[13]);
    mux_1bit mux14(a[14], b[14], s, o[14]);
    mux_1bit mux15(a[15], b[15], s, o[15]);
    mux_1bit mux16(a[16], b[16], s, o[16]);
    mux_1bit mux17(a[17], b[17], s, o[17]);
    mux_1bit mux18(a[18], b[18], s, o[18]);
    mux_1bit mux19(a[19], b[19], s, o[19]);
    mux_1bit mux20(a[20], b[20], s, o[20]);
    mux_1bit mux21(a[21], b[21], s, o[21]);
    mux_1bit mux22(a[22], b[22], s, o[22]);
    mux_1bit mux23(a[23], b[23], s, o[23]);
    mux_1bit mux24(a[24], b[24], s, o[24]);
    mux_1bit mux25(a[25], b[25], s, o[25]);
    mux_1bit mux26(a[26], b[26], s, o[26]);
    mux_1bit mux27(a[27], b[27], s, o[27]);
    mux_1bit mux28(a[28], b[28], s, o[28]);
    mux_1bit mux29(a[29], b[29], s, o[29]);
    mux_1bit mux30(a[30], b[30], s, o[30]);
    mux_1bit mux31(a[31], b[31], s, o[31]);

endmodule
