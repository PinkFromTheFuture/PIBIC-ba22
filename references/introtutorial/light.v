module light(SW, LEDG);
	input		[1:0]SW;
	output	[0:0]LEDG;
	
	assign LEDG[0] = (SW[0] & ~SW[1])|(~SW[0] & SW[1]);
endmodule
	