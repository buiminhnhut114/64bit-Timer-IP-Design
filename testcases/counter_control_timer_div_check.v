task run_test;
	begin
	#100;
	$display("=======================================================================================================");
	$display("                              COUNTER CONTROL TIMER_EN && DIV_EN CHECK                                 ");
	$display("=======================================================================================================");
	end

        $display("=======================================================================================================");
	$display("                                               FAIL CASE                                               ");
	$display("=======================================================================================================");

        counter_control_timer_div_check(1,12'h04,1,1,32'h0000_0x00); //pwrite,paddr,psel,penable,tim_wdata
	counter_control_timer_div_check(1,12'h08,1,1,32'h0000_0x01); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h08,1,1,32'h0000_0x02); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h08,1,1,32'h0000_0x03); //pwrite,paddr,psel,penable,tim_wdata


	$display("=======================================================================================================");
	$display("                                              SUCCESS CASE                                             ");
	$display("=======================================================================================================");

        counter_control_timer_div_check(1,12'h00,1,1,32'h0000_0000); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h00,1,1,32'h0000_0001); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h00,1,1,32'h0000_0102); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h00,1,1,32'h0000_0203); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_timer_div_check(1,12'h00,1,1,32'h0000_000x); //pwrite,paddr,psel,penable,tim_wdata
endtask   

