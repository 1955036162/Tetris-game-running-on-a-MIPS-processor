module coord2ind(
    input  [9:0] cor_x, cor_y,  // coordinates
    output [8:0] ind_i          // index
    );

    parameter size = 16;

    assign ind_i = (cor_x - 240) / size + (cor_y / size) * 10;

endmodule
