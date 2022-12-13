library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity headbang_bot is port
(
	CLOCK_50 : in std_logic;

	-- servo control
	BPM : in std_logic_vector(9 downto 0);
	SERVO : out std_logic;
	
	-- display
	HEX0,	HEX1,	HEX2: out std_logic_vector(0 to 6) := (others => '1');
	LEDR : out std_logic_vector(17 downto 0);
	
	-- user control
	SW : in std_logic_vector(17 downto 0);
	KEY : in std_logic_vector(3 downto 0);
	
	-- sram
	SRAM_DQ : inout std_logic_vector(15 downto 0);
	SRAM_UB_N, SRAM_LB_N, SRAM_CE_N,	SRAM_OE_N, SRAM_WE_N	: out std_logic;
	SRAM_ADDR : out std_logic_vector(19 downto 0);
	
	-- sdram
	DRAM_CLK, DRAM_CAS_N, DRAM_CKE, DRAM_CS_N, DRAM_RAS_N, DRAM_WE_N : out std_logic;
	DRAM_ADDR : out std_logic_vector(12 downto 0);
	DRAM_BA : out std_logic_vector(1 downto 0);
	DRAM_DQ : inout std_logic_vector(31 downto 0);
	DRAM_DQM : out std_logic_vector(3 downto 0);
	
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

begin

	AUD_DACDAT <= dac_data;
	AUD_BCLK <= bclk;
	AUD_ADCLRCK <= adc_lr_clk;
	AUD_DACLRCK <= dac_lr_clk;

	aud_player: audio_codec port map
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
		key => (others => '0'), -- KEY,
		sw => (others => '0'), -- SW,
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
		leds_export => LEDR,
		switches_export => SW,
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