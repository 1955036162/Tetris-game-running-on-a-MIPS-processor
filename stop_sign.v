module stop_sign(
    input  [11:0]  blockNeighbors,
    input  [9:0]   ref_y,
    input  [9:0]   gridNum,
    input  [299:0] grid,
    output reg stop
    );

    parameter size = 16;

    always@(*) begin
        if     (blockNeighbors[11] && grid[gridNum+40]) stop = 1;
        else if(blockNeighbors[10] && grid[gridNum+31]) stop = 1;
        else if(blockNeighbors[9]  && grid[gridNum+30]) stop = 1;
        else if(blockNeighbors[8]  && grid[gridNum+29]) stop = 1;
        else if(blockNeighbors[7]  && grid[gridNum+21]) stop = 1;
        else if(blockNeighbors[6]  && grid[gridNum+20]) stop = 1;
        else if(blockNeighbors[5]  && grid[gridNum+19]) stop = 1;
        else if(blockNeighbors[4]  && grid[gridNum+13]) stop = 1;
        else if(blockNeighbors[3]  && grid[gridNum+12]) stop = 1;
        else if(blockNeighbors[2]  && grid[gridNum+11]) stop = 1;
        else if(blockNeighbors[1]  && grid[gridNum+10]) stop = 1;
        else if(blockNeighbors[0]  && grid[gridNum+9] ) stop = 1;

        else if(blockNeighbors[11]   && ref_y + 4*size >= 480) stop = 1;
        else if(blockNeighbors[10:8] && ref_y + 3*size >= 480) stop = 1;
        else if(blockNeighbors[7:5]  && ref_y + 2*size >= 480) stop = 1;
        else if(blockNeighbors[4:0]  && ref_y +   size >= 480) stop = 1;
        else stop = 0;
    end

endmodule
