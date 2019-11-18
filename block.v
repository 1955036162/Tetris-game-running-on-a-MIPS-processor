/*
    single block
    addr: current pixel
    ref: up-left corner pixel of the block
    en: en = 1 when addr is in the block
*/

module block(
    input [9:0] addr_x, addr_y,
    input [9:0] ref_x, ref_y,
    output en_inner, en_edge
    );

    parameter size = 16;

    assign en_inner = (addr_x >= ref_x+1 && addr_x < ref_x + size-1 && 
                    addr_y >= ref_y+1 && addr_y < ref_y + size-1) ? 1 : 0;

    assign en_edge  = (addr_x >= ref_x && addr_x < ref_x + size && 
                    addr_y >= ref_y && addr_y < ref_y + size) ? 1 : 0;

    // assign en_edge = ((addr_x == ref_x || addr_x == ref_x + size-1) && 
    //                 addr_y >= ref_y && addr_y < ref_y + size) || 
    //                 ((addr_y == ref_y || addr_y == ref_y + size-1) && 
    //                 addr_x >= ref_x && addr_x < ref_x + size) ? 1 : 0;

endmodule
