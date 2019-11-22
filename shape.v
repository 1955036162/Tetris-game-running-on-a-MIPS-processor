module shape(
    input [9:0] addr_x, addr_y,
    input [9:0] ref_x, ref_y,
    input [11:0] blockNeighbors,
    output toShowShapeInner, toShowShapeEdge
    );

    parameter size = 16;

    assign blockNeighbors[1] = 1'b1;

    wire [11:0] en_i_origin, en_e_origin;

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

    integer i;

    initial begin
        for(i=0; i<12; i = i + 1) begin
            if(en_i_origin[i] & blockNeighbors[i]) begin
                assign toShowShapeInner = 1'b1;
            end
            if (en_e_origin[i] & blockNeighbors[i]) begin
                assign toShowShapeEdge  = 1'b1;
            end
        end
    end

endmodule
