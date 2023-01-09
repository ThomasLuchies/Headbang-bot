
module audioqsys (
	adc_lr_clk_export,
	aud_dat_export,
	clk_clk,
	enable_headbang_export,
	green_leds_export,
	red_leds_export,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	switches_export,
	soft_mute_export);	

	input		adc_lr_clk_export;
	input	[31:0]	aud_dat_export;
	input		clk_clk;
	output		enable_headbang_export;
	output	[8:0]	green_leds_export;
	output	[17:0]	red_leds_export;
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
	output		soft_mute_export;
endmodule
