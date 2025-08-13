module register (
	input wire sys_clk,
	input wire sys_rst_n,
	input wire w_en,
	input wire r_en,
	input wire [11:0] addr,
	input wire [31:0] wdata,
	input wire [63:0] count, 
	input wire int_st,

	output wire [31:0] rdata,
	output wire div_en,
	output wire [3:0] div_val,
	output wire timer_en, 
	output wire int_en,
	output wire match,
	output wire clear,
	output wire count_clr
);

  	parameter TCR   = 12'h00;
  	parameter TDR0  = 12'h04;
  	parameter TDR1  = 12'h08;
  	parameter TCMP0 = 12'h0C;
  	parameter TCMP1 = 12'h10;
  	parameter TIER  = 12'h14;
  	parameter TISR  = 12'h18;


	//Declaration
	wire tcr_w_sel;

  	//Write data condition
  	assign tcr_w_sel    = w_en && (addr == TCR);

	wire [2:0] tcr_data_pre;
	reg  [2:0] tcr_data;


  	assign tcr_data_pre = tcr_w_sel ? wdata[2:0]: tcr_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
	        	tcr_data  <= 3'b0;
	  	else
			tcr_data  <= tcr_data_pre; 		
  	end

  	assign timer_en  = tcr_data[0];
  	assign div_en    = tcr_data[1];
  	assign count_clr = tcr_data[2];

	//Divisor Value
	wire [3:0] div_val_pre;
	wire [3:0] div_val_next;
	reg  [3:0] div_val_temp;
	reg  [3:0] tcr_data1;

	assign div_val_pre = tcr_w_sel ? wdata[11:8] : div_val_next;

	// In prohibit settings (div_val > 9): div_val is not changed
	assign div_val_next = ((4'b0000 <= wdata[11:8]) && (wdata[11:8] <= 4'b1000)) ? div_val_pre : div_val_temp;

	// Update data
	always @(posedge sys_clk or negedge sys_rst_n) begin
    	if (!sys_rst_n) begin
        	div_val_temp <= 4'b0001;  
        	tcr_data1    <= 4'b0001;
    	end else begin
        	div_val_temp <= div_val_next;
		tcr_data1    <= div_val_temp;
    		end
	end
 
  	assign div_val   = tcr_data1;



	//TDR0
	//Declaration
  	wire tdr0_w_sel;
  	wire [31:0] tdr0_data_pre;
  	reg  [31:0] tdr0_data;
  
  	//Write data condition
  	assign tdr0_w_sel = w_en && (addr == TDR0);
  	assign tdr0_data_pre   = tdr0_w_sel ? count[31:0] : tdr0_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
			tdr0_data <= 32'h0;
          	else
	        	tdr0_data <= tdr0_data_pre;	  
  	end


  	//TDR1
  	//Declaration
	wire tdr1_w_sel;
  	wire [31:0] tdr1_data_pre;
  	reg  [31:0] tdr1_data;

 
  	//Write data condition
  	assign tdr1_w_sel = w_en && (addr == TDR1);
  	assign tdr1_data_pre   = tdr1_w_sel ? count[63:32] : tdr1_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
			tdr1_data <= 32'h0;
		else
		  	tdr1_data <= tdr1_data_pre;
  	end

  	//TCM0
  	//Declaration
  	wire tcmp0_w_sel;
  	wire [31:0] tcmp0_data_pre;
  	reg  [31:0] tcmp0_data;

  	//Write data condition
  	assign tcmp0_w_sel = w_en && (addr == TCMP0);
  	assign tcmp0_data_pre   = tcmp0_w_sel ? wdata : tcmp0_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
			tcmp0_data <= 32'hFFFF_FFFF;
	 	 else
		 	tcmp0_data <= tcmp0_data_pre;
  	end


  	//TCM1
  	//Declaration
  	wire tcmp1_w_sel;
  	wire [31:0] tcmp1_data_pre;
  	reg  [31:0] tcmp1_data;

  	//Write condition
  	assign tcmp1_w_sel = w_en && (addr == TCMP1);
  	assign tcmp1_data_pre   = tcmp1_w_sel ? wdata : tcmp1_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n)
			tcmp1_data <= 32'hFFFF_FFFF;
	  	else
		  	tcmp1_data <= tcmp1_data_pre;
  	end

  	//TIER
  	//Declaration
  	wire tier_w_sel;
  	wire tier_data_pre;
  	reg  tier_data;

  	//Write condition
  	assign tier_w_sel = w_en && (addr == TIER);
  	assign tier_data_pre  = tier_w_sel ? wdata[0] : tier_data;

  	//Update data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
	  	if(!sys_rst_n)
		  	tier_data <= 1'b0;
	  	else
		  	tier_data <= tier_data_pre;
  	end

  	assign int_en = tier_data; 


  	//TISR
  	//Declaration
  	wire tisr_w_sel;
  	wire tisr_data_pre;
  	reg  tisr_data;

  	//Write enable condition
  	assign tisr_w_sel     =   w_en && (addr == TISR);
  	assign tisr_data_pre  =   tisr_w_sel  &&    int_st  ? 1'b0     :
	 	                 (~tisr_w_sel) &&    int_st  ? int_st   :
		 	           tisr_w_sel  &&  (~int_st) ? int_st   : tisr_data ;

  	//Update Data
  	always @(posedge sys_clk or negedge sys_rst_n) begin
	  	if(!sys_rst_n)
		 	 tisr_data <= 1'b0;
	  	else
		 	 tisr_data <= tisr_data_pre;
  	end

  	assign status = tisr_data;



 	 //READ REGISTER
  	reg [31:0] rd;


  	always @(posedge sys_clk or negedge sys_rst_n) begin
	  	if(r_en) begin
		  	case (addr)
			  	TCR     : rd = {20'b0 , div_val [3:0] , 5'b0 , count_clr , div_en , timer_en };
			  	TDR0    : rd = tdr0_data;
			  	TDR1    : rd = tdr1_data;
			  	TCMP0   : rd = tcmp0_data;
			  	TCMP1   : rd = tcmp1_data;
			  	TIER    : rd = {31'b0 , int_en};
			  	TISR    : rd = {31'b0 , status};
			  	default : rd = 32'h0;
		  	endcase
	  	end
  	end

  	assign rdata = rd;
	assign match = (count[63:0] == {tcmp1_data,tcmp0_data});
endmodule

