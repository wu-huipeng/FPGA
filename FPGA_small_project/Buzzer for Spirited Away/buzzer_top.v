




module buzzer_top(
	input				clk,
	input				rst,
	
	input[4:0]		voice_id,				//音符选择
	
	
	output			ack,
	
	output reg		buzzer
);



localparam	One_BAT_Time 				=    'd25_000_000;		//1秒所需要的计数值



wire[21:0]	buzzer_freq;
reg[25:0]	buzzer_cnt;					//蜂鸣器计数使能

reg[25:0]	one_bat_cnt;				//一排计数时间




assign ack = (one_bat_cnt == One_BAT_Time) ? 1'b1 : 1'b0;

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		one_bat_cnt <= 'd0;
	else if(one_bat_cnt == One_BAT_Time)
		one_bat_cnt <= 'd0;
	else
		one_bat_cnt <= one_bat_cnt + 1'b1;
end

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		buzzer_cnt <= 'd0;
	else if(one_bat_cnt == One_BAT_Time)
		buzzer_cnt <= 'd0;
	else if(buzzer_cnt == buzzer_freq)
		buzzer_cnt <= 'd0;
	else
		buzzer_cnt <= buzzer_cnt + 1'b1;
end


always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		buzzer <= 'd1;
	else if(buzzer_cnt < buzzer_freq / 64)
		buzzer <= 1'b0;
	else
		buzzer <= 1'b1;
end



Frequency_Selection FS_m0(
	.voice_id(voice_id),
	.freequency(buzzer_freq)
);



endmodule 