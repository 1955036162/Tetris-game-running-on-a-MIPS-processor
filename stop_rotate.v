module stop_rotate(
    input  [3:0]   blockType,
    input  [9:0]   ref_x, ref_y,
    input  [9:0]   gridNum,
    input  [299:0] grid,
    output reg stop
    );

    parameter size = 16;

    reg [11:0] blockNeighbors;

    always@(*) begin
        case(blockType)
            0 : blockNeighbors = 12'h0C6;  // square
            1 : blockNeighbors = 12'h01E;  // long bar horizontal
            2 : blockNeighbors = 12'hA42;  // long bar vertical
            3 : blockNeighbors = 12'h0E2;  // Tbar face up
            4 : blockNeighbors = 12'h2C2;  // Tbar face right
            5 : blockNeighbors = 12'h047;  // Tbar face down
            6 : blockNeighbors = 12'h262;  // Tbar face left
            7 : blockNeighbors = 12'h0C3;  // ZBlock horizontal
            8 : blockNeighbors = 12'h162;  // ZBlock vertical
            9 : blockNeighbors = 12'h066;  // SBlock horizontal
            10: blockNeighbors = 12'h4C2;  // SBlock vertical
        endcase
    end

    always@(*) begin
        if     (blockNeighbors[11] && grid[gridNum+30]) stop = 1;
        else if(blockNeighbors[10] && grid[gridNum+21]) stop = 1;
        else if(blockNeighbors[9]  && grid[gridNum+20]) stop = 1;
        else if(blockNeighbors[8]  && grid[gridNum+19]) stop = 1;
        else if(blockNeighbors[7]  && grid[gridNum+11]) stop = 1;
        else if(blockNeighbors[6]  && grid[gridNum+10]) stop = 1;
        else if(blockNeighbors[5]  && grid[gridNum+9])  stop = 1;
        else if(blockNeighbors[4]  && grid[gridNum+3])  stop = 1;
        else if(blockNeighbors[3]  && grid[gridNum+2])  stop = 1;
        else if(blockNeighbors[2]  && grid[gridNum+1])  stop = 1;
        else if(blockNeighbors[1]  && grid[gridNum])    stop = 1;
        else if(blockNeighbors[0]  && grid[gridNum-1])  stop = 1;
        // down
        else if(blockNeighbors[11]   && ref_y + 3*size >= 480) stop = 1;
        else if(blockNeighbors[10:8] && ref_y + 2*size >= 480) stop = 1;
        else if(blockNeighbors[7:5]  && ref_y + 1*size >= 480) stop = 1;
        else if(blockNeighbors[4:0]  && ref_y          >= 480) stop = 1;
        // left
        else if( (blockNeighbors[0] || blockNeighbors[5] || blockNeighbors[8]) &&
            ref_x <= 240 ) stop = 1;
        else if( (blockNeighbors[1] || blockNeighbors[6] || blockNeighbors[9] || 
            blockNeighbors[11]) && ref_x + size <= 240 ) stop = 1;
        // right
        else if( blockNeighbors[4] && ref_x + 3*size >= 400) stop = 1;
        else if( (blockNeighbors[2] || blockNeighbors[7] || blockNeighbors[10])
            && ref_x + size >= 400 ) stop = 1;
        else if( (blockNeighbors[1] || blockNeighbors[6] || blockNeighbors[9] || 
            blockNeighbors[11]) && ref_x >= 400 ) stop = 1;

        else stop = 0;
    end


endmodule
