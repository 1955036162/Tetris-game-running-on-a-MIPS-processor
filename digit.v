module digit(
    input [9:0]  addr_x, addr_y,
    input [9:0]  ref_x, ref_y,
    input [3:0]  number,
    output toShowScoreInner, toShowScoreEdge
    );

    parameter size = 16;

    wire [12:0] en_i_origin, en_e_origin, en_i, en_e;

    reg  [12:0] blockNeighbors;

    always@(*) begin
        case(number)
            0 : blockNeighbors = 13'b1_1111_1011_1111;
            1 : blockNeighbors = 13'b1_0010_1001_0100;
            2 : blockNeighbors = 13'b1_1101_1111_0111;
            3 : blockNeighbors = 13'b1_1110_1111_0111;
            4 : blockNeighbors = 13'b1_0010_1111_1101;
            5 : blockNeighbors = 13'b1_1110_1110_1111;
            6 : blockNeighbors = 13'b1_1111_1110_1111;
            7 : blockNeighbors = 13'b1_0010_1001_0111;
            8 : blockNeighbors = 13'b1_1111_1111_1111;
            9 : blockNeighbors = 13'b1_1110_1111_1111;
        endcase // number
    end


    block b0(addr_x, addr_y, ref_x, ref_y, en_i_origin[0], en_e_origin[0]);
    block b1(addr_x, addr_y, ref_x + size, ref_y, en_i_origin[1], en_e_origin[1]);
    block b2(addr_x, addr_y, ref_x + 2*size, ref_y, en_i_origin[2], en_e_origin[2]);
    block b3(addr_x, addr_y, ref_x , ref_y + size, en_i_origin[3], en_e_origin[3]);
    block b4(addr_x, addr_y, ref_x + 2*size, ref_y + size, en_i_origin[4], en_e_origin[4]);
    block b5(addr_x, addr_y, ref_x, ref_y + 2*size, en_i_origin[5], en_e_origin[5]);
    block b6(addr_x, addr_y, ref_x + size, ref_y + 2*size, en_i_origin[6], en_e_origin[6]);
    block b7(addr_x, addr_y, ref_x + 2*size, ref_y + 2*size, en_i_origin[7], en_e_origin[7]);
    block b8(addr_x, addr_y, ref_x, ref_y + 3*size, en_i_origin[8], en_e_origin[8]);
    block b9(addr_x, addr_y, ref_x + 2*size, ref_y + 3*size, en_i_origin[9], en_e_origin[9]);
    block b10(addr_x, addr_y, ref_x, ref_y + 4*size, en_i_origin[10], en_e_origin[10]);
    block b11(addr_x, addr_y, ref_x + size, ref_y + 4*size, en_i_origin[11], en_e_origin[11]);
    block b12(addr_x, addr_y, ref_x + 2*size, ref_y + 4*size, en_i_origin[12], en_e_origin[12]);

    assign en_i = en_i_origin & blockNeighbors;
    assign en_e = en_e_origin & blockNeighbors;

    assign toShowScoreInner = en_i ? 1 : 0;
    assign toShowScoreEdge  = en_e ? 1 : 0;

endmodule