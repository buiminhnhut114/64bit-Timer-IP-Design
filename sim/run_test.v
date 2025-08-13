task run_test;
	begin
	#100;
	$display("\n=======================[ APB PROTOCOL CHECK ]======================\n");
	end
	
	$display("\n===========================[ FAIL CASE  ]==========================\n");
	apb_protocol_check(1,12'h04,0,0,32'b0); //pwrite,paddr,psel,penable,wdata
	
	
      
	$display("\n==========================[ SUCCESS CASE ]=========================\n");
        apb_protocol_check(1,12'h04,1,1,32'b0); //pwrite,paddr,psel,penable,wdata

endtask
