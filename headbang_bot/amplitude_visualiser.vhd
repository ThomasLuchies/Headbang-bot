library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_visualiser is port
(
	channel: in std_logic_vector(15 downto 0);
	amplitude: out std_logic_vector(25 downto 0)
);
end entity;

architecture rtl of audio_visualiser is
	signal channel_quantity: signed(15 downto 0);
begin
	process (channel) begin
		channel_quantity <= signed(channel);
		if channel_quantity <= 0 then
			amplitude <= (others => '0');
		elsif channel_quantity <= 1000 then
			amplitude <= "00000000000000000000000001";
		elsif channel_quantity <= 3000 then
			amplitude <= "00000000000000000000000111";
		elsif channel_quantity <= 6000 then
			amplitude <= "00000000000000000000001111";
		elsif channel_quantity <= 9000 then
			amplitude <= "00000000000000000000111111";
		elsif channel_quantity <= 12000 then
			amplitude <= "00000000000000000001111111";
		elsif channel_quantity <= 15000 then
			amplitude <= "00000000000000000111111111";
		elsif channel_quantity <= 18000 then
			amplitude <= "00000000000000001111111111";
		elsif channel_quantity <= 21000 then
			amplitude <= "00000000111111111111111111";
		elsif channel_quantity <= 24000 then
			amplitude <= "00000011111111111111111111";
		elsif channel_quantity <= 27000 then
			amplitude <= "00001111111111111111111111";
		elsif channel_quantity <= 30000 then
			amplitude <= "00111111111111111111111111";
		elsif channel_quantity <= 32768 then
			amplitude <= "11111111111111111111111111";
		else
			amplitude <= (others => '0');
		end if;
	end process;
end architecture;