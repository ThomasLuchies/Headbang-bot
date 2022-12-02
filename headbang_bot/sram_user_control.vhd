library ieee;
use ieee.std_logic_1164.all;

entity sram_user_control is
port
(
	clk					: in std_logic;

	-- user control
	KEY : in std_logic_vector(3 downto 0);
	SW	: in std_logic_vector(17 downto 0);
	LEDR : out std_logic_vector(17 downto 0);

	-- sram_controller side
	data 					: inout std_logic_vector(15 downto 0);
	address 				: out std_logic_vector(19 downto 0);
	output_enable_n 	: out std_logic := '0';
	write_enable_n		: buffer std_logic := '1';
	chip_select_n		: out std_logic := '1';
	ub_n					: out std_logic := '0';
	lb_n					: out std_logic := '0'
);
end entity;

architecture rtl of sram_user_control is begin

	sram_controller : entity work.sram_controller port map
	(
		clk					=> clk,
		reset_n				=> KEY(1),
		
		-- schematic side
		read_write_n		=> KEY(0),
		data_input			=> SW(15 downto 0),
		addr_input			=> (others => '0'), -- hardcoded to first address (0x0000)
		data_output			=> LEDR(15 downto 0),
		
		-- sram side
		address				=> address,
		output_enable_n	=> output_enable_n,
		write_enable_n		=> write_enable_n,
		chip_select_n		=> chip_select_n,
		ub_n					=> ub_n,
		lb_n					=> lb_n
	);
	
	LEDR(17 downto 16) <= (others => '0');

end architecture;