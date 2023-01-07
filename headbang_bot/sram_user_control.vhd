library ieee;
use ieee.std_logic_1164.all;

entity sram_user_control is port
(
	-- sram control	
	read_n, write_n, clear_sram : out std_logic;
	data_input : out std_logic_vector(15 downto 0);
	addr_input : out std_logic_vector(19 downto 0);
	data_output : in std_logic_vector(15 downto 0);
	clear_done: in std_logic;
		
	-- user control
	key : in std_logic_vector(2 downto 0);
	sw	: in std_logic_vector(17 downto 0);
	ledr : out std_logic_vector(17 downto 0);
	ledg : out std_logic_vector(8 downto 0)
);
end entity;

architecture rtl of sram_user_control is

	signal target_address : std_logic_vector(19 downto 0) := (others => '0');
begin


	read_n <= key(0);
	write_n <= key(1);
	clear_sram <= key(2);
	
	data_input <= sw(15 downto 0);
	addr_input <= target_address;
	ledr(15 downto 0) <= data_output;
	ledg(0) <= clear_done;
	
	target_address <= x"0000F" when sw(17) = '1' else (others => '0');
	ledr(17 downto 16) <= (others => '0');

end architecture;