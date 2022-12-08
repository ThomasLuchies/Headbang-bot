library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity beat_detection is generic
(
	TARGET_FREQ: integer := 440;
	TRESHOLD: integer := 1000; -- determine treshold
);
port
(
	-- NIOS side
	enable: in std_logic;
	
	-- sync clock side
	sync_counter: in std_logic_vector(31 downto 0); -- time in ms

	-- fft side
	input: in std_logic_vector(15 downto 0); -- fft output
	sop: in std_logic;
	seo: in std_logic;
	
	-- sram side
	sram_address: in std_logic_vector(19 downto 0);
	sram_data: inout std_logic_vector(15 downto 0); -- write ms to sram
	read_write: out std_logic
);
end entity;

architecture beat_detection_rtl of beat_detection is

	signal frequency : std_logic_vector(9 downto 0); -- max freq. is 1024/2048? Hz

begin

	-- @440 Hz => magnitude above treshhold?

end architecture;