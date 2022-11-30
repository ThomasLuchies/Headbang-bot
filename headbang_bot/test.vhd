library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
	generic(
		max_cnt: integer := 25000000;
		duty_cycle_clk1000: integer := 1000
	);
	port(CLOCK_50: in std_logic;
		  servo: out std_logic;
		  switch: in std_logic
    );
end entity;

architecture servo_controller_arch of test is
	signal clk1000: std_logic := '0';
	signal servo_clk: std_logic := '0';
	signal wait_time: integer := 0;
begin
	process(CLOCK_50)
		variable counter: integer := 0;
		variable clko: std_logic := '0';
	begin
		if rising_edge(CLOCK_50) then
			counter := counter + 1;
			
			if counter > max_cnt / duty_cycle_clk1000 then
				counter := 0;
				clko := not clko;
			end if;
			
			servo_clk <= clko;		
		end if;

	end process; 
	
	process(servo_clk)
		variable counter: integer := 0;
	begin
		if rising_edge(servo_clk) then
			counter := counter + 1;
			
			if counter <= wait_time then
				servo <= '1';
			else 
				servo <= '0';
			end if;
			
			if counter > 20 then
				counter := 0;
			end if;
		end if;
	end process;
	
	process(switch)
	begin
		if switch = '1' then
			wait_time <= 2;
		else 
			wait_time <= 1;
		end if;
	end process;

end architecture;