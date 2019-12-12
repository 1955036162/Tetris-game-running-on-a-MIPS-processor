module stop_right(
    input  [11:0]  blockNeighbors,
    input  [9:0]   ref_x,
    input  [9:0]   gridNum,
    input  [299:0] grid,
    output reg stop
    );

    parameter size = 16;

    always@(*) begin
        if     (blockNeighbors[11] && grid[gridNum+31]) stop = 1;
        else if(blockNeighbors[10] && grid[gridNum+22]) stop = 1;
        else if(blockNeighbors[9]  && grid[gridNum+21]) stop = 1;
        else if(blockNeighbors[8]  && grid[gridNum+20]) stop = 1;
        else if(blockNeighbors[7]  && grid[gridNum+12]) stop = 1;
        else if(blockNeighbors[6]  && grid[gridNum+11]) stop = 1;
        else if(blockNeighbors[5]  && grid[gridNum+10]) stop = 1;
        else if(blockNeighbors[4]  && grid[gridNum+4] ) stop = 1;
        else if(blockNeighbors[2]  && grid[gridNum+2] ) stop = 1;
        else if(blockNeighbors[1]  && grid[gridNum+1] ) stop = 1;
        else if(blockNeighbors[0]  && grid[gridNum]   ) stop = 1;

        else if( blockNeighbors[4] && ref_x + 4*size >= 400) stop = 1;
        else if( (blockNeighbors[2] || blockNeighbors[7] || blockNeighbors[10])
            && ref_x + 2*size >= 400 ) stop = 1;
        else if( (blockNeighbors[1] || blockNeighbors[6] || blockNeighbors[9] || 
            blockNeighbors[11]) && ref_x + size >= 400 ) stop = 1;
        
        else stop = 0;
    end

endmodule
