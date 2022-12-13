library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adc_buffer is port
(
	clk, data_in, reset: in std_logic;
	first_channel_out: out std_logic_vector(15 downto 0);
	last_channel_out: out std_logic_vector(15 downto 0);
	channels_ready: out std_logic;
	-- test pins
	fill_channels_test: out std_logic;
	channel_index_test: out std_logic_vector(4 downto 0)
);
end entity;

architecture rtl of adc_buffer is

	signal first_channel: std_logic_vector(15 downto 0);
	signal last_channel: std_logic_vector(15 downto 0);
	signal channel_index: integer range 0 to 31;
	signal fill_channels: std_logic;

begin
	
	process (clk)
		variable start_to_fill: std_logic;
	begin
		if rising_edge(clk) then
			if reset = '1' then
				first_channel <= (others => '0');
				last_channel <= (others => '0');
				channel_index <= 0;
				fill_channels <= '1';
				channels_ready <= '0';
				start_to_fill := '1';
			end if;
			if fill_channels = '1' or start_to_fill = '1' then
				if channel_index <= 15 then
					first_channel(channel_index) <= data_in;
				elsif channel_index <= 31 then
					last_channel(channel_index - 16) <= data_in;
				elsif channel_index = 31 then
					fill_channels <= '0';
					channels_ready <= '1';
				end if;
				channel_index <= channel_index + 1;
				start_to_fill := '0';
			end if;
		end if;
	end process;
	
	first_channel_out <= first_channel when channel_index = 31 else (others => '0');
	last_channel_out <= last_channel when channel_index = 31 else (others => '0');
	-- test pins
	fill_channels_test <= fill_channels;
	channel_index_test <= std_logic_vector(to_unsigned(channel_index, channel_index_test'length));
	
end architecture;