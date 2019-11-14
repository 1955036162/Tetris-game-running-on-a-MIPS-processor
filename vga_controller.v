module vga_controller(iRST_n,
                      iVGA_CLK,
							 key_up,
							 key_down,
							 key_left,
							 key_right,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data);

input iRST_n;
input iVGA_CLK;
input key_up, key_down, key_left, key_right;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;

/////////////
reg [18:0] ADDR;
reg [23:0] bgr_data;
reg [9:0]  x, y;
wire en;
reg [23:0]counter;
wire [9:0] addr_x, addr_y;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n, cHS, cVS, rst;
wire [23:0] out;

// initialize x y register
initial begin
  x = 320;
  y = 240;
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

always@(posedge iVGA_CLK, negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end

assign en = (addr_x >= x && addr_x <= x + 64 && addr_y >= y && addr_y <= y + 48) ? 1 : 0;

always@(posedge iVGA_CLK)
begin
	if (counter == 5000000)
		counter <= 0;
	else
		counter = counter + 1;
end

// key binding
always@(posedge VGA_CLK_n)
begin
  if (!key_up && counter == 5000000)
    y = y - 10;
  if (!key_down && counter == 5000000)
    y = y + 10;
  if (!key_left && counter == 5000000)
    x = x - 10;
  if (!key_right && counter == 5000000)
    x = x + 10;
end

//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);

/////////////////////////
//////Add switch-input logic here
decoder decode(ADDR, addr_x, addr_y); // ADDR => x, y coordinate

mux_24bit mux1(bgr_data_raw, 24'hFFFF00, en, out); // switch index

//////Color table output
img_index	img_index_inst (
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
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
