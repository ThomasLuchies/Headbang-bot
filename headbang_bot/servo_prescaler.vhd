library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo_prescaler is
	port(
		clki: in std_logic;
		freq: in std_logic_vector(9 downto 0);
		clko: out std_logic
	);
end entity;

architecture servo_prescaler_arch of servo_prescaler is
begin
	process(clki)
		variable cnt: INTEGER RANGE 0 TO 25000000 := 0;
      variable cnt_max : integer := 0;
		variable clkop: std_logic := '0';
	begin
		if rising_edge(clki) then
			if cnt_max /= 25000000 / to_integer(unsigned(freq)) then
				cnt_max := 25000000 / to_integer(unsigned(freq));
				cnt := 0;
			end if;
		
			cnt := cnt + 1;
			if cnt = cnt_max then
				cnt := 0;
				clkop := not clkop;
			end if;
		end if;
		
		clko <= clkop;
	end process;
end architecture;