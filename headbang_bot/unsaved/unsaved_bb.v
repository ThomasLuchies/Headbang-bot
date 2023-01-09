
module unsaved (
	clk_clk,
	reset_reset_n,
	switches_export,
	enable_beat_detection_export,
	audio_mute_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[17:0]	switches_export;
	output		enable_beat_detection_export;
	output		audio_mute_export;
endmodule
