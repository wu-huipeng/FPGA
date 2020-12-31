

//蓝牙串口
//


module main(
	
	input					clk,
	input					rst,
	
	//蓝牙串口
	input					blt_rx,		//读取		P1
	output				blt_wx,		//接收		N2
	
	
	//LED灯
	output	reg		led_1,		//led灯
	
	//AN430
	output				lcdclk_9M,				//an430时钟
	output				lcd_de,					//an430使能信号
	output				lcd_vsync,				//场同步信号(垂直)
	output				lcd_hsync,				//行同步信号(水平)
	output[23:0]		lcd_data					//an430显示数据 rgb565 		
);




wire[7:0]	data_read;
wire			ack;
wire			clk_9M;

reg 			add;
reg			sub;

reg			up;
reg			down;
reg			left;
reg			right;
reg			select;

PLL_9M PLL_9M_V(
	.inclk0(clk),
	.c0(clk_9M)
);

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		add <= 1'b0;
		sub <= 1'b0;
	end
	else if(data_read == "1" && ack == 1'b1)
		add <= 1'b1;
	else if(data_read == "2" && ack == 1'b1)
		sub <= 1'b1;
	else if(data_read == "3" && ack == 1'b1)
		up <= 1'b1;
	else if(data_read == "4" && ack == 1'b1)
		down <= 1'b1;
	else if(data_read == "5" && ack == 1'b1)
		left <= 1'b1;
	else if(data_read == "6" && ack == 1'b1)
		right <= 1'b1;
	else if(data_read == "7" && ack == 1'b1)
		select <= 1'b1;
	else
	begin
		add <= 1'b0;
		sub <= 1'b0;
		up  <= 1'b0;
		down <= 1'b0;
		left <= 1'b0;
		right <= 1'b0;
		select<= 1'b0;
	end


end







Blt_Uart_Read Blt_Uart_Read_V(

	.clk(clk),
	.rst(rst),
	
	

	.ack(ack),			//应答
	.data_out(data_read),		//读到的数据


	.blt_rx(blt_rx)
	
);

Lcd_Drive Lcd_Drive_V(
	.clk(clk),
	.clk_9M(clk_9M),
	.rst(rst),
	
	
	.lcdclk_9M(lcdclk_9M),				//an430时钟
	.lcd_de(lcd_de),					//an430使能信号
	.lcd_vsync(lcd_vsync),				//场同步信号(垂直)
	.lcd_hsync(lcd_hsync),				//行同步信号(水平)
	.lcd_data(lcd_data),					//an430显示数据 rgb565 		
	
	.data_in(24'd10),
	
	.add_graph(add),
	.sub_graph(sub),
	.up(up),
	.down(down),
	.left(left),
	.right(right),
	.select(select)
);



endmodule 