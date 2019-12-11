module shape(
    input [9:0]  addr_x, addr_y,
    input [9:0]  ref_x, ref_y,
    input [11:0] blockNeighbors,
    output toShowShapeInner, toShowShapeEdge
    );

    parameter size = 16;

    wire [11:0] en_i_origin, en_e_origin, en_i, en_e;

    block b0(addr_x, addr_y, ref_x - size, ref_y, en_i_origin[0], en_e_origin[0]);
    block b1(addr_x, addr_y, ref_x, ref_y, en_i_origin[1], en_e_origin[1]);
    block b2(addr_x, addr_y, ref_x + size, ref_y, en_i_origin[2], en_e_origin[2]);
    block b3(addr_x, addr_y, ref_x + 2*size, ref_y, en_i_origin[3], en_e_origin[3]);
    block b4(addr_x, addr_y, ref_x + 3*size, ref_y, en_i_origin[4], en_e_origin[4]);
    block b5(addr_x, addr_y, ref_x - size, ref_y + size, en_i_origin[5], en_e_origin[5]);
    block b6(addr_x, addr_y, ref_x, ref_y + size, en_i_origin[6], en_e_origin[6]);
    block b7(addr_x, addr_y, ref_x + size, ref_y + size, en_i_origin[7], en_e_origin[7]);
    block b8(addr_x, addr_y, ref_x - size, ref_y + 2*size, en_i_origin[8], en_e_origin[8]);
    block b9(addr_x, addr_y, ref_x, ref_y + 2*size, en_i_origin[9], en_e_origin[9]);
    block b10(addr_x, addr_y, ref_x + size, ref_y + 2*size, en_i_origin[10], en_e_origin[10]);
    block b11(addr_x, addr_y, ref_x, ref_y + 3*size, en_i_origin[11], en_e_origin[11]);

    assign en_i = en_i_origin & blockNeighbors;
    assign en_e = en_e_origin & blockNeighbors;

    assign toShowShapeInner = en_i ? 1 : 0;
    assign toShowShapeEdge  = en_e ? 1 : 0;

    // assign toShowShapeInner = en_i[0] | en_i[1] | en_i[2] | en_i[3] | en_i[4] |
    //                         en_i[5] | en_i[6] | en_i[7] | en_i[8] | en_i[9] |
    //                         en_i[10] | en_i[11];
    // assign toShowShapeEdge  = en_e[0] | en_e[1] | en_e[2] | en_e[3] | en_e[4] |
    //                         en_e[5] | en_e[6] | en_e[7] | en_e[8] | en_e[9] |
    //                         en_e[10] | en_e[11];

endmodule
