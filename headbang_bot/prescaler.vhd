library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
	generic(
		max_cnt: integer := 25000000
	);
	port(
		clki: in std_logic;
		freq: in std_logic_vector(19 downto 0);
		clko: out std_logic
	);
end entity;

architecture prescaler_arch of prescaler is
begin
	process(clki)
		variable cnt: integer range 0 TO max_cnt := 0;
      variable cnt_max : integer := 0;
		variable clkop: std_logic := '0';
	begin
		if rising_edge(clki) then
			if cnt_max /= (max_cnt / (to_integer(unsigned(freq)))) then
				cnt_max := (max_cnt / (to_integer(unsigned(freq))));
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