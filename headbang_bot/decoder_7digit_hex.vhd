library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_7digit_hex is
	port( digit: in std_logic_vector(3 downto 0);
			segments: out std_logic_vector(0 to 6)
	);
end entity;

architecture decoder_7digit_hex_arch of decoder_7digit_hex is
begin
	process(digit)
	begin
		CASE digit IS
			WHEN "0000" => segments <= "0000001"; -- 0
			WHEN "0001" => segments <= "1001111"; -- 1
			WHEN "0010" => segments <= "0010010"; -- 2
			WHEN "0011" => segments <= "0000110"; -- 3
			WHEN "0100" => segments <= "1001100"; -- 4
			WHEN "0101" => segments <= "0100100";
			WHEN "0110" => segments <= "0100000";
			WHEN "0111" => segments <= "0001111";
			WHEN "1000" => segments <= "0000000";
			WHEN "1001" => segments <= "0000100"; -- 9
			WHEN OTHERS => segments <= "1111111";
		END CASE;
	end process;
end architecture;