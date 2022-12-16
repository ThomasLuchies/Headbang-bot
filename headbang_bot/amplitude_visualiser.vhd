library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplitude_visualiser is generic
(
	TRESHOLD: integer range 0 to 32768 := 29000
);
port
(
	amplitude_value: in std_logic_vector(15 downto 0);
	above_treshold: out std_logic
);
end entity;

architecture rtl of amplitude_visualiser is
	signal amplitude: signed(15 downto 0);
begin
	process (amplitude_value) begin
		amplitude <= signed(amplitude_value);
		if amplitude >= TRESHOLD then
			above_treshold <= '1';
		else
			above_treshold <= '0';
		end if;
	end process;
end architecture;