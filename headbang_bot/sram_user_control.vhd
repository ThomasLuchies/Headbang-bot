library ieee;
use ieee.std_logic_1164.all;

entity sram_user_control is port
(
	clk : in std_logic;

	-- user control
	key : in std_logic_vector(3 downto 0);
	sw	: in std_logic_vector(17 downto 0);
	ledr : out std_logic_vector(17 downto 0);

	-- sram_controller side
	data : inout std_logic_vector(15 downto 0);
	address : out std_logic_vector(19 downto 0);
	output_enable_n : out std_logic := '1';
	write_enable_n : buffer std_logic := '1';
	chip_select_n : out std_logic := '1';
	ub_n : out std_logic := '1';
	lb_n : out std_logic := '1'
);
end entity;

architecture rtl of sram_user_control is

	signal target_address : std_logic_vector(19 downto 0) := (others => '0');

begin

	sram_controller : entity work.sram_controller port map
	(
		clk => clk,
		-- schematic side
		read_n => key(0),
		write_n => key(1),
		data_input => sw(15 downto 0),
		addr_input => target_address,
		data_output => ledr(15 downto 0),
		-- sram side
		data => data,
		address => address,
		output_enable_n => output_enable_n,
		write_enable_n => write_enable_n,
      chip_select_n => chip_select_n,
		ub_n => ub_n,
		lb_n => lb_n
	);
	
	target_address <= x"0000F" when sw(17) = '1' else (others => '0');
	ledr(17 downto 16) <= (others => '0');

end architecture;