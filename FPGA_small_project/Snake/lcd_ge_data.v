



//数据生成模块

//







module Lcd_Ge_Data(
	input			clk,
	input			rst,
	
	input[8:0]		cur_x,
	input[8:0]		cur_y,
	
	input			add_graph,
	input			sub_graph,
	
	input			up,
	input			down,
	input			left,
	input			right,
	
	input			select,
	
	output reg[23:0]	lcd_data_out
);



reg[18:0]	Snake[0:7];		//蛇
reg[17:0]	Food;				//	食物
reg			eated;			//吃掉了


reg[2:0]		add_index;
reg[2:0]		sub_index;
reg[2:0]		sel_index;

reg[1:0]		direct;
integer i;

//方向
always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		direct <= 2'b00;
	else if(up == 1'b1 && direct != 2'b01)
		direct <= 2'b00;
	else if(down == 1'b1 && direct != 2'b00)
		direct <= 2'b01;
	else if(left == 1'b1 && direct != 2'b11)
		direct <= 2'b10;
	else if(right == 1'b1 && direct != 2'b10)
		direct <= 2'b11;
	else
		direct <= direct;
end

localparam	SPEED = 'd25_000_000;	//	0.5s
reg[30:0]	speed;
//移动的速度
always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		speed <= 'd0;
	else if(speed >= SPEED)
		speed <= 'd0;
	else
		speed <= speed + 1'b1;
end

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		add_index <= 'd1;
		sub_index <= 'd0;
	end
	else if(eated == 1'b1 && add_index < 'd7)
	begin
		sub_index <= add_index;
		add_index <= add_index + 1'b1;
	end
	else if(sub_graph == 1'b1 && add_index > 'd0)
	begin
		add_index <= sub_index;
		if(sub_index > 'd0)
			sub_index <= sub_index - 1'b1;
		else
			sub_index <= sub_index;
	end
end


//生成食物
always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		Food <= {9'd40,9'd50};
	else if(eated == 1'b1)
		Food <= {1'b0,Food[8]^Food[7]^Food[6]^Food[5],Food[7:1],1'b0,Food[16:10],Food[9]^Food[17]};
end


//判断是否吃到食物
always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		eated <= 1'b0;
	else	if(((Food[17:9] - Snake[0][18:10] < 'd15) &&(Food[8:0] - Snake[0][9:1] < 'd15)) || ((Snake[0][18:10] - Food[17:9] < 'd15) &&(  Snake[0][9:1] - Food[8:0] < 'd15)))
		eated <= 1'b1;
	else
		eated <= 1'b0;

end


always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		for(i=0;i<8;i=i+1)
		begin
			if(i == 'd0)
				Snake[i] <= {9'd300,9'd60,1'b1};
			else
				Snake[i] <= 'd0;
		end
	else if(eated == 1'b1)
		Snake[add_index] <= Snake[sub_index];
	else if(sub_graph == 1'b1)
		Snake[sub_index] <= 'd0;
	//刷新蛇
	else if(speed >= SPEED)
	begin
		case(direct)
		2'b00:Snake[0][9:1] <= Snake[0][9:1] - 'd25;
		2'b01:Snake[0][9:1] <= Snake[0][9:1] + 'd25;
		2'b10:Snake[0][18:10] <= Snake[0][18:10] - 'd25;
		2'b11:Snake[0][18:10] <= Snake[0][18:10] + 'd25;
		endcase
		for(i = 1;i<= sub_index ;i=i+1)
			Snake[i] <= Snake[i-1];
	end
end


always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		sel_index <= 'd0;
	else if(select == 1'b1)
		if(sel_index >= add_index)
			sel_index <= 'd0;
		else
			sel_index <= sel_index + 1'b1;
	else
		sel_index <= sel_index;
end


// 9 x   9 y     0 flag


always@(posedge clk)
begin		
	if(cur_x >= Snake[0][18:10] && cur_x < Snake[0][18:10] + 'd25 &&  cur_y >= Snake[0][9:1] && cur_y < Snake[0][9:1]+'d25 && cur_y >= Snake[0][9:1] && cur_y < Snake[0][9:1]+'d25 && Snake[0][0] == 1'b1)
		lcd_data_out = 24'hABCDEF;
	else if(cur_x >= Snake[1][18:10] && cur_x < Snake[1][18:10] + 'd25 &&  cur_y >= Snake[1][9:1] && cur_y < Snake[1][9:1]+'d25 && cur_y >= Snake[1][9:1] && cur_y < Snake[1][9:1]+'d25 && Snake[1][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Snake[2][18:10] && cur_x < Snake[2][18:10] + 'd25 &&  cur_y >= Snake[2][9:1] && cur_y < Snake[2][9:1]+'d25 && cur_y >= Snake[2][9:1] && cur_y < Snake[2][9:1]+'d25 && Snake[2][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Snake[3][18:10] && cur_x < Snake[3][18:10] + 'd25 &&  cur_y >= Snake[3][9:1] && cur_y < Snake[3][9:1]+'d25 && cur_y >= Snake[3][9:1] && cur_y < Snake[3][9:1]+'d25 && Snake[3][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Snake[4][18:10] && cur_x < Snake[4][18:10] + 'd25 &&  cur_y >= Snake[4][9:1] && cur_y < Snake[4][9:1]+'d25 && cur_y >= Snake[4][9:1] && cur_y < Snake[4][9:1]+'d25 && Snake[4][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Snake[5][18:10] && cur_x < Snake[5][18:10] + 'd25 &&  cur_y >= Snake[5][9:1] && cur_y < Snake[5][9:1]+'d25 && cur_y >= Snake[5][9:1] && cur_y < Snake[5][9:1]+'d25 && Snake[5][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Snake[6][18:10] && cur_x < Snake[6][18:10] + 'd25 &&  cur_y >= Snake[6][9:1] && cur_y < Snake[6][9:1]+'d25 && cur_y >= Snake[6][9:1] && cur_y < Snake[6][9:1]+'d25 && Snake[6][0] == 1'b1)
		lcd_data_out = 24'hFACDEB;
	else if(cur_x >= Food[17:9] && cur_x < Food[17:9] + 'd25 &&  cur_y >= Food[8:0] && cur_y < Food[8:0]+'d25 && cur_y >= Food[8:0] && cur_y < Food[8:0]+'d25)
		lcd_data_out = 24'hFACDEB;
	else
		lcd_data_out = 24'hffffff;
end





endmodule


