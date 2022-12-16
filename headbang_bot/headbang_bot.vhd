library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity headbang_bot is port
(
	CLOCK_50: in std_logic;

	-- servo control
	BPM: in std_logic_vector(9 downto 0);
	SERVO: out std_logic;
	
	-- display
	HEX0,	HEX1,	HEX2: out std_logic_vector(0 to 6) := (others => '1');
	LEDR: out std_logic_vector(17 downto 0);
	LEDG: out std_logic_vector(8 downto 0);
	
	-- user control
	SW: in std_logic_vector(17 downto 0);
	KEY: in std_logic_vector(3 downto 0);
	
	-- sram
	SRAM_DQ: inout std_logic_vector(15 downto 0);
	SRAM_UB_N, SRAM_LB_N, SRAM_CE_N,	SRAM_OE_N, SRAM_WE_N: out std_logic;
	SRAM_ADDR: out std_logic_vector(19 downto 0);
	
	-- sdram
	DRAM_CLK, DRAM_CAS_N, DRAM_CKE, DRAM_CS_N, DRAM_RAS_N, DRAM_WE_N: out std_logic;
	DRAM_ADDR: out std_logic_vector(12 downto 0);
	DRAM_BA: out std_logic_vector(1 downto 0);
	DRAM_DQ: inout std_logic_vector(31 downto 0);
	DRAM_DQM: out std_logic_vector(3 downto 0);
	
	-- audio
	I2C_SCLK, AUD_DACDAT, AUD_XCK, AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK: out std_logic;
	AUD_ADCDAT: in std_logic;
	I2C_SDAT: inout std_logic
);
end entity;

architecture rtl of headbang_bot is

   signal clk_bpm: std_logic := '0';
   signal direction: integer := 0;
	signal adc_lr_clk, bclk, dac_data, dac_lr_clk: std_logic;
	signal first_channel: std_logic_vector(15 downto 0);
	signal sink_valid, sink_sop, sink_eop: std_logic;
	signal first_fft_source_sop, first_fft_source_eop: std_logic;
		
	component audio_codec is port
	(
		clk, reset, play: in std_logic;
		SDIN: inout std_logic;
		SCLK, USB_clk, BCLK: out std_logic;
		DAC_LR_CLK, ADC_LR_CLK: out std_logic;
		DAC_DATA: out std_logic;
		ADC_DATA: in std_logic;
		ACK_LEDR: out std_logic_vector(2 downto 0)
	);
	end component;
	
	component audioqsys is port
	(
		audio_ADCDAT: in std_logic := '0';
		audio_ADCLRCK: in std_logic := '0';
		audio_BCLK: in std_logic := '0';
		audio_DACDAT: out std_logic;
		audio_DACLRCK: in std_logic := '0';
		clk_clk: in std_logic := '0';
		leds_export: out std_logic_vector(17 downto 0);
		sdram_addr: out std_logic_vector(12 downto 0);
		sdram_ba: out std_logic_vector(1 downto 0);
		sdram_cas_n: out std_logic;
		sdram_cke: out std_logic;
		sdram_cs_n: out std_logic;
		sdram_dq: inout std_logic_vector(31 downto 0) := (others => '0');
		sdram_dqm: out std_logic_vector(3 downto 0);
		sdram_ras_n: out std_logic;
		sdram_we_n: out std_logic;
		switches_export: in std_logic_vector(17 downto 0) := (others => '0')
	);
	end component;
	
	component adc_buffer is port
	(
		clk, data_in, reset: in std_logic;
		first_channel_out: out std_logic_vector(15 downto 0);
		last_channel_out: out std_logic_vector(15 downto 0);
		channels_ready: out std_logic -- only needed for FFT's
	);
	end component;
	
	component amplitude_visualiser is port
	(
		amplitude_value: in std_logic_vector(15 downto 0);
		above_treshold: out std_logic
	);
	end component;

	component fft is port
	(
		clk: in std_logic := '0';
		reset_n: in std_logic := '0';
		sink_valid: in std_logic := '0';
		sink_ready: out std_logic;
		sink_error: in std_logic_vector(1 downto 0) := (others => '0');
		sink_sop: in std_logic := '0';
		sink_eop: in std_logic := '0';
		sink_real: in std_logic_vector(15 downto 0) := (others => '0');
		sink_imag: in std_logic_vector(15 downto 0) := (others => '0');
		fftpts_in: in std_logic_vector(11 downto 0) := (others => '0');
		inverse: in std_logic_vector(0 downto 0) := (others => '0');
		source_valid: out std_logic;
		source_ready: in std_logic := '0';
		source_error: out std_logic_vector(1 downto 0);
		source_sop: out std_logic;
		source_eop: out std_logic;
		source_real: out std_logic_vector(15 downto 0);
		source_imag: out std_logic_vector(15 downto 0);
		fftpts_out: out std_logic_vector(11 downto 0)
	);
	end component;
	
	component fft_control is port
	(
		clk: in std_logic;
		sink_valid: out std_logic;
		sink_sop: out std_logic;
		sink_eop: out std_logic
	);
	end component;
	
