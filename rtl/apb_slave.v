module apb_slave (
  input wire sys_clk,
  input wire sys_rst_n,
  input wire tim_psel,
  input wire tim_pwrite,
  input wire tim_penable,
  input wire [11:0] tim_paddr,

  output wire tim_pready,
  output wire r_en,
  output wire w_en
);

  parameter TCR   = 12'h00;
  parameter TDR0  = 12'h04;
  parameter TDR1  = 12'h08;
  parameter TCMP0 = 12'h10;
  parameter TCMP1 = 12'h1C;
  parameter TIER  = 12'h14;
  parameter TISR  = 12'h18;

  wire pready_in;
  reg  pready_out;
  reg  pready_temp;

  assign pready_in = tim_psel && tim_penable;

  always @(posedge sys_clk or negedge sys_rst_n) begin
	  if(!sys_rst_n)
		  pready_out <= 1'b0;
	  else
		  pready_out <= pready_in;
  end

  wire pready_up;
  
  assign pready_up = pready_in && (~pready_out);
 
  always @(posedge sys_clk or negedge sys_rst_n) begin
	if(!sys_rst_n)
		 pready_temp <= 1'b0;
	else 
		pready_temp <= pready_up;

  end

  //pready signal
  assign tim_pready = pready_up;

  //address valid check
  wire AddrValid; 
  assign AddrValid = (tim_paddr[11:0] <= 12'h18) && (tim_paddr[11:0] >= 12'h0);
  
  //write enable signal
  assign w_en = pready_up && tim_pwrite && AddrValid; 

  //read enable signal
  assign r_en = pready_up && (~tim_pwrite) && AddrValid;

endmodule

