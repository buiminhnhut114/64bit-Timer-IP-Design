module timer_top (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire tim_psel,
	input wire tim_pwrite,
	input wire tim_penable,
	input wire [11:0] tim_paddr,
	input wire [31:0] tim_wdata,
	
	output wire [31:0] tim_rdata,
	output wire tim_pready,
	output wire tim_int
);
	
	//apb//
	wire cnt_en;
	wire r_en;

	//ctrl counter//
	wire w_en;
	
	//register//
	wire int_st;
        wire div_en;
        wire timer_en;
        wire int_en;
        wire match;
	wire clear;
        wire count_clr;
        reg [3:0]  div_val;
        wire [63:0] count;


	apb_slave apb_inst(
        	.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.tim_psel(tim_psel),
		.tim_pwrite(tim_pwrite),
		.tim_penable(tim_penable),
		.tim_paddr(tim_paddr),
		.tim_pready(tim_pready),
		.r_en(r_en),
		.w_en(w_en)
	);




	register r_inst (
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
		.w_en(w_en),
		.r_en(r_en),
		.addr(tim_paddr),
		.wdata(tim_wdata),
		.count(count),
		.int_st(int_st),
		.rdata(tim_rdata),
		.div_en(div_en),
		.div_val(div_val),
		.timer_en(timer_en),
		.int_en(int_en),
		.match(match),
		.clear(clear),
		.count_clr(count_clr)
	);


	ctrl_counter cd_inst (
        	.sys_clk(sys_clk),
	 	.sys_rst_n(sys_rst_n),
	 	.div_en(div_en),
	 	.div_val(div_val),
	 	.timer_en(timer_en),
	 	.cnt_en(cnt_en)
	);


	 counter_64bit c_inst (
         	.sys_clk(sys_clk),
	 	.sys_rst_n(sys_rst_n),
	 	.timer_en(timer_en),
	 	.cnt_en(cnt_en),
	 	.count_clr(count_clr),
	 	.count(count)
	);


	interrupt i_inst (
		.sys_clk(sys_clk),
		.sys_rst_n(sys_rst_n),
         	.int_en(int_en),
	 	.match(match),
	 	.int_st(int_st),
	 	.tim_int(tim_int)
	);

endmodule

