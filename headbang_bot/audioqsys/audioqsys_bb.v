
module audioqsys (
	adc_data_export,
	adc_lr_clk_export,
	bclk_export,
	clk_clk,
	leds_export,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	switches_export);	

	input		adc_data_export;
	input		adc_lr_clk_export;
	input		bclk_export;
	input		clk_clk;
	output	[17:0]	leds_export;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[31:0]	sdram_dq;
	output	[3:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	input	[17:0]	switches_export;
endmodule
