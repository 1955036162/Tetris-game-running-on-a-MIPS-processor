module ind2coord(
    input  [4:0] ind_i, ind_j,   // indices
    output [9:0] cor_x, cor_y  // coordinates
    );

    parameter size = 16;

    assign cor_x = ind_i * size + 240;
    assign cor_y = ind_j * size;

endmodule
