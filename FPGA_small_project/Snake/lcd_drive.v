





//AN430 lcd底层驱动模块
module Lcd_Drive(
	input					clk,
	input					clk_9M,
	input					rst,
	
	
	output				lcdclk_9M,				//an430时钟
	output				lcd_de,					//an430使能信号
	output				lcd_vsync,				//场同步信号(垂直)
	output				lcd_hsync,				//行同步信号(水平)
	output reg[23:0]	lcd_data,					//an430显示数据 rgb565 		
	
	input[23:0]			data_in,
	
	input					add_graph,
	input					sub_graph,
	input			up,
	input			down,
	input			left,
	input			right,
	
	input			select
);


localparam  H_TOTAL_TIME		= 525;
localparam	H_ADDR_TIME			= 480;
localparam	H_SYNC_TIME			= 41;
localparam	H_BACK_PORCH		= 2;

localparam 	V_TOTAL_TIME		= 286;
localparam	V_ADDR_TIME			= 272;
localparam	V_SYNC_TIME			= 10;
localparam	V_BACK_PORCH		= 2;



reg[11:0]		cnt_h;
reg[9:0]		cnt_v;


wire  	h_valid;		//水平有效
wire		v_valid;		//垂直有效
wire[8:0]	cur_x;		//当前的x坐标
wire[8:0]	cur_y;		//当前的y坐标


wire[23:0]		lcd_data_in;

assign h_valid = (cnt_h >= H_SYNC_TIME + H_BACK_PORCH) && (cnt_h < H_TOTAL_TIME- H_BACK_PORCH);
assign v_valid = (cnt_v >= V_SYNC_TIME + V_BACK_PORCH) && (cnt_v < V_TOTAL_TIME - V_BACK_PORCH);

assign cur_x = (h_valid == 1'b1)  ? (cnt_h - H_SYNC_TIME - H_BACK_PORCH) : 'd0;
assign cur_y = (v_valid == 1'b1)  ? (cnt_v - V_SYNC_TIME - V_BACK_PORCH) : 'd0;


assign lcd_de = v_valid & h_valid;   //同时有效的时候，置1
assign lcd_hsync = (cnt_h < H_SYNC_TIME) ? 1'b0 : 1'b1;
assign lcd_vsync = (cnt_v < V_SYNC_TIME) ? 1'b0 : 1'b1;
assign lcdclk_9M = clk_9M;

always@(posedge clk_9M or negedge rst)
begin
	if(rst == 1'b0)
		cnt_h <= 'd0;
	else if(cnt_h >= H_TOTAL_TIME)
		cnt_h <= 'd0;
	else
		cnt_h <= cnt_h + 1'b1;
end

always@(posedge clk_9M or negedge rst)
begin
	if(rst == 1'b0)
		cnt_v <= 'd0;
	else if(cnt_v >= V_TOTAL_TIME &&cnt_h >= H_TOTAL_TIME)
		cnt_v <= 'd0;
	else if(cnt_h >= H_TOTAL_TIME)
		cnt_v <= cnt_v + 1'b1;
end



always@(posedge clk_9M or negedge rst)
begin
	if(rst == 1'b0)
		lcd_data <= 'd0;
		
	else if(v_valid && h_valid)
		lcd_data <= lcd_data_in;
	else
		lcd_data <= 24'hffffff;
end


Lcd_Ge_Data Lcd_Ge_Data_V(
	.clk(clk),
	.rst(rst),
	
	.cur_x(cur_x),
	.cur_y(cur_y),
	
	.add_graph(add_graph),
	.sub_graph(sub_graph),
	
	.up(up),
	.down(down),
	.left(left),
	.right(right),
	.select(select),
	
	.lcd_data_out(lcd_data_in)
);



endmodule