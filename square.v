module square(
    input [9:0] addr_x, addr_y,
    input [9:0] ref_x, ref_y,
    output en_inner, en_edge
    );

    parameter size = 16;

    wire [3:0] en_i, en_e; 
    // index 0: upleft, index 1: upright, index 2: bottemleft, index 3: bottemright

    block upLeft(addr_x, addr_y, ref_x, ref_y, en_i[0], en_e[0]);
    block upRight(addr_x, addr_y, ref_x + size, ref_y, en_i[1], en_e[1]);
    block bottemLeft(addr_x, addr_y, ref_x, ref_y + size, en_i[2], en_e[2]);
    block bottemRight(addr_x, addr_y, ref_x + size, ref_y + size, en_i[3], en_e[3]);

    assign en_inner = en_i[0] || en_i[1] || en_i[2] || en_i[3];
    assign en_edge  = en_e[0] || en_e[1] || en_e[2] || en_e[3];

endmodule