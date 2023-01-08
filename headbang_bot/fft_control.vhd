library ieee;
use ieee.std_logic_1164.all;

entity fft_control is port
(
	clk : in std_logic;
	sink_valid : out std_logic;
	sink_sop : out std_logic;
	sink_eop : out std_logic;
	reset_n : out std_logic := '0'
);
end entity;

architecture rtl of fft_control is
	signal counter : integer := 0;
begin
	process (clk) begin
		if rising_edge(clk) then
			if counter = 0 then
				sink_valid <= '1';
				sink_eop <= '0';
				sink_sop <= '1';
			end if;
			if counter = 1 then
				sink_sop <= '0';
			end if;
			if counter = 2047 then
				sink_eop <= '1';
			end if;
			counter <= counter + 1;
			if counter = 2047 then
				counter <= 0;
			end if;
			if counter = 10 then reset_n <= '1'; end if;
		end if;
	end process;
end architecture;