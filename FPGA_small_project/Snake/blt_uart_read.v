

//蓝牙串口读取
//波特率115200   1 stop  



module Blt_Uart_Read(

	input					clk,
	input					rst,
	
	

	output				ack,			//应答
	output[7:0]				data_out,		//读到的数据


	input					blt_rx
	
);
parameter	CYCLE				= 50 * 1000_000 / 115200;

localparam		S_IDLE	=	'd1;
localparam		S_START	=	'd2;
localparam		S_DATA	=	'd3;
localparam		S_STOP	=	'd4;		



reg[2:0]	state , next_state;
reg 		blt_rx_d0 , blt_rx_d1;
reg[23:0]	clk_cnt;
reg[7:0]	data_reg;
reg[3:0]	data_bit;

wire	blt_edge;


assign blt_edge 	= 	((~blt_rx_d0) & blt_rx_d1);
assign data_out 	= 	data_reg;
assign ack 		= 	(state == S_STOP && state != next_state) ? 1'b1 : 1'b0;







always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		begin
			blt_rx_d0 <= 1'b1;
			blt_rx_d1 <= 1'b1;
		end
	else
		begin
			blt_rx_d0 <= blt_rx;
			blt_rx_d1 <= blt_rx_d0;
		end
end

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end

always@(*)
begin
	case(state)
	S_IDLE:
		if(blt_edge == 1'b1)
			next_state <= S_START;
		else
			next_state <= S_IDLE;
	S_START:
		if(clk_cnt >= CYCLE)
			next_state <= S_DATA;
		else
			next_state <= S_START;
	S_DATA:
		if(clk_cnt >= CYCLE && data_bit == 'd7)
			next_state <= S_STOP;
		else
			next_state <= S_DATA;
	S_STOP:
		if(clk_cnt >= CYCLE)
			next_state <= S_IDLE;
		else
			next_state <= S_STOP;
	default:
		next_state <= S_IDLE;
	endcase
end



always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		clk_cnt <= 'd0;
	else if(clk_cnt >= CYCLE)
		clk_cnt <= 'd0;
	else if(state == S_IDLE)
		clk_cnt <= 'd0;
	else
		clk_cnt <= clk_cnt + 1'b1;
end


always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		data_bit <= 'd0;
	else if(state == S_DATA)
		if(clk_cnt >= CYCLE)
			data_bit <= data_bit + 1'b1;
		else
			data_bit <= data_bit;
	else
		data_bit <= 'd0;
end


always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
		data_reg <= 'd0;
	else if(state == S_DATA)
		if(clk_cnt == 'd250)
			data_reg <= {blt_rx,data_reg[7:1]};
		else
			data_reg <= data_reg;
	else
		data_reg <= data_reg;
end

endmodule