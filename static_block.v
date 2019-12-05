module static_block(
    input  [9:0] addr_x, addr_y,
    input  [299:0] grid,
    output toShowShapeInner, toShowShapeEdge
    );

    wire [299:0] en_i_origin, en_e_origin, en_i, en_e;

    parameter GRIDNUM = 300;
    parameter size = 16;

    genvar i;

    generate 
        for (i=0; i<GRIDNUM; i = i+1) begin : block_generator
        block b0(addr_x, addr_y, (i%10)*size+240, (i/10)*size, 
            en_i_origin[i], en_e_origin[i]);
        end
    endgenerate

    assign en_i = en_i_origin & grid;
    assign en_e = en_e_origin & grid;

    assign toShowShapeInner = en_i ? 1 : 0;
    assign toShowShapeEdge  = en_e ? 1 : 0;

endmodule
