library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_clear is
	generic(
				amount_adresses: unsigned(19 downto 0) := (others=>'1')
			);
	port(
			clk: in std_logic;
			reset: in std_logic;
			done: out std_logic;
			
			--sram
			SRAM_ADDR: out std_logic_vector(19 downto 0);
		   SRAM_DQ: inout std_logic_vector(15 downto 0);
		   SRAM_CE_N: out std_logic;
		   SRAM_OE_N: out std_logic;
		   SRAM_WE_N: out std_logic;
		   SRAM_UB_N: out std_logic;
		   SRAM_LB_N: out std_logic
   );
end entity;

architecture sram_clear_arch of sram_clear is
	component sram_controller is port
	(
		clk : in std_logic; -- assumes a speed of 50mHz

		-- user side
		read_n, write_n : in std_logic;
		data_input : in std_logic_vector(15 downto 0);
		addr_input : in std_logic_vector(19 downto 0);
		data_output : out std_logic_vector(15 downto 0);
		
		-- SRAM side
		data : inout std_logic_vector(15 downto 0);
		address : out std_logic_vector(19 downto 0);
		output_enable_n : out std_logic := '1';
		write_enable_n : buffer std_logic := '1';
		chip_select_n : out std_logic := '1';
		ub_n : out std_logic := '0'; -- always active
		lb_n : out std_logic := '0' -- always active
	);
	end component;

	signal reset_sram: std_logic := '0';
	signal read_n: std_logic := '1';
	signal write_n: std_logic := '0';
	signal data_input: unsigned(15 downto 0) := "0000000000000000";
	signal data_output: std_logic_vector(15 downto 0);
	signal write_clock: std_logic;
	signal sram_clock: std_logic;
	--signal servo: std_logic;
	signal current_address: unsigned(19 downto 0) := (others=>'0');
		ub_n => SRAM_UB_N, 
		lb_n => SRAM_LB_N
	);	
	 
	process(clk) 
		variable write_clockp: std_logic := '0';
	begin
		if rising_edge(clk) then
			if reset = '1' then 
				write_clockp := not write_clockp;
				
				if write_clockp = '0' then
					if current_address < amount_adresses then
						current_address <= current_address + 1;
					else
						done <= '1';
					end if;
				end if;
			else
				current_address <= (others=> '0');
				done <= '0';
			end if;
			
			write_clock <= write_clockp;
		end if;
	end process;
end architecture;	
begin
	sc: sram_controller port map(
		clk => write_clock,
		read_n => read_n, 
		write_n => write_n, 
		data_input => std_logic_vector(data_input), 
		addr_input => std_logic_vector(current_address), 
		data_output => data_output, 
		data => SRAM_DQ, 
		address => SRAM_ADDR, 
		output_enable_n => SRAM_OE_N, 
		write_enable_n => SRAM_WE_N, 
		chip_select_n => SRAM_CE_N, 
	