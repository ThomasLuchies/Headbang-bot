entity servo_controller is
	generic(
		max_cnt: integer := 25000000;
		duty_cycle_clk1000: integer := 1000
	);
	port(clki: in std_logic;
		  direction: in std_logic;
		  clko: out std_logic
    );
end entity

architecture servo_controller_arch of servo_controller is
	signal clk1000: std_logic := '0';
begin
	clk1000: process(clki)
		variable counter: integer;
	begin
		if(counter > max_cnt / duty_cycle_clk1000) then
			clk1000 = clk1000 + 1;
			counter <= 0;
		end if;
	end process;
	
	process(clk_pwm)
		variable clkop: std_logic;
		variable counter: integer;
	begin
		counter = counter + 1;
		
		if direction = '0' then
			if counter = 1 then
				clkop <= '1';
			else
				clkop <= '0';
			end if;
		else if direction = '1' then
			if counter <= 2 then
				clkop <= '1';
			else
				clkop <= '0';
			end if;
		end if;
		
		if counter > 20 then
			counter := 0;
		end if;
		
		clko <= clkop
	end process;
end architecture;