	audioqsys u0 (
		.adc_lr_clk_export      (<connected-to-adc_lr_clk_export>),      //      adc_lr_clk.export
		.aud_dat_export         (<connected-to-aud_dat_export>),         //         aud_dat.export
		.clk_clk                (<connected-to-clk_clk>),                //             clk.clk
		.enable_headbang_export (<connected-to-enable_headbang_export>), // enable_headbang.export
		.green_leds_export      (<connected-to-green_leds_export>),      //      green_leds.export
		.red_leds_export        (<connected-to-red_leds_export>),        //        red_leds.export
		.sdram_addr             (<connected-to-sdram_addr>),             //           sdram.addr
		.sdram_ba               (<connected-to-sdram_ba>),               //                .ba
		.sdram_cas_n            (<connected-to-sdram_cas_n>),            //                .cas_n
		.sdram_cke              (<connected-to-sdram_cke>),              //                .cke
		.sdram_cs_n             (<connected-to-sdram_cs_n>),             //                .cs_n
		.sdram_dq               (<connected-to-sdram_dq>),               //                .dq
		.sdram_dqm              (<connected-to-sdram_dqm>),              //                .dqm
		.sdram_ras_n            (<connected-to-sdram_ras_n>),            //                .ras_n
		.sdram_we_n             (<connected-to-sdram_we_n>),             //                .we_n
		.switches_export        (<connected-to-switches_export>),        //        switches.export
		.soft_mute_export       (<connected-to-soft_mute_export>)        //       soft_mute.export
	);

