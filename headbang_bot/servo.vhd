library ieee;
use ieee.std_logic_1164.all;

entity servo is
	port(
		bpm: in std_logic_vector(9 downto 0);
		CLOCK_50: in std_logic;
		PWM: out std_logic
	);
end entity servo;

architecture prescaled_servo of servo is
	component servo_prescaler is
		port(clki: in std_logic;
			  freq: in std_logic_vector(9 downto 0);
			  clko: out std_logic);
	end component;
	
begin
	sp: servo_prescaler port map(CLOCK_50, "0000001010", PWM);
end architecture;