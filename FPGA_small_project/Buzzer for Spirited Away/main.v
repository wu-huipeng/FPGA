

//利用蜂鸣器演奏千与千寻

//一个时钟周期为20ns 

module main(
	input 				clk,					//50Mhz时钟
	input					rst,					//复位
	
	output				buzzer				//蜂鸣器


);


wire			 curr_end;


reg[4:0]		voice_id;
reg[20:0]	cnt;

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		cnt <= 'd0;
	else if(curr_end == 1'b1)
		if(cnt == 'd30)
				cnt <= 'd0;
		else
				cnt <= cnt + 1'b1;

end
always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin	
		voice_id <= 'd1;
	end
		
	else if(curr_end == 1'b1) begin
		case(cnt)
		'd0: voice_id <= 'd8;
		'd1: voice_id <= 'd9;
		'd2: voice_id <= 'd10;
		'd3: voice_id <= 'd8;
		'd4: voice_id <= 'd12;
		'd5: voice_id <= 'd12;
		'd6: voice_id <= 'd10;
		'd7: voice_id <= 'd9;
		'd8: voice_id <= 'd12;
		'd9: voice_id <= 'd9;
		'd10: voice_id <= 'd8;
		'd11: voice_id <= 'd6;
		'd12: voice_id <= 'd10;
		'd13: voice_id <= 'd10;
		'd14: voice_id <= 'd8;
		'd15: voice_id <= 'd7;
		'd16: voice_id <= 'd7;
		
		
		'd17: voice_id <= 'd6;	
		'd18: voice_id <= 'd7;
		'd19: voice_id <= 'd8;
		'd20: voice_id <= 'd9;
		'd21: voice_id <= 'd5;
		'd22: voice_id <= 'd8;
		'd23: voice_id <= 'd9;
		'd24: voice_id <= 'd10;
		'd25: voice_id <= 'd11;
		'd26: voice_id <= 'd11;
		'd27: voice_id <= 'd10;
		'd28: voice_id <= 'd9;
		'd29: voice_id <= 'd8;
		'd30: voice_id <= 'd9;
		
	
	
	
		
		default: voice_id <= 'd1;
		endcase

			
		
	end
	else 
		voice_id <= voice_id;
end



buzzer_top(
	.clk(clk),
	.rst(rst),
	
	.voice_id(voice_id),				//音符选择

	
	
	.ack(curr_end),
	
	.buzzer(buzzer)
);


endmodule	