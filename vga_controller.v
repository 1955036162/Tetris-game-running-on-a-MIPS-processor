module vga_controller(  iRST_n,
                        iVGA_CLK,
                        key_in,
                        key_en,
                        // key_up,
                        // key_down,
                        // key_left,
                        // key_right,
                        oBLANK_n,
                        oHS,
                        oVS,
                        b_data,
                        g_data,
                        r_data,
                        data_readReg1,
                        data_readReg2,
                        addPoints,
                        blockType,
                        rotate,
                        fromGame,
                        fromProc
                        );

    input [7:0] key_in;
    input key_en;
    input iRST_n;
    input iVGA_CLK;
    // input key_up, key_down, key_left, key_right;
    output reg oBLANK_n;
    output reg oHS;
    output reg oVS;
    output [7:0] b_data;
    output [7:0] g_data;
    output [7:0] r_data;
    // self defined
    input  [31:0] data_readReg1, data_readReg2;
    input  [31:0] fromProc;
    output reg       rotate;
    output reg [2:0] addPoints;
    output reg [3:0] blockType;
    output reg [1:0] fromGame; // fG[0] for points, fG[1] for blockType

///////////// wires
    wire [9:0] addr_x, addr_y;
    wire VGA_CLK_n;
    wire [7:0] index;
    wire [23:0] bgr_data_raw;
    wire cBLANK_n, cHS, cVS, rst;
    wire [23:0] out;
    wire [23:0] bg_edge, bg_inner;
    wire [12:0] randomNum;
    wire [1:0]  en_block; // en[0] for inner, en[1] for edge
    wire [1:0]  shape_en, static_block_en, dlow_en, dhigh_en;
    wire stopSign;
    wire stopLeft, stopRight;
    wire stopRotate;
    wire [8:0] gridNum;
    wire gameOver;
    wire en_border;

///////////// Registers
    reg [18:0] ADDR;
    reg [23:0] bgr_data;
    reg [9:0]  ref_x, ref_y;
    reg [23:0] counter;
    /////////////////
    reg [11:0]  blockNeighbors;
    reg [299:0] grid;
    reg [2:0]   pointCounter;
    reg key_pressed;
    // reg stopRotate;

    parameter size = 16;
    parameter GRIDNUM = 299;
    parameter FREQUENCY = 10000000;

    // initialize registers
    initial begin
        ref_x = 320;
        ref_y = 0;
        blockType = 0; // square
        grid = 0;
        pointCounter = 0;
        key_pressed = 1'b0;
        // stopRotate = 1'b0;
    end

////
    assign rst = ~iRST_n;
    video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                                  .reset(rst),
                                  .blank_n(cBLANK_n),
                                  .HS(cHS),
                                  .VS(cVS));
////

