





module Frequency_Selection(
	input		[4:0]				voice_id,
	output 	reg[21:0]		freequency
);





always@(*)
begin
	case(voice_id)
	5'd1:	freequency = 'd191571;
	5'd2: freequency = 'd170648;
	5'd3:	freequency = 'd151975;
	5'd4: freequency = 'd143266;
	5'd5: freequency = 'd127551;
	5'd6: freequency = 'd113636;
	5'd7: freequency = 'd100200;
	
	5'd8: freequency = 'd95602;
	5'd9: freequency = 'd85178;
	5'd10: freequency = 'd75872;
	5'd11: freequency = 'd71633;
	5'd12: freequency = 'd63775;
	5'd13: freequency = 'd56818;
	5'd14: freequency = 'd50100;
	
	
	
	default: freequency = 'd191571;
	endcase



end








endmodule 