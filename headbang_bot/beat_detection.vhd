library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity beat_detection is generic
(
	TRESHOLD: integer range 0 to 32768 := 29000;
	SERVO_ASSERT_DELAY: integer := 2
);
port
(
	clk: in std_logic;
	first_channel: in std_logic_vector(15 downto 0);
	last_channel: in std_logic_vector(15 downto 0);
	headbang: out std_logic;
	state_out: out std_logic_vector(1 downto 0)
);
end entity;

architecture rtl of beat_detection is
	type state is (s0, s1, s2);
	signal state_signal: state := s0;
	signal amplitude_first_channel: signed(15 downto 0);
	signal amplitude_last_channel: signed(15 downto 0);
	signal servo_high_delay_counter: integer range 0 to SERVO_ASSERT_DELAY := 0;
begin
	process (clk) begin
		if rising_edge(clk) then
			case state_signal is
				when s0 => 
					if amplitude_first_channel >= TRESHOLD or amplitude_last_channel >= TRESHOLD then
						state_signal <= s1;
						headbang <= '1';
					end if;
				when s1 =>
					if servo_high_delay_counter = SERVO_ASSERT_DELAY then
						headbang <= '0';
						state_signal <= s2;
					end if;
					servo_high_delay_counter <= servo_high_delay_counter + 1;
				when s2 =>
					if not (servo_high_delay_counter = 0) then
						servo_high_delay_counter <= 0;
					end if;
					if amplitude_first_channel < TRESHOLD and amplitude_last_channel < TRESHOLD then
						state_signal <= s0;
					end if;
			end case;
		end if;
	end process;
	amplitude_first_channel <= signed(first_channel);
	amplitude_last_channel <= signed(last_channel);
	state_out <= "00" when state_signal = s0 else
					 "01" when state_signal = s1 else
					 "10" when state_signal = s2 else
					 "11";
end architecture;