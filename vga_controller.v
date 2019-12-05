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
                        r_data);

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

///////////// wires
    // wire [1:0] en_0, en_1, en_2, en_3, en_4;
    wire [9:0] addr_x, addr_y;
    wire VGA_CLK_n;
    wire [7:0] index;
    wire [23:0] bgr_data_raw;
    wire cBLANK_n, cHS, cVS, rst;
    wire [23:0] out;
    wire [23:0] bg_edge;
    wire [12:0] randomNum;
    wire [1:0]  en_block; // en[0] for inner, en[1] for edge
    wire [1:0]  shape_en, static_block_en;
    wire stopSign;
    wire [8:0] gridNum;

///////////// Registers
    reg [18:0] ADDR;
    reg [23:0] bgr_data;
    reg [9:0]  ref_x, ref_y;
    reg [23:0] counter;

    // no need in the future
    reg [2:0] offsetLeft, offsetRight;
    reg [2:0] height;
    /////////////////
    reg [2:0]   blockType;
    reg [11:0]  blockNeighbors;
    reg [299:0] grid;
    reg stop;

    parameter size = 16;

    // initialize registers
    initial begin
        ref_x = 320;
        ref_y = 0;
        stop = 0;
        offsetLeft = 0;
        offsetRight = 0;
        height = 0;
        blockType = 0;
        // grid init
        grid[295] = 1;
        grid[0] = 1;
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
    always@(*) begin
        if (stop) begin
            blockType <= randomNum % 5;
        end
    end

    /*************************************
     * Pattern tests
     *************************************/
    shape sp(addr_x, addr_y, ref_x, ref_y, blockNeighbors, 
            shape_en[0], shape_en[1]);

    // static blocks, generate by grid
    static_block stablock(addr_x, addr_y, grid, 
                    static_block_en[0], static_block_en[1]);

    assign en_block[1] = shape_en[1] | static_block_en[1];
    assign en_block[0] = shape_en[0] | static_block_en[0];

    // square sq(addr_x, addr_y, ref_x, ref_y, en_0[0], en_0[1]);
    // longBar lb(addr_x, addr_y, ref_x, ref_y, en_1[0], en_1[1]);
    // TBar tb(addr_x, addr_y, ref_x, ref_y, en_2[0], en_2[1]);
    // ZBlock zb(addr_x, addr_y, ref_x, ref_y, en_3[0], en_3[1]);
    // SBlock sb(addr_x, addr_y, ref_x, ref_y, en_4[0], en_4[1]);

    always@(*) begin
        case(blockType)
            0 : blockNeighbors = 12'h0C6;  // square
            1 : blockNeighbors = 12'h01E;  // long bar
            2 : blockNeighbors = 12'h0E2;  // Tbar
            3 : blockNeighbors = 12'h0C3;  // ZBlock
            4 : blockNeighbors = 12'h066;  // SBlock
        endcase
    end

    // block block(addr_x, addr_y, ref_x, ref_y, en_block[0], en_block[1]);
    // always@(*) begin
    //     case(blockType)
    //         0 : en_block <= en_0;
    //         1 : en_block <= en_1;
    //         2 : en_block <= en_2;
    //         3 : en_block <= en_3;
    //         4 : en_block <= en_4;
    //     endcase
    // end

    // SBlock sb(addr_x, addr_y, ref_x, ref_y, en_block[0], en_block[1], 
    //             offsetLeft, offsetRight, height);

    // counter
    always@(posedge iVGA_CLK) begin
        if (counter == 10000000)
            counter <= 0;
        else
            counter = counter + 1;
    end

    // always@(posedge VGA_CLK_n) begin
    //     if(counter == 10000000) begin
    //         ref_y <= (ref_y + 16 == 480) ? 464 : ref_y + 16; // down
    //     end   
    // end

    // stop sign
    stop_sign(blockNeighbors, ref_x, ref_y, stopSign); // needs grid as input 

    // always@(posedge VGA_CLK_n) begin
    //     if(counter == 10000000) begin
    //         if(!stop) begin
    //             ref_y <= ref_y + 16;
    //         end
    //     end
    //     else begin
    //         ref_y = 0;
    //     end
    // end

    // falling pieces
    always@(posedge VGA_CLK_n) begin
        if(counter == 10000000 && !stop) begin
            ref_y <= ref_y + size;
            stop <= stopSign;
        end
        else if(stop) begin
            ref_y <= 0;
            stop <= 0;
        end
    end

    always@(posedge VGA_CLK_n) begin
        if(stop) begin
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
                grid[gridNum + 20]   <= 1'b1;

            if(blockNeighbors[10])
                grid[gridNum + 21] <= 1'b1;

            if(blockNeighbors[11])
                grid[gridNum + 30]   <= 1'b1;
        end
    end


    // key binding
    always@(posedge VGA_CLK_n) begin
        if ( key_en ) begin
            case(key_in)
                // 8'h75 : ref_y = (ref_y == 0) ? 0 : ref_y - 10;
                // 8'h72 : ref_y = ref_y + 16;
                8'h6b : ref_x = (ref_x == 240) ? 
                        240 + offsetLeft  * size : ref_x - size;
                8'h74 : ref_x = (ref_x + offsetRight * size == 400) ? 
                        400 - offsetRight * size : ref_x + size;
            endcase
        end
    end

//////////////////////////
//////INDEX addr.
    assign VGA_CLK_n = ~iVGA_CLK;
    img_data    img_data_inst (
        .address ( ADDR ),
        .clock ( VGA_CLK_n ),
        .q ( index )
        );

/////////////////////////
//////Add switch-input logic here
    decoder decode(ADDR, addr_x, addr_y); // ADDR => x, y coordinate
    coord2ind coordinate2gridNum(ref_x, ref_y, gridNum); // ref x y to index

    // first edge, then block
    mux_24bit mux_block_edge (bgr_data_raw, 24'h000000, en_block[1], bg_edge);
    mux_24bit mux_block_inner(bg_edge,      24'h00004F, en_block[0], out);

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
