library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sram_controller is
port
(
	clk					: in std_logic;
	reset					: in std_logic;

	-- Schematic side
	read_or_write		: in std_logic; -- read = 0, write = 1
	data_input			: in std_logic_vector(15 downto 0);
	addr_input			: in std_logic_vector(19 downto 0);
	
	-- SRAM side
	address 				: out std_logic_vector(19 downto 0);
	output_enable 		: out std_logic := '1';
	write_enable		: buffer std_logic := '0';
	
	-- static
	chip_select			: out std_logic := '1';
	ub						: out std_logic := '0';
	lb						: out std_logic := '0'
);
end sram_controller;

architecture behavior of sram_controller is begin
	
	process (clk, reset) begin

		if rising_edge(reset) then
		
			data <= (others => '0');
			address <= (others => '0');
			output_enable <= '1';
			write_enable <= '0';
			
		elsif rising_edge(clk) then
		
			if (write_enable = '1') then
		
				-- reset write and skip a clock cycle
				write_enable 	<= '0';
				
			elsif (read_or_write = '0') then -- read
			
				address 				<= addr_input;
				output_enable 		<= '1';
				write_enable 		<= '0';
				
			else -- prepare write
			
				address 				<= addr_input;
				output_enable 		<= '0';
				write_enable 		<= '1';

			end if;
		
		end if;
			
	end process;

end behavior;