begin

	AUD_DACDAT <= dac_data;
	AUD_BCLK <= bclk;
	AUD_ADCLRCK <= adc_lr_clk;
	AUD_DACLRCK <= dac_lr_clk;
	LEDG(0) <= adc_lr_clk;
	LEDG(1) <= sink_sop;
	LEDG(2) <= sink_eop;

	amplitude_visualiser_instance: amplitude_visualiser port map
	(
		amplitude_value => first_channel,
		above_treshold => LEDG(8)
	);
	
	adc_buffer_instance: adc_buffer port map
	(
		clk => BCLK,
		data_in => AUD_ADCDAT,
		reset => adc_lr_clk,
		first_channel_out => first_channel
		-- last_channel_out => LEDR(17 downto 16)
	);
	
	fft_control_instance: fft_control port map
	(
		clk => adc_lr_clk,
		sink_valid => sink_valid,
		sink_sop => sink_sop,
		sink_eop => sink_eop
	);
	
	first_fft_instance: fft port map
	(
		clk => adc_lr_clk,
		reset_n => '1',
		sink_valid => sink_valid,
		sink_ready => LEDG(3),
		sink_error => (others => '0'),
		sink_sop => sink_sop,
		sink_eop => sink_eop,
		sink_real => first_channel,
		sink_imag => (others => '0'),
		fftpts_in => (others => '1'),
		inverse => (others => '0'),
		source_ready => '1',
		source_sop => LEDG(4),
		source_eop => LEDG(5),
		source_real => LEDR(17 downto 2)
	);
	
	audio_codec_instance: audio_codec port map
	(
		clk => CLOCK_50,
		reset => KEY(0),
		play => SW(0),
		SDIN => I2C_SDAT,
		SCLK => I2C_SCLK,
		USB_clk => AUD_XCK,
		BCLK => bclk,
		DAC_LR_CLK => dac_lr_clk,
		ADC_LR_CLK => adc_lr_clk,
		DAC_DATA => dac_data,
		ADC_DATA => AUD_ADCDAT
		-- ACK_LEDR => LEDR(2 downto 0)
	);
	
	sram_user_control: entity work.sram_user_control port map
	(
		clk => CLOCK_50,
		key => (others => '0'), --KEY,
		sw => (others => '0'), --SW,
		-- ledr => LEDR,
		data => SRAM_DQ,
		address => SRAM_ADDR,
		output_enable_n => SRAM_OE_N,
		write_enable_n => SRAM_WE_N,
		chip_select_n => SRAM_CE_N,
		ub_n => SRAM_UB_N,
		lb_n => SRAM_LB_N
	);
	
	sdram_pll: entity work.sdram_pll port map
	(
		inclk0 => CLOCK_50,
		c0 => DRAM_CLK
	);
	
	audio_qsys: audioqsys port map
	(
		clk_clk => CLOCK_50,
		-- leds_export => LEDR,
		-- switches_export => SW,
		audio_ADCDAT => AUD_ADCDAT,
		audio_ADCLRCK => adc_lr_clk,
		audio_BCLK => bclk,
		-- audio_DACDAT => dac_data,
		audio_DACLRCK => dac_lr_clk,
		sdram_addr => DRAM_ADDR,
		sdram_ba => DRAM_BA,
		sdram_cas_n => DRAM_CAS_N,
		sdram_cke => DRAM_CKE,
		sdram_cs_n => DRAM_CS_N,
		sdram_dq => DRAM_DQ,
		sdram_dqm => DRAM_DQM,
		sdram_ras_n => DRAM_RAS_N,
		sdram_we_n => DRAM_WE_N
	);

	sp: entity work.servo_prescaler port map
	(
		CLOCK_50,
		std_logic_vector(signed(bpm) * 100),
		clk_bpm
	);
	
	sc: entity work.servo_controller port map
	(
		CLOCK_50, 
		direction,
		servo
	);
	
	hx: entity work.bpm_hex port map
	(
		bpm, 
		HEX0, 
		HEX1, 
		HEX2
	);
	
	-- vervang dit door een component a.u.b.
	process(clk_bpm)
	
		variable counter : integer := 0;
		variable directionp: integer := 0;
		variable servop: integer := 0;
		
	begin 
		
		if rising_edge(clk_bpm) then
		
			if counter > 200 then
			
				counter := 0;
				
			end if;
			
			counter := counter + 1;
			
			if counter = 1 then
			
				directionp := 1;
				
			elsif counter = 101 then
			
				directionp := 2;
				
			end if;
			
			direction <= directionp;
			
		end if;
		
	end process;
	
end architecture;