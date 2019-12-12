module mux_5bit(a, b, s, o);

    input  [4:0] a, b; // input a, b
    input  s;          // selector
    output [4:0] o;    // o = as + bs'

    mux_1bit mux0(a[0], b[0], s, o[0]);
    mux_1bit mux1(a[1], b[1], s, o[1]);
    mux_1bit mux2(a[2], b[2], s, o[2]);
    mux_1bit mux3(a[3], b[3], s, o[3]);
    mux_1bit mux4(a[4], b[4], s, o[4]);

endmodule
