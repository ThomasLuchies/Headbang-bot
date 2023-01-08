library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity servo_controller is	generic
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
end entity;

architecture servo_controller_arch of servo_controller is
	signal servo_clk: std_logic := '0';
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
			servo_clk <= clkop;		
		end if;
	end process;
	process(servo_clk)
		variable counter: integer := 0;
	begin
		if rising_edge(servo_clk) then
			counter := counter + 1;
			if counter <= direction then
				clko <= '1';
			else 
				clko <= '0';
			end if;
			if counter > 40 then
				counter := 0;
			end if;
		end if;
	end process;
end architecture;