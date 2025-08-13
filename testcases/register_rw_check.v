task run_test;

	begin
	#100;
	$display("=====================================================================");
	$display("=================[ REGISTER READ/WRITE CHECK  ]======================");
	$display("=====================================================================");
	end

	$display("=====================================================================");
	$display("                            SUCCESS CASE                             ");
	$display("=====================================================================");
        register_rw_check(1,12'h00,1,1,32'hAAAA_A8AF); //pwrite,paddr,psel,penable,wdata	
	register_rw_check(1,12'h00,1,1,32'hAAAA_AAAF); //pwrite,paddr,psel,penable,wdata	
	register_rw_check(1,12'h04,1,1,32'hBBBB_BBBB); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h08,1,1,32'hCCCC_CCCC); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h0C,1,1,32'hDDDD_DDDD); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h10,1,1,32'hEEEE_EEEE); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h14,1,1,32'hFFFF_FFFF); //pwrite,paddr,psel,penable,wdata	
	register_rw_check(1,12'h18,1,1,32'hAAAA_BBBB); //pwrite,paddr,psel,penable,wdata

        

        $display("\n\n\n======================================================================");       
	$display("                              FAIL CASE                               ");
	$display("======================================================================");

	register_rw_check(0,12'h00,1,0,32'hAAAA_A8AF); //pwrite,paddr,psel,penable,wdata	
	register_rw_check(0,12'h04,1,0,32'hBBBB_BBBB); //pwrite,paddr,psel,penable,wdata
	register_rw_check(0,12'h08,1,0,32'hCCCC_CCCC); //pwrite,paddr,psel,penable,wdata
	register_rw_check(0,12'h0C,1,0,32'hDDDD_DDDD); //pwrite,paddr,psel,penable,wdata
	register_rw_check(0,12'h10,1,0,32'hEEEE_EEEE); //pwrite,paddr,psel,penable,wdata
	register_rw_check(0,12'h14,1,0,32'hFFFF_FFFF); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h18,0,0,32'hAAAA_BBBB); //pwrite,paddr,psel,penable,wdata
	register_rw_check(1,12'h1C,0,0,32'hAAAA_BBBB); //pwrite,paddr,psel,penable,wdata

endtask

