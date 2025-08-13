task run_test;
	#100;
	
	begin
	#100;
	$display("============================================================================================");
	$display("|                           REGISTER INITIAL VALUE CHECK                          |");
	$display("============================================================================================");
	end



        $display("============================================================================================");       
	$display("|                                      FAIL CASE                                           |");
	$display("============================================================================================");

	register_initial_check(0,12'h00,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h04,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h08,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h0C,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h10,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h14,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h18,1,0,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(0,12'h1C,1,0,32'h0); //pwrite,paddr,psel,penable,wdata


        $display("============================================================================================");       
	$display("|                                      SUCCESS CASE                                        |");
	$display("============================================================================================");
	
	register_initial_check(1,12'h00,1,1,32'h0); //pwrite,paddr,psel,penable,wdata 
	register_initial_check(1,12'h04,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h08,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h0C,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h10,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h14,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h18,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	register_initial_check(1,12'h1C,1,1,32'h0); //pwrite,paddr,psel,penable,wdata
	
endtask

