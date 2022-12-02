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
	HEX0,	HEX1,	HEX2: out std_logic_vector(0 to 6);
	LEDR 	: out std_logic_vector(17 downto 0);
	
	-- user control
	SW 	: in std_logic_vector(17 downto 0);
	KEY 	: in std_logic_vector(3 downto 0);
	
	-- sram
	SRAM_DQ		: inout std_logic_vector(15 downto 0);
	SRAM_UB_N, SRAM_LB_N, SRAM_CE_N,	SRAM_OE_N, SRAM_WE_N	: out std_logic;
	SRAM_ADDR	: out std_logic_vector(19 downto 0);
	
	-- audio
	AUD_ADCDAT, AUD_ADCLRCK, AUD_BCLK, AUD_DACLRCK : in std_logic;     
	AUD_DACDAT : out std_logic
);
end entity;

architecture rtl of headbang_bot is

	component servo_prescaler is port
	(
		clki: in std_logic;
		freq: in std_logic_vector(19 downto 0);
		clko: out std_logic
	);
	end component;
	
	component servo_controller is generic
	(
		max_cnt: integer := 25000000;
		duty_cycle_clk1000: integer := 1000
	);
	port
	(
		clki: in std_logic;
		direction: in integer;
		clko: out std_logic
	 );
	end component;
	
	component bpm_hex is	port
	(
		BPM: in std_logic_vector(9 downto 0);
		HEX0: out std_logic_vector(0 to 6);
		HEX1: out std_logic_vector(0 to 6);
		HEX2: out std_logic_vector(0 to 6)
	);
	end component;
	
	component audioqsys is port
	(
			audio_ADCDAT    : in  std_logic                     := 'X';             -- ADCDAT
			audio_ADCLRCK   : in  std_logic                     := 'X';             -- ADCLRCK
			audio_BCLK      : in  std_logic                     := 'X';             -- BCLK
			audio_DACDAT    : out std_logic;                                        -- DACDAT
			audio_DACLRCK   : in  std_logic                     := 'X';             -- DACLRCK
			clk_clk         : in  std_logic                     := 'X';             -- clk
			leds_export     : out std_logic_vector(17 downto 0);                    -- export
			switches_export : in  std_logic_vector(17 downto 0) := (others => 'X')  -- export
	);
	end component audioqsys;

	signal clk_bpm: std_logic := '0';
	signal direction: integer := 0;
	
begin

	sram_user_control : entity work.sram_user_control port map
	(
		clk				=> CLOCK_50,
		KEY 				=> KEY,
		SW					=> SW,
		LEDR 				=> LEDR,
		data 				=> SRAM_DQ,
		address 			=> SRAM_ADDR,
		output_enable_n 	=> SRAM_OE_N,
		write_enable_n	=> SRAM_WE_N,
		chip_select_n		=> SRAM_CE_N,
		ub_n					=> SRAM_UB_N,
		lb_n					=> SRAM_LB_N
	);
	
	audio : audioqsys PORT MAP
	(
		clk_clk => CLOCK_50,
		-- leds_export => LEDR(17 DOWNTO 0),
		-- switches_export => SW(17 DOWNTO 0),
		audio_ADCDAT => AUD_ADCDAT,
		audio_ADCLRCK => AUD_ADCLRCK,
		audio_BCLK => AUD_BCLK,
		audio_DACDAT => AUD_DACDAT,
		audio_DACLRCK => AUD_DACLRCK
	);

	sp: servo_prescaler port map(CLOCK_50, std_logic_vector(signed(bpm) * 100), clk_bpm);
	sc: servo_controller port map(CLOCK_50, direction, servo);
	hx: bpm_hex port map(bpm, HEX0, HEX1, HEX2);
	
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