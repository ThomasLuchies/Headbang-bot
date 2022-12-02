-- Implements a simple Nios II system for the DE-series board
library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity niosaudio IS --name of top level entity
	 port (CLOCK_50 : in std_logic;
			 KEY : in std_logic_vector (0 DOWNTO 0);
			 SW : in std_logic_vector (17 DOWNTO 0);
			 LEDR : out std_logic_vector (17 DOWNTO 0);
			 audio_ADCDAT1, audio_ADCLRCK1, audio_BCLK1, audio_DACLRCK1 : in std_logic;     
			 audio_DACDAT1 : out std_logic
	 );
end niosaudio;

ARCHITECTURE niosaudio_rtl OF niosaudio IS
	component audioqsys is
		port (
			audio_ADCDAT    : in  std_logic                     := 'X';             -- ADCDAT
			audio_ADCLRCK   : in  std_logic                     := 'X';             -- ADCLRCK
			audio_BCLK      : in  std_logic                     := 'X';             -- BCLK
			audio_DACDAT    : out std_logic;                                        -- DACDAT
			audio_DACLRCK   : in  std_logic                     := 'X';             -- DACLRCK
			clk_clk         : in  std_logic                     := 'X';             -- clk
			leds_export     : out std_logic_vector(17 downto 0);                    -- export
			switches_export : in  std_logic_vector(17 downto 0) := (others => 'X')  -- export
		);
	end component audioqsys;
BEGIN
	 audio : audioqsys PORT MAP(clk_clk => CLOCK_50,
									 leds_export => LEDR(17 DOWNTO 0),
									 switches_export => SW(17 DOWNTO 0),
									 audio_ADCDAT => audio_ADCDAT1,
									 audio_ADCLRCK => audio_ADCLRCK1,
									 audio_BCLK => audio_BCLK1,
									 audio_DACDAT => audio_DACDAT1,
									 audio_DACLRCK => audio_DACLRCK1
									);
END niosaudio_rtl;
