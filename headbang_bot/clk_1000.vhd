library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_1000 is
	generic(
		max_cnt: integer := 25000000;
		duty_cycle_clk1000: integer := 1000
	);
	port(
		  clki: in std_logic;
		  clko: out std_logic
	);
end entity;

architecture clk_1000_arch of clk_1000 is
begin
	process(clki)
		variable counter: integer := 0;
		variable clkop: std_logic := '0';
	begin
		if rising_edge(clki) then
			counter := counter + 1;
			
			if counter > max_cnt / duty_cycle_clk1000 then
				counter := 0;
				clkop := not clkop;
			end if;
			
			clko <= clkop;		
		end if;

	end process; 
end architecture;