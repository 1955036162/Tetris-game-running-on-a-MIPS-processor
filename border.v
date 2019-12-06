module border(
    input  [9:0] addr_x,
    output en
    );

    assign en = (addr_x == 239 || addr_x == 400) ? 1 : 0;

endmodule