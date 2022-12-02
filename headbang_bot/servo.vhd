library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo is
	port(
		bpm: in std_logic_vector(9 downto 0);
		CLOCK_50: in std_logic;
		servo: out std_logic;
		HEX0: out std_logic_vector(0 to 6);
		HEX1: out std_logic_vector(0 to 6);
		HEX2: out std_logic_vector(0 to 6);
		
		-- user control
		LEDR 	: out std_logic_vector(17 downto 0);
		SW 	: in std_logic_vector(17 downto 0);
		KEY 	: in std_logic_vector(3 downto 0);
		
		-- sram
		SRAM_DQ		: inout std_logic_vector(15 downto 0);
		SRAM_UB_N	: out std_logic;
		SRAM_LB_N	: out std_logic;
		SRAM_CE_N	: out std_logic;
		SRAM_OE_N	: out std_logic;
		SRAM_WE_N	: out std_logic;
		SRAM_ADDR	: out std_logic_vector(19 downto 0)
);
end entity servo;

architecture prescaled_servo of servo is



	component servo_prescaler is
		port(clki: in std_logic;
			  freq: in std_logic_vector(9 downto 0);
			  clko: out std_logic);
	end component;
	
	component servo_controller is
		generic(
			max_cnt: integer := 25000000;
			duty_cycle_clk1000: integer := 1000
		);
		port(clki: in std_logic;
			  direction: in integer;
			  clko: out std_logic
		 );
	end component;
	
	component bpm_hex is
		port(BPM: in std_logic_vector(9 downto 0);
			  HEX0: out std_logic_vector(0 to 6);
			  HEX1: out std_logic_vector(0 to 6);
			  HEX2: out std_logic_vector(0 to 6)
		);
	end component;
	
	signal direction: integer := 0;
	signal clk_bpm: std_logic := '0';
	
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

	sp: servo_prescaler port map(CLOCK_50, bpm, clk_bpm);
	sc: servo_controller port map(CLOCK_50, direction, servo);
	hx: bpm_hex port map(bpm, HEX0, HEX1, HEX2);
	
	process(clk_bpm)
		variable counter : integer := 0;
	begin 
		if rising_edge(clk_bpm) then
			if counter > 2 then
				counter := 0;
			end if;
				
			counter := counter + 1;
			direction <= counter;
		end if;
	end process;
end architecture;