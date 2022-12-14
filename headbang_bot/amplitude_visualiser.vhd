library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N = 1 downto 26; 10000 + 22768 / (26 / N)

entity audio_visualiser is port
(
	channel: in std_logic_vector(15 downto 0);
	amplitude: out std_logic_vector(25 downto 0)
);
end entity;

architecture rtl of audio_visualiser is
	signal channel_quantity: integer range 0 to 32768;
begin
	process (channel) begin
		channel_quantity <= to_integer(unsigned(channel));
		if channel_quantity <= 0 then
			amplitude <= (others => '0');
		elsif channel_quantity <= 20000 then
			amplitude <= "00000000000000000000000001";
		elsif channel_quantity <= 10875 then
			amplitude <= "00000000000000000000000011";
		elsif channel_quantity <= 11751 then
			amplitude <= "00000000000000000000000111";
		elsif channel_quantity <= 12627 then
			amplitude <= "00000000000000000000001111";
		elsif channel_quantity <= 13502 then
			amplitude <= "00000000000000000000011111";
		elsif channel_quantity <= 14378 then
			amplitude <= "00000000000000000000111111";
		elsif channel_quantity <= 15254 then
			amplitude <= "00000000000000000001111111";
		elsif channel_quantity <= 16129 then
			amplitude <= "00000000000000000011111111";
		elsif channel_quantity <= 17005 then
			amplitude <= "00000000000000000111111111";
		elsif channel_quantity <= 17881 then
			amplitude <= "00000000000000001111111111";
		elsif channel_quantity <= 18756 then
			amplitude <= "00000000000000011111111111";
		elsif channel_quantity <= 19632 then
			amplitude <= "00000000000000111111111111";
		elsif channel_quantity <= 20508 then
			amplitude <= "00000000000001111111111111";
		elsif channel_quantity <= 21384 then
			amplitude <= "00000000000011111111111111";
		elsif channel_quantity <= 22259 then
			amplitude <= "00000000000111111111111111";
		elsif channel_quantity <= 23135 then
			amplitude <= "00000000001111111111111111";
		elsif channel_quantity <= 24011 then
			amplitude <= "00000000011111111111111111";
		elsif channel_quantity <= 24886 then
			amplitude <= "00000000111111111111111111";
		elsif channel_quantity <= 25762 then
			amplitude <= "00000001111111111111111111";
		elsif channel_quantity <= 26638 then
			amplitude <= "00000011111111111111111111";
		elsif channel_quantity <= 27513 then
			amplitude <= "00000111111111111111111111";
		elsif channel_quantity <= 28389 then
			amplitude <= "00001111111111111111111111";
		elsif channel_quantity <= 29265 then
			amplitude <= "00011111111111111111111111";
		elsif channel_quantity <= 30140 then
			amplitude <= "00111111111111111111111111";
		elsif channel_quantity <= 31016 then
			amplitude <= "01111111111111111111111111";
		elsif channel_quantity <= 31892 then
			amplitude <= "11111111111111111111111111";
		elsif channel_quantity <= 32768 then
			amplitude <= "11111111111111111111111111";
		else
			amplitude <= (others => '0');
		end if;
	end process;
end architecture;