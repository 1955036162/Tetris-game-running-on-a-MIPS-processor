module stop_sign(
    input  [11:0] blockNeighbors,
    input  [9:0] ref_x, ref_y,
    // input  grid  border testing
    output reg stop
    );

    parameter size = 16;

    always@(*) begin
        if(blockNeighbors[11] && ref_y + 4*size == 480) begin
            stop = 1;
        end
        else if((blockNeighbors[8] || blockNeighbors[9] || blockNeighbors[10]) && 
                ref_y + 3*size == 480) begin
            stop = 1;
        end
        else if((blockNeighbors[5] || blockNeighbors[6] || blockNeighbors[7]) && 
                ref_y + 2*size == 480) begin
            stop = 1;
        end
        else if((blockNeighbors[0] || blockNeighbors[1] || blockNeighbors[2] ||
                blockNeighbors[3] || blockNeighbors[4]) && ref_y + size == 480) 
        begin
            stop = 1;
        end
        else begin
            stop = 0;
        end
    end

endmodule
