library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sram_controller is
port
(
	clk					: in std_logic;
	reset_n				: in std_logic;

	-- Schematic side
	read_write_n		: in std_logic; -- read = 1, write = 0
	data_input			: in std_logic_vector(15 downto 0);
	addr_input			: in std_logic_vector(19 downto 0);
	data_output			: out std_logic_vector(15 downto 0);
	
	-- SRAM side
	data					: inout std_logic_vector(15 downto 0);
	address 				: out std_logic_vector(19 downto 0);
	output_enable_n 	: out std_logic := '0';
	write_enable_n		: buffer std_logic := '1';
	chip_select_n		: out std_logic := '0';
	ub_n					: out std_logic := '0';
	lb_n					: out std_logic := '0'
);
end sram_controller;

architecture behavior of sram_controller is

	signal read_write_wait_cycle : std_logic := '0';

begin
	
	process (clk, reset_n) begin

		if reset_n = '0' then
		
			address <= (others => '0');
			output_enable_n <= '0';
			write_enable_n <= '1';
			
		elsif rising_edge(clk) then
		
			if read_write_wait_cycle = '1' then
			
				if (write_enable_n = '0') then -- wait cycle for write
		
					write_enable_n 	<= '1';
					
				else	-- wait cycle for read
				
					data_output <= data;
				
				end if;
				
				read_write_wait_cycle <= '0';
			
			else
			
				if (read_write_n = '1') then -- read
			
					address 				<= addr_input;
					output_enable_n 	<= '0';
					write_enable_n 	<= '1';
					
				else -- prepare write
				
					address 				<= addr_input;
					data				 	<= data_input;
					write_enable_n  	<= '0';
					output_enable_n	<= '1';

				end if;
				
				read_write_wait_cycle <= '1';
			
			end if;
		
		end if;
			
	end process;

end behavior;