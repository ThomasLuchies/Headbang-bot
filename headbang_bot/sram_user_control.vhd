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

	-- sram_controller pins
	data 				: inout std_logic_vector(15 downto 0);
	address 			: out std_logic_vector(19 downto 0);
	output_enable 		: out std_logic := '1';
	write_enable		: buffer std_logic := '0';
	chip_select			: out std_logic := '1';
	ub					: out std_logic := '0';
	lb					: out std_logic := '0'
)
end entity;

architecture rtl of sram_user_control is

	read_or_write 	: std_logic := 0; -- read = 0, write = 1

begin

	sram_controller : entity work.sram_controller port map
	(
		clk				=> clk,
		reset				=> not KEY(1),
		read_or_write	=> not KEY(0),
		data_input		=> SW(15 downto 0),
		addr_input		=> (others => '0'),
		address			=> data,
		output_enable	=> address,
		write_enable	=> output_enable,
		chip_select		=> chip_select,
		ub					=> ub,
		lb					=> lb
	);
	
	process (clk, KEY(1)) begin
	
		if KEY(1) = '0' then
		
			LEDR <= (others => '0');
			reset <= '1';
		
		elsif rising_edge(clk) then
		
			reset <= '0';
		
			if KEY(0) = '0' then -- write
			
				
			
			else

				-- read
			
			end if;
		
		end if;
	
	end process;

end architecture;