library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo is port
(
	clki: in std_logic;
	servo_clk: in std_logic;
	servo: out std_logic
);
end entity servo;

architecture prescaled_servo of servo is

	component servo_controller is	generic
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
	
	signal direction: integer := 0;
	signal clk_bpm: std_logic := '0';
	
begin
	sc: servo_controller port map(clki, direction, servo);
	
	process(servo_clk)
		variable counter : integer := 0;
	begin 
		if servo_clk = '1' then
			counter := 1;
		else
			counter := 0;
		end if;
		
		direction <= counter;
	end process;
end architecture;