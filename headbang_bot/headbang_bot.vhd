library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity headbang_bot is port
(
	CLOCK_50 : in std_logic;

	-- servo control
	SERVO : out std_logic;
	
	-- display
	HEX0,	HEX1,	HEX2: out std_logic_vector(0 to 6) := (others => '1');
	LEDR : out std_logic_vector(17 downto 0);
	LEDG : out std_logic_vector(8 downto 0);
	
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
  
  -- Audio general
	signal aud_adc_lr_ck: std_logic;			--adc lr clk
	signal aud_adc_data: std_logic_vector(31 downto 0) := (others => '0');			--adc data

	-- SRAM general
	signal read_n, write_n, clear_sram, clear_done: std_logic := '0';
	signal sram_data_input, sram_data_output: std_logic_vector(15 downto 0);
	signal sram_address: std_logic_vector(19 downto 0);
	
	-- SRAM states
	type sram_control_types is (user_control, beat_control);
	signal sram_state: sram_control_types;
	
	-- SRAM user_control
	signal read_n_user_control, write_n_user_control, clear_sram_user_control : std_logic;
	signal data_input_user_control : std_logic_vector(15 downto 0);
	signal addr_user_control : std_logic_vector(19 downto 0);
	signal data_output_user_control : std_logic_vector(15 downto 0);
	signal clear_done_user_control: std_logic;
	
	-- SRAM beat_control 
	signal sram_data_beat_control: std_logic_vector(15 downto 0);
	signal sram_address_beat_control: std_logic_vector(19 downto 0);
	signal read_n_beat_control: std_logic;
	signal data_beat_control: std_logic_vector(15 downto 0);
	signal address_beat_control: std_logic_vector(19 downto 0);
	
	component audio_player is port
	(
		clk, reset, play: in std_logic;
		SDIN: inout std_logic;
		SCLK, USB_clk, BCLK: out std_logic;
		DAC_LR_CLK, ADC_LR_CLK: out std_logic;
		DAC_DATA: out std_logic;
		ADC_DATA: in std_logic;
		ACK_LEDR: out std_logic_vector(2 downto 0);
		ADC_DATA_Combined: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component audioqsys is port
	(
		adc_lr_clk_export : in    std_logic;                                        -- export
		aud_dat_export    : in    std_logic_vector(31 downto 0);                    -- export
		clk_clk           : in    std_logic                     := 'X';             -- clk
		green_leds_export : out   std_logic_vector(8 downto 0);                     -- export
		red_leds_export   : out   std_logic_vector(17 downto 0);                    -- export
		sdram_addr        : out   std_logic_vector(12 downto 0);                    -- addr
		sdram_ba          : out   std_logic_vector(1 downto 0);                     -- ba
		sdram_cas_n       : out   std_logic;                                        -- cas_n
		sdram_cke         : out   std_logic;                                        -- cke
		sdram_cs_n        : out   std_logic;                                        -- cs_n
		sdram_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
		sdram_dqm         : out   std_logic_vector(3 downto 0);                     -- dqm
		sdram_ras_n       : out   std_logic;                                        -- ras_n
		sdram_we_n        : out   std_logic;                                        -- we_n
		switches_export   : in    std_logic_vector(17 downto 0) := (others => 'X')  -- export
	);
	end component;
	
	signal bpm: std_logic_vector(9 downto 0);
	signal clk_count: std_logic_vector(20 downto 0);
begin
	process(CLOCK_50)
	begin
		clk_count <= std_logic_vector(unsigned(clk_count) + 1);
	end process;
	--audio: audio_player port map
	--(
		--clk => CLOCK_50,
		--reset => KEY(0),
		--SW0 => SW(0),
		--SDIN => I2C_SDAT,
		--SCLK => I2C_SCLK,
		--USB_clk => AUD_XCK,
		--BCLK => AUD_BCLK,
		--DAC_LR_CLK => AUD_DACLRCK,
		--DAC_DATA => AUD_DACDAT,
		--ACK_LEDR => LEDR(2 downto 0)
	--);
	
	
	beat_controller: entity work.beat_controller port map(
		  CLOCK_50 => CLOCK_50,
		  clk_count => clk_count,
		  bpm => bpm,
		  enabled => KEY(3),
		  servo_pin => SERVO,

		  --sram
		  read_n => read_n_beat_control,
		  data => data_beat_control,
		  address => address_beat_control
	);
	
	sram_user_control: entity work.sram_user_control port map
	(
		key => KEY(2 downto 0), -- KEY,
		sw => SW, -- SW,
		ledr => LEDR,
		ledg => LEDG,
		read_n => read_n_user_control,
		write_n => write_n_user_control, 
		clear_sram => clear_sram_user_control,
		data_input => data_input_user_control,
		addr_input => addr_user_control,
		data_output => data_output_user_control,
		clear_done => clear_done_user_control
	);
	
	sram_controller: entity work.sram_controller port map
	(
		clk => CLOCK_50,
		read_n => read_n,
		write_n => write_n,
		clear_sram => clear_sram,
		data_input => sram_data_input,
		addr_input => sram_address,
		data_output => sram_data_output,
		clear_done => clear_done,
		
		data => SRAM_DQ,
		address => SRAM_ADDR,
		output_enable_n => SRAM_OE_N,
		write_enable_n => SRAM_WE_N,
		chip_select_n => SRAM_CE_N,
		ub_n => SRAM_UB_N,
		lb_n => SRAM_LB_N 
	);

	AUD_ADCLRCK <= aud_adc_lr_ck; --adc lr clk

	aud_player: audio_codec port map
	(
		clk => CLOCK_50,
		reset => KEY(0),
		play => SW(0),
		SDIN => I2C_SDAT,
		SCLK => I2C_SCLK,
		USB_clk => AUD_XCK,
		BCLK => AUD_BCLK,
		DAC_LR_CLK => AUD_DACLRCK,
		ADC_LR_CLK => aud_adc_lr_ck,
		DAC_DATA => AUD_DACDAT,
		ADC_DATA => AUD_ADCDAT,
		ADC_DATA_Combined => aud_adc_data
		--ACK_LEDR => LEDR(2 downto 0)
	);
	
--	sram_user_control: entity work.sram_user_control port map
--	(
--		clk => CLOCK_50,
--		key => (others => '0'), -- KEY,
--		sw => (others => '0'), -- SW,
--		-- ledr => LEDR,
--		data => SRAM_DQ,
--		address => SRAM_ADDR,
--		output_enable_n => SRAM_OE_N,
--		write_enable_n => SRAM_WE_N,
--		chip_select_n => SRAM_CE_N,
--		ub_n => SRAM_UB_N,
--		lb_n => SRAM_LB_N
--	);
	
	sdram_pll: entity work.sdram_pll port map
	(
		inclk0 => CLOCK_50,
		c0 => DRAM_CLK
	);
	
	audio_qsys: audioqsys port map
	(
		clk_clk => CLOCK_50,
		red_leds_export => LEDR,
		switches_export => SW,
		sdram_addr => DRAM_ADDR,
		sdram_ba => DRAM_BA,
		sdram_cas_n => DRAM_CAS_N,
		sdram_cke => DRAM_CKE,
		sdram_cs_n => DRAM_CS_N,
		sdram_dq => DRAM_DQ,
		sdram_dqm => DRAM_DQM,
		sdram_ras_n => DRAM_RAS_N,
		sdram_we_n => DRAM_WE_N,
		aud_dat_export   => aud_adc_data,
		adc_lr_clk_export => aud_adc_lr_ck,
		green_leds_export => LEDG
	);

--	sp: entity work.servo_prescaler port map
--	(
--		CLOCK_50,
--		std_logic_vector(signed(bpm) * 100),
--		clk_bpm
--	);
--	
--	sc: entity work.servo_controller port map
--	(
--		CLOCK_50, 
--		direction,
--		servo
--	);

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
		
	end process
	
	process(clear_done) 
	begin
		if clear_done = '1' then
			clear_sram <= '0';
		end if;
		
		if sram_state <= user_control then
			read_n <= read_n_user_control;
			write_n <= write_n_user_control;
			clear_sram <= clear_sram_user_control;
			clear_done <= clear_done_user_control;
			sram_data_input <= data_input_user_control;
			sram_data_output <= data_output_user_control;
			sram_address <= addr_user_control;
		elsif sram_state <= beat_control then
			read_n <= read_n_beat_control;
			write_n <= '0';
			sram_data_output <= data_beat_control;
			sram_address <= address_beat_control;
		end if;

	end process;
	
	process(KEY(3))
	begin
		if rising_edge(KEY(3)) then
			if sram_state <= user_control then
				sram_state <= beat_control;
			elsif sram_state <= beat_control then
				sram_state <= user_control;
			else
				sram_state <= user_control;
			end if;
		end if;
	end process;
	
end architecture;