-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/29/2022 11:05:15"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          bpm_hex
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY bpm_hex_vhd_vec_tst IS
END bpm_hex_vhd_vec_tst;
ARCHITECTURE bpm_hex_arch OF bpm_hex_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL BPM : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL HEX0 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX1 : STD_LOGIC_VECTOR(0 TO 6);
SIGNAL HEX2 : STD_LOGIC_VECTOR(0 TO 6);
COMPONENT bpm_hex
	PORT (
	BPM : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
	HEX0 : BUFFER STD_LOGIC_VECTOR(0 TO 6);
	HEX1 : BUFFER STD_LOGIC_VECTOR(0 TO 6);
	HEX2 : BUFFER STD_LOGIC_VECTOR(0 TO 6)
	);
END COMPONENT;
BEGIN
	i1 : bpm_hex
	PORT MAP (
-- list connections between master ports and signals
	BPM => BPM,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2
	);
-- BPM[9]
t_prcs_BPM_9: PROCESS
BEGIN
	BPM(9) <= '0';
WAIT;
END PROCESS t_prcs_BPM_9;
-- BPM[8]
t_prcs_BPM_8: PROCESS
BEGIN
	BPM(8) <= '0';
WAIT;
END PROCESS t_prcs_BPM_8;
-- BPM[7]
t_prcs_BPM_7: PROCESS
BEGIN
	BPM(7) <= '0';
WAIT;
END PROCESS t_prcs_BPM_7;
-- BPM[6]
t_prcs_BPM_6: PROCESS
BEGIN
	BPM(6) <= '0';
WAIT;
END PROCESS t_prcs_BPM_6;
-- BPM[5]
t_prcs_BPM_5: PROCESS
BEGIN
	BPM(5) <= '0';
WAIT;
END PROCESS t_prcs_BPM_5;
-- BPM[4]
t_prcs_BPM_4: PROCESS
BEGIN
	BPM(4) <= '0';
WAIT;
END PROCESS t_prcs_BPM_4;
-- BPM[3]
t_prcs_BPM_3: PROCESS
BEGIN
	BPM(3) <= '0';
WAIT;
END PROCESS t_prcs_BPM_3;
-- BPM[2]
t_prcs_BPM_2: PROCESS
BEGIN
	BPM(2) <= '0';
WAIT;
END PROCESS t_prcs_BPM_2;
-- BPM[1]
t_prcs_BPM_1: PROCESS
BEGIN
	BPM(1) <= '0';
WAIT;
END PROCESS t_prcs_BPM_1;
-- BPM[0]
t_prcs_BPM_0: PROCESS
BEGIN
	BPM(0) <= '0';
WAIT;
END PROCESS t_prcs_BPM_0;
END bpm_hex_arch;
