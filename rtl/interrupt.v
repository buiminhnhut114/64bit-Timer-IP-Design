module interrupt (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire int_en,
	input wire match,
	input wire clear,

	output wire int_st,
	output wire tim_int
);

  	reg int_temp;

	always @(posedge sys_clk or negedge sys_rst_n)begin
		if(!sys_rst_n)
			int_temp <= 1'b0;
		else if (clear || ~int_en)
			int_temp <= 1'b0;
		else
			int_temp <= int_temp;
	end	

 	assign tim_int = int_temp;
  	assign int_st = int_temp;

endmodule
