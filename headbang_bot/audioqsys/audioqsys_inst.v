	audioqsys u0 (
		.adc_data_export   (<connected-to-adc_data_export>),   //   adc_data.export
		.adc_lr_clk_export (<connected-to-adc_lr_clk_export>), // adc_lr_clk.export
		.bclk_export       (<connected-to-bclk_export>),       //       bclk.export
		.clk_clk           (<connected-to-clk_clk>),           //        clk.clk
		.leds_export       (<connected-to-leds_export>),       //       leds.export
		.sdram_addr        (<connected-to-sdram_addr>),        //      sdram.addr
		.sdram_ba          (<connected-to-sdram_ba>),          //           .ba
		.sdram_cas_n       (<connected-to-sdram_cas_n>),       //           .cas_n
		.sdram_cke         (<connected-to-sdram_cke>),         //           .cke
		.sdram_cs_n        (<connected-to-sdram_cs_n>),        //           .cs_n
		.sdram_dq          (<connected-to-sdram_dq>),          //           .dq
		.sdram_dqm         (<connected-to-sdram_dqm>),         //           .dqm
		.sdram_ras_n       (<connected-to-sdram_ras_n>),       //           .ras_n
		.sdram_we_n        (<connected-to-sdram_we_n>),        //           .we_n
		.switches_export   (<connected-to-switches_export>)    //   switches.export
	);

