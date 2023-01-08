library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity beat_controller is
	generic(
		  bpm_addr: unsigned(19 downto 0) := "00000000000000000000" -- 0
		  );
	port(
	     CLOCK_50: in std_logic;
		  clk_count: in std_logic_vector(20 downto 0);
		  bpm: out std_logic_vector(9 downto 0);
		  enabled: in std_logic;
		  servo_pin: out std_logic;

		  --sram
		  read_n: out std_logic;
		  data: in std_logic_vector(15 downto 0);
		  address: out std_logic_vector(19 downto 0)
	);
end entity;

architecture beat_controller_arch of beat_controller is
	component prescaler is
		generic(
			max_cnt: integer := 25000000
		);
		port(
			clki: in std_logic;
			freq: in std_logic_vector(19 downto 0);
			clko: out std_logic
		);
	end component;
	
	component servo is
		port(
			clki: in std_logic;
			servo: out std_logic
		);
	end component servo;
	
	signal read_n_sig: std_logic := '0';
	signal write_n: std_logic := '0';
	signal data_input: unsigned(15 downto 0) := "0000000000000000";
	signal data_output: std_logic_vector(15 downto 0);
	signal read_clock: std_logic;
	signal sram_clock: std_logic;
	signal clk_servo: std_logic := '0';
	signal current_address: unsigned(19 downto 0) := bpm_addr;
	signal enabled_servo: std_logic := '0';
	signal test: integer := 2400;
begin
	c2: prescaler port map(
		clki => CLOCK_50,
		freq => "00000000011111010000", --00000000001111101000
		clko => read_clock
	);
		
	--s: servo port map(
		--clki => clk_servo, 
		--servo => servo_pin
	--);
	
	process(read_clock)
		variable bps_counter: integer := 0;
		variable clk_counter: integer := 0;
		variable ms: integer := 0;
		variable second_passed: integer := 0;
		variable activate_servo: std_logic := '0';
		variable counter_write: integer := 1;
		variable counter_read: integer := 0;
		variable write_data: std_logic := '0';
		variable address_sram: unsigned(19 downto 0);
		variable clk_test: std_logic := '0';
	begin
		if(rising_edge(read_clock)) then
			if(enabled_servo = '1') then
				if(counter_read mod 2 = 0) then
					read_n_sig <= '1';
				else
					read_n_sig <= '0';
					ms := to_integer(unsigned(data));
					clk_counter := clk_counter + 1;
					
					if clk_counter mod 1000 = 0 then
						bpm <= std_logic_vector(to_unsigned(bps_counter * 60, bpm'length));
						bps_counter := 0;
						second_passed := second_passed + 1;
					end if;	
					
					if ms = clk_counter then
						bps_counter := bps_counter + 1;
						address_sram := address_sram + 1;
						servo_pin <= '1';
					else
						servo_pin <= '0';
					end if;
					
					clk_servo <= activate_servo;
				end if;
			end if;
			current_address <= address_sram;
			address <= std_logic_vector(current_address);
			read_n <= read_n_sig;
			bpm <= std_logic_vector(to_unsigned(ms / 1000, 10));
		end if;
	end process;
	
end architecture;	