////Addresss generator
    always@(posedge iVGA_CLK, negedge iRST_n) begin
        if (!iRST_n)
            ADDR<=19'd0;
        else if (cHS==1'b0 && cVS==1'b0)
            ADDR<=19'd0;
        else if (cBLANK_n==1'b1)
            ADDR<=ADDR+1;
    end

    LFSR pseudoRandomGenerator(randomNum, 1'b1, iVGA_CLK);

    /*************************************
     * Pattern tests
     *************************************/
    // falling shape, generate by blockNeighbors
    shape sp(addr_x, addr_y, ref_x, ref_y, blockNeighbors, 
            shape_en[0], shape_en[1]);
    // static blocks, generate by grid
    static_block stblock(addr_x, addr_y, grid, 
                    static_block_en[0], static_block_en[1]);
    // score
    digit dlow (addr_x, addr_y, 576, 16, data_readReg1[6:0] % 10, dlow_en[0],  dlow_en[1]);
    digit dhigh(addr_x, addr_y, 512, 16, data_readReg1[6:0] / 10, dhigh_en[0], dhigh_en[1]);
    // display both falling and static blocks
    assign en_block = shape_en & {!gameOver, !gameOver} | static_block_en | dlow_en | dhigh_en;

    always@(posedge VGA_CLK_n) begin
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

    // counter
    always@(posedge iVGA_CLK) begin
        if (counter == FREQUENCY)
            counter <= 0;
        else
            counter = counter + 1;
    end

    // stop sign
    stop_sign   sdsign(blockNeighbors, ref_y, gridNum, grid, stopSign);
    stop_left   slsign(blockNeighbors, ref_x, gridNum, grid, stopLeft);
    stop_right  srsign(blockNeighbors, ref_x, gridNum, grid, stopRight);
    stop_rotate srtsign(data_readReg2[3:0], ref_x, ref_y, gridNum, grid, stopRotate);

    // falling pieces
    always@(posedge VGA_CLK_n) begin
        if(counter == FREQUENCY) begin
            if(!stopSign) begin
                ref_y = ref_y + size;
            end
            else begin
                ref_y = 0;
                ref_x = 320;
                blockType = randomNum % 11;
            end
        end
        else begin
            if(key_en) begin
            key_pressed = 1'b1;
            end
            else if(key_pressed && !stopSign) begin
                case(key_in)
                    8'h75 : begin rotate = 1'b1; fromGame[1] = 1'b1; 
                                  key_pressed = 1'b0;
                            end
                    8'h72 : begin ref_y = ref_y + size;                       key_pressed = 1'b0; end
                    8'h6b : begin ref_x = stopLeft  ? ref_x+0 : ref_x - size; key_pressed = 1'b0; end
                    8'h74 : begin ref_x = stopRight ? ref_x+0 : ref_x + size; key_pressed = 1'b0; end
                endcase
            end
            else begin
                fromGame[1] = 1'b0;
                rotate = 1'b0;
            end
            blockType = stopRotate || !fromProc[0] ? blockType+0 : data_readReg2[3:0];
        end
    end

    always@(posedge VGA_CLK_n) begin
        if(counter % 4 == 0) begin
            // store static blocks
            if(stopSign && !gameOver) begin
                grid[gridNum] <= 1'b1;  // ref block, always 1

                if(blockNeighbors[0])
                    grid[gridNum - 1] <= 1'b1;

                if(blockNeighbors[2])
                    grid[gridNum + 1] <= 1'b1;

                if(blockNeighbors[3])
                    grid[gridNum + 2] <= 1'b1;

                if(blockNeighbors[4])
                    grid[gridNum + 3] <= 1'b1;

                if(blockNeighbors[5])
                    grid[gridNum + 9] <= 1'b1;

                if(blockNeighbors[6])
                    grid[gridNum + 10] <= 1'b1;

                if(blockNeighbors[7])
                    grid[gridNum + 11] <= 1'b1;

                if(blockNeighbors[8])
                    grid[gridNum + 19] <= 1'b1;

                if(blockNeighbors[9])
                    grid[gridNum + 20] <= 1'b1;

                if(blockNeighbors[10])
                    grid[gridNum + 21] <= 1'b1;

                if(blockNeighbors[11])
                    grid[gridNum + 30] <= 1'b1;
            end
            // clear lines
            else begin
                // for loop, detect full lines
                integer i, j;
                for(i=0; i<GRIDNUM; i = i+10) begin
                    // one line is full
                    if(grid[i +: 10]==10'b1111111111) begin
                        // add 1 point
                        pointCounter = pointCounter + 1;
                        // lines fall
                        for(j=i; j>=10; j = j-10) begin
                            grid[j +: 10] = grid[j-10 +: 10];
                        end
                    end
                end
                if (pointCounter) begin
                    addPoints = pointCounter;
                    fromGame[0] = 1'b1;
                    // reset pointCounter
                    pointCounter = 1'b0;
                end
                else begin
                    fromGame[0] = 1'b0;
                    addPoints = 1'b0;
                end
            end
        end
    end

    decoder   decode(ADDR, addr_x, addr_y); // ADDR => x, y coordinate
    coord2ind coordinate2gridNum(ref_x, ref_y, gridNum); // ref x y to index
    border    bd(addr_x, en_border);

    /* MUXES */
    // first edge, then block
    mux_24bit mux_block_edge (bgr_data_raw, 24'h000000, en_block[1], bg_edge);
    mux_24bit mux_block_inner(bg_edge,      24'h00004F, en_block[0], bg_inner);
    mux_24bit mux_border(bg_inner, 24'h004F00, en_border, out);
//////////////////////////

    // if reach the top, game over
    game_over ggwp(blockNeighbors, gridNum, grid, gameOver);
    // assign gameOver = grid[9:0] ? 1 : 0;

//////INDEX addr.
    assign VGA_CLK_n = ~iVGA_CLK;
    img_data img_data_inst (
        .address ( ADDR ),
        .clock ( VGA_CLK_n ),
        .q ( index )
        );

/////////////////////////

//////Color table output
    img_index img_index_inst (
        .address ( index ),
        .clock ( iVGA_CLK ),
        .q ( bgr_data_raw )
        );
//////

//////latch valid data at falling edge;
    always@(posedge VGA_CLK_n) bgr_data <= out;
    assign b_data = bgr_data[23:16];
    assign g_data = bgr_data[15:8];
    assign r_data = bgr_data[7:0];
///////////////////

//////Delay the iHD, iVD,iDEN for one clock cycle;
    always@(negedge iVGA_CLK) begin
        oHS<=cHS;
        oVS<=cVS;
        oBLANK_n<=cBLANK_n;
    end

endmodule
