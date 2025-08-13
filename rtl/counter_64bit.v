module counter_64bit(
  input wire sys_clk,
  input wire sys_rst_n,
  input wire timer_en,
  input wire cnt_en,
  input wire count_clr,  
  
  output wire [63:0] count

);

reg [63:0] count_temp;

  always @(posedge sys_clk or negedge sys_rst_n) begin
	  if(!sys_rst_n)
		  count_temp  <= 64'b0;
	  else if(count_clr) 
		   count_temp <= 64'b0;
	   else if(cnt_en) begin
		   if(timer_en)
		       count_temp <= count_temp + 1'b1;
	        else
		       count_temp <= count_temp;
	        end
	   else
		   count_temp <= count_temp;
  end

  assign count = count_temp;

endmodule


