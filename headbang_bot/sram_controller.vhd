	library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.all;

	entity sram_controller is 
	generic 
	(
		amount_of_adresses: unsigned(19 downto 0) := (others=>'1')
	);
	port
	(
		clk : in std_logic; -- assumes a speed of 50mHz

		-- user side
		read_n, write_n, clear_sram : in std_logic;
		data_input : in std_logic_vector(15 downto 0);
		addr_input : in std_logic_vector(19 downto 0);
		data_output : out std_logic_vector(15 downto 0);
		clear_done: out std_logic;
		
		-- SRAM side
		data : inout std_logic_vector(15 downto 0);
		address : out std_logic_vector(19 downto 0);
		output_enable_n : out std_logic := '1';
		write_enable_n : buffer std_logic := '1';
		chip_select_n : out std_logic := '1';
		ub_n : out std_logic := '0'; -- always active
		lb_n : out std_logic := '0' -- always active
	);
	end sram_controller;

	architecture behavior of sram_controller is

		type execution is (init, clear);
		type execution_clear is (init, clear, clearing);
		signal execution_state : execution := init;
		signal execution_state_clear : execution_clear := init;
		signal is_reading, is_writing, is_clearing : std_logic := '0';
		
		signal current_address_clear : unsigned(19 downto 0) := (others=>'0');
		signal reset_sram_done: std_logic := '0';
	begin
		process (clk) begin
				
			if rising_edge(clk) then
				if (clear_sram = '0') then
					case execution_state_clear is
						when init =>
							execution_state_clear <= clearing;
							reset_sram_done <= '0';
							chip_select_n <= '0';
							write_enable_n <= '0';
						when clearing =>
							address <= std_logic_vector(current_address_clear);
							data <= "0000000000000000";
							
							current_address_clear <= current_address_clear + 1;
							if current_address_clear = amount_of_adresses then
								execution_state_clear <= clear;
								
							end if;
						when clear =>
							reset_sram_done <= '1';
							chip_select_n <= '1';
							write_enable_n <= '1';
							execution_state_clear <= init;
					end case;
					
					clear_done <= reset_sram_done;
				elsif (write_n = '0' or is_writing = '1') and is_reading = '0' then -- write
				
					case execution_state is
				
						when init =>
						
							-- signals
							address <= addr_input;
							chip_select_n <= '0';
							write_enable_n <= '0';
							data <= data_input;
							-- state
							is_writing <= '1';
							execution_state <= clear;
							
						when clear =>
							
							-- signals
							chip_select_n <= '1';
							write_enable_n <= '1';
							-- state
							is_writing <= '0';
							execution_state <= init;
						
					end case;
					
				elsif (read_n = '0' or is_reading = '1') and is_writing = '0' then -- read
				
					case execution_state is
				
						when init =>
						
							-- signals
							address <= addr_input;
							chip_select_n <= '0';
							output_enable_n <= '0';
							data_output <= data;
							-- state
							is_reading <= '1';
							execution_state <= clear;
							
						when clear =>
						
							-- signals
							chip_select_n <= '1';
							output_enable_n <= '1';
							-- state
							is_reading <= '0';
							execution_state <= init;
						
					end case;
				else
				
					data <= (others => 'Z'); -- set signal to high impedance when not writing nor reading
				
				end if;
				
			end if;
				
		end process;
		
	end behavior;