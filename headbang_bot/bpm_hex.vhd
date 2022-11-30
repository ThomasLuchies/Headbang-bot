library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bpm_hex is
	port(BPM: in std_logic_vector(9 downto 0);
		  HEX0: out std_logic_vector(0 to 6);
		  HEX1: out std_logic_vector(0 to 6);
		  HEX2: out std_logic_vector(0 to 6)
	);
end entity bpm_hex;

architecture bpm_hex_arch of bpm_hex is
	component decoder_7digit_hex is
		port( digit: in std_logic_vector(3 downto 0);
				segments: out std_logic_vector(0 to 6)
		);
	end component;
begin
	h0: decoder_7digit_hex port map(std_logic_vector(unsigned(BPM) mod 10)(3 downto 0), HEX0);
	h1: decoder_7digit_hex port map(std_logic_vector(((unsigned(BPM) mod 100) - (unsigned(BPM) mod 10)) / 10)(3 downto 0), HEX1);
	h2: decoder_7digit_hex port map(std_logic_vector(unsigned(BPM) / 100)(3 downto 0), HEX2);
end architecture;
