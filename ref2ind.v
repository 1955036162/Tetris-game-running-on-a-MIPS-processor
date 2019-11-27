module ref2ind(
    input [9:0] ref_x, ref_y,  // reference point coordinates
    output [4:0] ind_i, ind_j  // index
    );

    parameter size = 16;

    assign ind_i = (ref_x - 240) / size;
    assign ind_j = ref_y / size;

endmodule
