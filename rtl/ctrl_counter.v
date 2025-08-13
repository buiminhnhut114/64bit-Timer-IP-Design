module ctrl_counter (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire div_en,
	input wire [3:0] div_val,
	input wire timer_en,

	output wire cnt_en
);

reg   [7:0] int_count;
reg   [7:0] int_count_temp;
reg   [7:0] int_count_max;
wire  [7:0] int_count_next;
wire  clock;

  assign clock = sys_clk;

  always @* begin
    case (div_val) 
	   4'b0000: int_count_max = clock       ;
	   4'b0001: int_count_max = 8'b0000_0001;
	   4'b0010: int_count_max = 8'b0000_0011;
	   4'b0011: int_count_max = 8'b0000_0111;
	   4'b0100: int_count_max = 8'b0000_1111;
	   4'b0101: int_count_max = 8'b0001_1111;
	   4'b0110: int_count_max = 8'b0011_1111;
	   4'b0111: int_count_max = 8'b0111_1111;
	   4'b1000: int_count_max = 8'b1111_1111;
	   default: int_count_max = 8'b0000_0001;
    endcase
  end

  always @(posedge sys_clk or negedge sys_rst_n) begin
	  if(!sys_rst_n) begin
		 int_count      <= 8'b0000_0000;
	         int_count_temp <= 8'bx;
	  end else if(cnt_en)
		  int_count <= 8'b0000_0000;
	  else if(timer_en) begin
		  int_count <= int_count_next + 1'b1;
                  int_count_temp <= int_count_next;
	  end else
		  int_count <= int_count_next;
  end

  assign int_count_next = int_count;

  assign cnt_en = div_en ? (int_count == int_count_max) : sys_clk;
  
endmodule

