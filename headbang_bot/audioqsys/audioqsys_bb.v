
module audioqsys (
	clk_clk,
	switches_export,
	leds_export,
	audio_ADCDAT,
	audio_ADCLRCK,
	audio_BCLK,
	audio_DACDAT,
	audio_DACLRCK);	

	input		clk_clk;
	input	[17:0]	switches_export;
	output	[17:0]	leds_export;
	input		audio_ADCDAT;
	input		audio_ADCLRCK;
	input		audio_BCLK;
	output		audio_DACDAT;
	input		audio_DACLRCK;
endmodule
