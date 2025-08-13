`timescale 1ns/1ps

module test_bench;
       
        reg sys_clk;
        reg sys_rst_n;
        reg tim_psel;
        reg tim_pwrite;
        reg tim_penable;
        reg [11:0] tim_paddr;
        reg [31:0] tim_wdata;
        reg [31:0] tim_rdata;
        reg tim_pready;
        reg tim_int;

`include "../sim/run_test.v"

timer_top uut (
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.tim_psel(tim_psel),
	.tim_pwrite(tim_pwrite),
	.tim_penable(tim_penable),
	.tim_paddr(tim_paddr),
	.tim_wdata(tim_wdata),
	.tim_rdata(tim_rdata),
	.tim_pready(tim_pready),
	.tim_int(tim_int)
); 

reg [63:0] count_now, count_later;

  initial begin
	  sys_clk = 0;
	  forever #25 sys_clk = ~sys_clk;
  end

  initial begin
	  sys_rst_n   = 1'b0;
	  tim_psel    = 1'b0;
	  tim_pwrite  = 1'b0;
	  tim_penable = 1'b0;
	  tim_paddr   = 12'bx;
	  tim_wdata   = 32'bx;

	  
	  run_test();

	  #100;
	  $finish;
  end



  task apb_protocol_check;
	  input pwrite;
	  input [11:0] paddr;
	  input psel;  
	  input penable;
	  input [31:0] wdata;

	  $display("\n=======================[ APB PROTOCOL CHECK ]=====================");
	  $display("==================================================================");
	  $display("==========================[ PREADY SIGNAL ]=======================\n");


	  @(posedge sys_clk)
          APB_Enable(pwrite,paddr,psel,penable,wdata);
	  
	  if(tim_pready == 1)
		  $display(" t = %10d   [PASS]:   pready = 1'b1                                      ",$time);
	  else
		  $display(" t = %10d   [FAIL]:   pready = %b. EXPECTED: pready = 1'b1               ",$time,tim_pready);
	  
          $display("\n=======================[ TEST: APB WRITE CHECK ]==================\n" );
	  if(uut.r_inst.w_en == 1)
		  $display(" t = %10d   [PASS]:   w_en = 1'b1                                        ",$time);
	  else begin
		  $display(" t = %10d   [FAIL]:   w_en = %b. EXPECTED: w_en = 1'b1                   ", $time,uut.r_inst.w_en);
	  end

	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  $display("\n========================[ TEST: APB READ CHECK ]==================\n");
	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr,psel,penable,wdata);
	  
	  #10;
	  if(uut.r_inst.r_en == 1)
		  $display(" t = %10d   [PASS]:   r_en = 1'b1                                        ",$time);
	  else
		  $display(" t = %10d   [FAIL]:   r_en = %b. EXPECTED: r_en = 1'b1                   ", $time,uut.r_inst.w_en);
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
  endtask

  task register_initial_check;
	  input pwrite;
	  input [11:0]paddr;
	  input psel;  
	  input penable;
	  input [31:0] wdata;
	  $display("\n=================================================================================");
	  $display("=======================[ REGISTER INITIAL VALUE CHECK  ]=========================");
	  $display("=================================================================================\n");

	 
	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	 
         #60;  
         case(tim_paddr)
		      12'h00: begin
			      $display("========================[ TEST: TDR0 CHECK (0x00) ]=======================\n");

			      if(tim_rdata == 32'h00000100)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000100   ",$time,tim_rdata);
                              end
	   	     12'h04: begin
			      $display("==========================[ TEST: TDR0 (0x04) ]============================\n");

			      if(tim_rdata == 32'h00000000)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000000   ",$time,tim_rdata);
                              end
		     12'h08: begin
			      $display("===========================[ TEST: TDR1 (0x04) ]===========================\n");
			      if(tim_rdata == 32'h00000000)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000000   ",$time,tim_rdata);
                              end
		     12'h0C:  begin
			      $display("===========================[ TEST: TCMP0 (0x1C) ]===========================\n");
			      if(tim_rdata == 32'hffffffff)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'hffffffff   ",$time,tim_rdata);
                              end
		     12'h10:  begin
			      $display("===========================[ TEST: TCMP1 (0x10) ]===========================\n");
			      if(tim_rdata == 32'hffffffff)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'hffffffff   ",$time,tim_rdata);
              		      end
		     12'h14:  begin
			      $display("===========================[ TEST: TIER (0x14) ]============================\n");
			      if(tim_rdata == 32'h00000000)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000000   ",$time,tim_rdata);
                              end
		     12'h18:  begin
			      $display("===========================[ TEST: TISR (0x18) ]===========================\n");
			      if(tim_rdata == 32'h00000000)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000000   ",$time,tim_rdata);
                              end
		     default: begin
			      $display("===============================[ RESERVED ]================================\n");
			      if(tim_rdata == 32'h00000000)			       
		                      $display(" t = %10d   [PASS]:  tim_rdata = 32'h%h                                       ",$time,tim_rdata);
			      else
			              $display(" t = %10d   [FAIL]:  tim_rdata = 32'h%h. EXPECTED: tim_rdata = 32'h00000000   ",$time,tim_rdata);
		              end
	    endcase
	  
         sys_rst_n = 1'b0;
	 #100;  
  endtask	  

  task register_rw_check;
	  input pwrite;
	  input [11:0] paddr;
	  input psel;
	  input penable;
	  input [31:0] wdata;
	  $display("\n=====================================================================");
	  $display("==================[ REGISTER READ/WRITE CHECK ]======================");
	  $display("=====================================================================\n");

	  $display("==================[ TEST: WRITE REGISTER CHECK ]=====================\n");

         

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,wdata);
          
	  #10; 
	  if(uut.r_inst.w_en  == 1'b1) begin
		  $display(" t = %10d   [PASS]     :  w_en = %b                                                  ",$time,uut.r_inst.w_en);
		  #60;
		  $display(" t = %10d   [PASS]     :  tim_wdata = 32'h%h at paddr 12'h%h                 ",$time,tim_wdata,tim_paddr);
	  end
	  else begin
		  $display(" t = %10d   [FAIL]     :  w_en = %b  , tim_wdata = 32'h%h at paddr 12'h%h     ",$time,uut.r_inst.w_en,tim_wdata,tim_paddr);
		  $display(" t = %10d   [EXPECTED] :  w_en = 1  , can not write data => timing error            ",$time);
	  end

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  $display("\n==================[ TEST: READ REGISTER CHECK ]=====================\n");
	  @(posedge sys_clk)
          APB_Enable(~pwrite,paddr,psel,penable,wdata);
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  if(uut.r_inst.r_en == 1'b1) begin
		  $display(" t = %10d   [PASS]     :  r_en = %b                                                  ",$time,uut.r_inst.r_en);
		  #60;
		  $display(" t = %10d   [PASS]     :  tim_rdata = 32'h%h at paddr 12'h%h                 ",$time,tim_rdata,tim_paddr);
	  end
	  else begin
		  $display(" t = %10d   [FAIL]     :  r_en = %b  , tim_rdata = 32'h%h at paddr 12'h%h     ",$time,uut.r_inst.w_en,tim_rdata,tim_paddr);
		  #60;
		  $display(" t = %10d   [EXPECTED] :  r_en = 1  , can not read data => timing error             ",$time);
	  end
	  #100; 
  endtask


  task counter_control_div_val_check;
	  input pwrite;
	  input [11:0] paddr;
	  input psel;
	  input penable;
          input [31:0] wdata;
          
	  $display("\n================================================================================");
	  $display("======================[  COUNTER CONTROL DIV_VALUE CHECK ]======================");
	  $display("================================================================================\n");


	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	 
	  #10;
	  if(uut.cd_inst.div_en == 1 && uut.cd_inst.timer_en == 1) begin 
	    $display(" t = %10d   [PASS]     : div_en = %b , timer_en = %b                                  ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
          end
	  else begin
            $display(" t = %10d   [FAIL]     : div_en = %b  , timer_en = %b                                 ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
	    $display(" t = %10d   [EXPECTED] : div_en = 1  , timer_en = 1                                 ",$time); 
          end
          
	  #60;
          case(uut.cd_inst.div_val)
		  4'b0000:   begin
     			     $display("\n====================[ TEST: COUTING SPEED IS NOT DIVIDED ]===================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                              ",$time);
			          end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 0))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = 8'b%b                         ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b  at count = 8'b%b                         ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1  at count = 8'b00000000                         ",$time);
			          end
	                     end

		  4'b0001:   begin
			     $display("\n====================[ TEST: COUTING SPEED IS NOT DIVIDED BY 2]===============\n");
  			
			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			     end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			     end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 1))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = 8'b%b                         ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00000001                       ",$time);
			          end
	                     end

		  4'b0010:   begin
     			     $display("\n===============[ TEST: COUTING SPEED IS NOT DIVIDED BY 4]=====================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			     end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 3))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00000011                       ",$time);
			          end
			     end

		  4'b0011:   begin
     			     $display("\n=================[ TEST: COUTING SPEED IS NOT DIVIDED BY 8]====================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			     end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			     end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 7))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00000111                       ",$time);
				end
		             end

		  4'b0100:   begin
     			     $display("\n===================[ TEST: COUTING SPEED IS NOT DIVIDED BY 16]=================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			          end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 15))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00001111                       ",$time);
			          end
	                     end

		  4'b0101:   begin
     			     $display("\n====================[ TEST: COUTING SPEED IS NOT DIVIDED BY 32]=================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			          end
			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 31))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00011111                       ",$time);
		     	         end
	                     end
		  4'b0110:   begin
     			     $display("\n==================[ TEST: COUTING SPEED IS NOT DIVIDED BY 64]===================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			          end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 63))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b00111111                       ",$time);
			          end
	                     end
		  4'b0111:   begin
     			     $display("\n==================[ TEST: COUTING SPEED IS NOT DIVIDED BY 128=]=================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
		             else begin
				     $display(" t = %10d   [FAIL]     : Test bench could run forever                               ",$time);
			          end
			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 127))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b01111111                       ",$time);
			          end
	                     end
		  4'b1000:   begin
     			     $display("\n===================[ TEST: COUTING SPEED IS NOT DIVIDED BY 256]=================\n");

			     #100;
			     if(uut.cd_inst.int_count_temp >= 1'b0) begin
			             wait (uut.cd_inst.int_count == uut.cd_inst.int_count_max);
		                     $display(" t = %10d   [PASS]     : Waiting for cnt_en is asserted                             ",$time);
			          end
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b    at count = 8'b%b                       ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1    at count = 8'b11111111                       ",$time);
			          end

			     #10;
			     if((uut.cd_inst.cnt_en == 1) && (uut.cd_inst.int_count == 255))
				     $display(" t = %10d   [PASS]     : cnt_en = %b  at count = %b                            ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
			     else begin
				     $display(" t = %10d   [FAIL]     : cnt_en = %b   at count = %b                           ",$time,uut.cd_inst.cnt_en,uut.cd_inst.int_count);
				     $display(" t = %10d   [EXPECTED] : cnt_en = 1   at count = 2                                  ",$time);
			          end
	                     end
		  default:   begin
		  $display("\n============================================================================================");
  		  $display("======================[ TEST: COUNTING SPEED IS IN PROHIBIT SETTINGS ]======================");
		  $display("============================================================================================");
		  $display("===========[ When setting prohibit value, div_val is remained the previous state ]==========");
		  $display("============================================================================================\n");

	                     end
	 endcase
 endtask


  task counter_control_timer_div_check;   
	  input pwrite;
	  input [11:0] paddr;
	  input psel;
	  input penable;
          input [31:0] wdata;
	  $display("\n===============================================================================================");
  	  $display("======================[  COUNTER CONTROL DIV_EN && TIMER_EN CHECK  ]===========================");
	  $display("===============================================================================================\n");

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  @(posedge sys_clk)
          APB_Enable(~pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
          
	  #60;
	  $display(" t = %10d:    rdata = 32'h%h at paddr 12'h%h                                                      ",$time,tim_rdata,tim_paddr);
	  if(uut.cd_inst.div_en == 0 && uut.cd_inst.timer_en == 0) begin
                $display(" t = %10d:    div_en = %b , timer_en = %b                                                                   ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
		$display(" t = %10d:    div_en   is disabled. Counter counts with normal speed based on system clock               ",$time);
		$display(" t = %10d:    timer_en is disabled. Counter does not count                                               ",$time);
	        repeat (10) @(posedge sys_clk) begin
	        end
		#10;
	        if(uut.c_inst.count == 0) begin
		       $display(" t = %10d:    [PASS]     : cnt_en based on system clock                                                  ",$time);
		       $display(" t = %10d:    [PASS]     : count  = 64'b%b ",$time,uut.c_inst.count);
		end
	        else begin
		       $display(" t = %10d:    [FAIL]     : cnt_en based on system clock                                                  ",$time);
		       $display(" t = %10d:    [FAIL]     : count  = 64'b%b ",$time,uut.c_inst.count);
		       $display(" t = %10d:    [EXPECTED] : count  = 64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);
       	       end
	  end	
	  else if(uut.cd_inst.div_en == 0 && uut.cd_inst.timer_en == 1) begin
		$display(" t = %10d:    div_en = %b , time r_en = %b                                                                  ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
		$display(" t = %10d:    div_en   is disabled. Counter counts with normal speed based on system clock               ",$time);
		$display(" t = %10d:    timer_en is enabled . Counter starts counting                                              ",$time);
	        repeat (10) @(posedge sys_clk) begin
	        end
		#10;
	        if(uut.c_inst.count != 0) begin
		       $display(" t = %10d:    [PASS]     : cnt_en based on system clock                                                  ",$time);
		       $display(" t = %10d:    [PASS]     : count  = 64'b%b ",$time,uut.c_inst.count);
		end
	        else begin
		       $display(" t = %10d:    [FAIL]     : cnt_en based on system clock                                                  ",$time);
		       $display(" t = %10d:    [FAIL]     : count  = 64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);
		       $display(" t = %10d:    [EXPECTED] : count  = 64'b%b ",$time,uut.c_inst.count);
	       end
	  end
	  else if(uut.cd_inst.div_en == 1 && uut.cd_inst.timer_en == 0) begin
		$display(" t = %10d:    div_en = %b , timer_en = %b                                                                  ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
		$display(" t = %10d:    div_en   is enabled . The counting speed of counter is controlled based on div_val         ",$time);
		$display(" t = %10d:    timer_en is disabled. Counter does not count                                               ",$time);
	        repeat (10) @(posedge sys_clk) begin
	        end
		#10;
	        if(uut.c_inst.count == 0) begin
		       $display(" t = %10d:    [PASS]     : cnt_en based on div_val                                                       ",$time);
		       $display(" t = %10d:    [PASS]     : count  = 64'b%b ",$time,uut.c_inst.count);
		end
	        else begin
		       $display(" t = %10d:    [FAIL]     : cnt_en based on div_val                                                       ",$time);
		       $display(" t = %10d:    [FAIL]     : count  = 64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);
		       $display(" t = %10d:    [EXPECTED] : count  = 64'b%b ",$time,uut.c_inst.count);
	       end
	  end
	  else if(uut.cd_inst.div_en == 1 && uut.cd_inst.timer_en == 1) begin
		$display(" t = %10d:    div_en = %b , timer_en = %b                                                                  ",$time,uut.cd_inst.div_en,uut.cd_inst.timer_en);
		$display(" t = %10d:    div_en   is enabled. The counting speed of counter is controlled based on div_val          ",$time);
                $display(" t = %10d:    timer_en is enabled. Counter starts counting                                               ",$time);		
	        repeat (10) @(posedge sys_clk) begin
	        end
		#10;
	        if(uut.c_inst.count != 0) begin
		       $display(" t = %10d:    [PASS]     : cnt_en based on div_val                                                       ",$time);
		       $display(" t = %10d:    [PASS]     : count  = 64'b%b  ",$time,uut.c_inst.count);
		end
	        else begin
		       $display(" t = %10d:    [FAIL]     : cnt_en based on div_val                                                       ",$time);
		       $display(" t = %10d:    [FAIL]     : count  = 64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);
		       $display(" t = %10d:    [EXPECTED] : count  = 64'b%b ",$time,uut.c_inst.count);
	       end
	  end
	  else begin 
		$display(" t = %10d:    [FAIL]   :    div_en && timer_en could not be 1'bx                                         ",$time);
	  end

          @(posedge sys_clk)
	  sys_rst_n = 1'b0;
	  #100;
  endtask

  task counter_check;
	  input pwrite;
	  input [11:0] paddr;
	  input psel;
	  input penable;
          input [31:0] wdata;     //data to control counter
	  input [3:0] wdata1;    //turned off div_en
	  input [3:0] wdata2;    //turned off timer_en
	  input [3:0] wdata3;    //turned off both timer_en && div_en
	  input [3:0] wdata4;    //turned on  count_clr
   	  $display("\n============================================================================================");
  	  $display("====================================[ COUNTER 64BIT CHECK ]=================================");
	  $display("============================================================================================");

          @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  
	  #60;
          $display(" t = %10d:    div_val = 4'b%b  ,  count_clr = 1'b%b  ,  div_en  = 1'b%b  ,  timer_en = 1'b%b              ",$time,uut.r_inst.div_val,uut.r_inst.count_clr,uut.r_inst.div_en,uut.r_inst.timer_en);

	  
	  repeat (uut.cd_inst.int_count_max) @(posedge sys_clk) begin
	  end
	  #100;
	  if(uut.c_inst.count != 0) begin
	        $display(" t = %10d:    [PASS]    : count  =  64'b%b ",$time,uut.c_inst.count);
	  end
	  else begin
	        $display(" t = %10d:    [FAIL]    : count  =  64'b%b ",$time,uut.c_inst.count);
	        $display(" t = %10d:    [EXPECTED]: counter is counting. Count value must be more than 64'b0                       ",$time);
	  end
          #100;
	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,{wdata[31:4] , wdata1});

	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  #60;
  	  $display("\n==================================[ TEST: TURNED OFF DIV_EN ]==================================\n");
	  $display(" t = %10d:    div_val = 4'b%b  ,  count_clr = 1'b%b  ,  div_en  = 1'b%b  ,  timer_en = 1'b%b              ",$time,uut.r_inst.div_val,uut.r_inst.count_clr,uut.r_inst.div_en,uut.r_inst.timer_en);

          @(posedge sys_clk)
	  count_now = uut.c_inst.count;
          
	  repeat (uut.cd_inst.int_count_max) @(posedge sys_clk) begin
          end
	  #20;
          count_later = uut.c_inst.count;
	  
	  #100;
	  if(count_now != count_later) begin
	        $display(" t = %10d:    [PASS]    : count  =  64'b%b ",$time,uut.c_inst.count);
	  end
	  else begin
	        $display(" t = %10d:    [FAIL]    : count  =  64'b%b ",$time,uut.c_inst.count);
	        $display(" t = %10d:    [EXPECTED]: counter is counting. Count value must be more than 64'b0                       ",$time);
	  end
          #100; 
	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,{wdata[31:4] , wdata2});
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  #60;
  	  $display("\n==================================[ TEST: TURNED OFF TIMER_EN  ]================================\n");

	  $display(" t = %10d:    div_val = 4'b%b  ,  count_clr = 1'b%b  ,  div_en  = 1'b%b  ,  timer_en = 1'b%b              ",$time,uut.r_inst.div_val,uut.r_inst.count_clr,uut.r_inst.div_en,uut.r_inst.timer_en);
	  
          @(posedge sys_clk)
	  count_now = uut.c_inst.count;
          
	  repeat (uut.cd_inst.int_count_max) @(posedge sys_clk) begin
	  end
	  #20;
          count_later = uut.c_inst.count;
	  
	  #100;
	  if(count_now == count_later) begin
	        $display(" t = %10d:    [PASS]    : count  =  64'b%b ",$time,uut.c_inst.count);
           
	  end
	  else begin
	        $display(" t = %10d:    [FAIL]    : count  =  64'b%b ",$time,uut.c_inst.count);
	        $display(" t = %10d:    [EXPECTED]: count  =  64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);

	  end
          #100;
	  @(posedge sys_clk) 
	  APB_Enable(pwrite,paddr,psel,penable,{wdata[31:4] , wdata3});

	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  #60;
  	  $display("\n=========================[ TEST: TURNED OFF BOTH DIV_EN && TIMER_EN  ]==========================\n");

	  $display(" t = %10d:    div_val = 4'b%b  ,  count_clr = 1'b%b  ,  div_en  = 1'b%b  ,  timer_en = 1'b%b              ",$time,uut.r_inst.div_val,uut.r_inst.count_clr,uut.r_inst.div_en,uut.r_inst.timer_en);
	  
          @(posedge sys_clk)
	  count_now = uut.c_inst.count;
          
	  repeat (uut.cd_inst.int_count_max) @(posedge sys_clk) begin
	  end
	  #20;
          count_later = uut.c_inst.count;

	  #100;
	  if(count_now == count_later) begin
	        $display(" t = %10d:    [PASS]    : count  =  64'b%b ",$time,uut.c_inst.count);
	  end
	  else begin
	        $display(" t = %10d:    [FAIL]    : count  =  64'b%b ",$time,uut.c_inst.count);
	        $display(" t = %10d:    [EXPECTED]: count  =  64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time);
	  end
          
	  #100;
	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,{wdata[31:4] , wdata4});
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
  	  $display("\n=================================[ TEST: TURNED OFF COUNT_CLR  ]================================\n");

	  $display(" t = %10d:    div_val = 4'b%b  ,  count_clr = 1'b%b  ,  div_en  = 1'b%b  ,  timer_en = 1'b%b              ",$time,uut.r_inst.div_val,uut.r_inst.count_clr,uut.r_inst.div_en,uut.r_inst.timer_en);

	  #100;
	  if(uut.c_inst.count == 0) begin
	        $display(" t = %10d:    [PASS]    : count  =  64'b%b ",$time,uut.c_inst.count);

	  end
	  else begin
	        $display(" t = %10d:    [FAIL]    : count  =  64'b%b ",$time,uut.c_inst.count);
	        $display(" t = %10d:    [EXPECTED]: count  =  64'b0000000000000000000000000000000000000000000000000000000000000000 ",$time,uut.c_inst.count);

	  end
	  
	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr,psel,penable,wdata);

	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  $display("count = %b",uut.c_inst.count); 
 
  endtask


  task interrupt_check;
	  input pwrite;
	  input [11:0] paddr;   //TIER  (0x14)
	  input [11:0] paddr0;  //TCMP0 (0x0C)
	  input [11:0] paddr1;  //TCMP1 (0x10)
	  input [11:0] paddr2;  //TCR   (0x0)
	  input [11:0] paddr3;  //TISR  (0x18)
	  input psel;
	  input penable;
          input wdata;          //TIER
	  input [31:0] wdata0;  //TCMP0
	  input [31:0] wdata1;  //TCMP1
	  input [11:0] wdata2;  //TCR
	  input int_en;
	  input int_dis;
          $display("\n=============================================================================================");
  	  $display("===================================[ INTERRUPT CHECK  ]======================================");
	  $display("=============================================================================================\n");


	  @(posedge sys_clk) 
	  APB_Enable(pwrite,paddr,psel,penable,wdata); 
         
	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  @(posedge sys_clk) 
	  APB_Enable(~pwrite,paddr,psel,penable,wdata); 
         
	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  #60;
  	  $display("\n=================================[ TEST: READ REGISTER TIER  (0x14)]=======================\n");

	  $display(" t = %10d:    tim_rdata  =  32'h%h at paddr = 12'h%h                                              ",$time,tim_rdata,tim_paddr);
	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr0,psel,penable,wdata0); 

	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr0,psel,penable,wdata0); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  #60;
  	  $display("\n================================[ TEST: READ REGISTER TCMP0 (0x0C)]=========================\n");

	  $display(" t = %10d:    tim_rdata  =  32'h%h at paddr = 12'h%h                                              ",$time,tim_rdata,tim_paddr);

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr1,psel,penable,wdata1); 


	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr1,psel,penable,wdata1);
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  #60;
  	  $display("\n===============================[ TEST: READ REGISTER TCMP1 (0x10) ]==========================\n");

	  $display(" t = %10d:    tim_rdata  =  32'h%h at paddr = 12'h%h                                              ",$time,tim_rdata,tim_paddr);

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr2,psel,penable,wdata2); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr2,psel,penable,wdata2); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  #60;
  	  $display("\n=============================[ TEST: READ REGISTER TCR  (0x00) ]=============================\n");

	  $display(" t = %10d:    tim_rdata  =  32'h%h at paddr = 12'h%h                                              ",$time,tim_rdata,tim_paddr);

  	  $display("\n=================================[ TEST: TIM_INT CHECK ]=====================================\n");

	  wait(uut.i_inst.match);
	  #60;
	  if(tim_int == 1) begin
		 $display(" t = %10d:    [PASS]     :  tim_int = 1'b1                                                               ",$time);
	 end else begin
		 $display(" t = %10d:    [FAIL]     :  tim_int = 1'b%b                                                               ",$time,tim_int);
		 $display(" t = %10d:    [EXPECTED] :  tim_int = 1'b1                                                               ",$time);

         end 

	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr3,psel,penable,int_dis); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  #60;
  	  $display("\n=============================[ TEST: READ REGISTER TISR (0x18) ]=============================\n");

	  if(tim_rdata == 32'h00000001 && tim_paddr == 12'h18) begin
                 $display(" t = %10d:    [PASS]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
          end
	  else begin
                 $display(" t = %10d:    [FAIL]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
                 $display(" t = %10d:    [EXPECTED] :  tim_rdata = 32'h00000001 at paddr = 12'h18                                   ",$time);
	  end

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr3,psel,penable,int_dis); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr3,psel,penable,int_dis); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;

	  #60;
  	  $display("\n==================[ TEST: READ REGISTER TISR (0x18) AFTER WRITING 0) ]=======================\n");

	  if(tim_rdata == 32'h00000001 && tim_paddr == 12'h18) begin
                 $display(" t = %10d:    [PASS]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
          end
	  else begin
                 $display(" t = %10d:    [FAIL]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
                 $display(" t = %10d:    [EXPECTED] :  tim_rdata = 32'h00000001 at paddr = 12'h18                                   ",$time);
	  end

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr3,psel,penable,int_en); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr3,psel,penable,int_en); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  #60;
  	  $display("\n==================[ TEST: READ REGISTER TISR  (0x18) AFTER WRITING 1 ]=======================\n");

	  if(tim_rdata == 32'h00000000 && tim_paddr == 12'h18) begin
                 $display(" t = %10d:    [PASS]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);

          end
	  else begin
                 $display(" t = %10d:    [FAIL]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
                 $display(" t = %10d:    [EXPECTED] :  tim_rdata = 32'h00000001 at paddr = 12'h18                                   ",$time);
	  end

	  @(posedge sys_clk)
	  APB_Enable(pwrite,paddr3,psel,penable,int_en); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  @(posedge sys_clk)
	  APB_Enable(~pwrite,paddr3,psel,penable,int_en); 
	  
	  @(posedge sys_clk)
	  tim_penable = ~penable;
	  
	  #60;
  	  $display("\n====================[ TEST: READ REGISTER TISR  (0x18) AFTER WRITING 1 ]======================\n");

	  if(tim_rdata == 32'h00000000 && tim_paddr == 12'h18) begin
                 $display(" t = %10d:    [PASS]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);

          end
	  else begin
                 $display(" t = %10d:    [FAIL]     :  tim_rdata = 32'h%h at paddr = 12'h%h                                  ",$time,tim_rdata,tim_paddr);
                 $display(" t = %10d:    [EXPECTED] :  tim_rdata = 32'h00000001 at paddr = 12'h18                                   ",$time);
	  end
  
  endtask


  task APB_Enable;
	  input pwrite;
	  input [11:0] paddr;
	  input psel;
	  input penable;
	  input [31:0] wdata;

	  @(posedge sys_clk)
	  sys_rst_n  = 1'b1;
	  tim_pwrite = pwrite;
	  tim_wdata  = wdata;
	  tim_paddr  = paddr;
	  tim_psel   = psel;

	  @(posedge sys_clk)
	  tim_penable = penable;

  endtask
endmodule
