-- Author: Session 202, Group 20, Sania Shah, Nidhi Subrahmanya

library ieee;
use ieee.std_logic_1164.all;

-- PB Inverter entity 
entity PB_inverters is port (
	rst_n				: in	std_logic;
	rst				: out std_logic;
 	pb_n_filtered	: in  std_logic_vector (3 downto 0);
	pb					: out	std_logic_vector(3 downto 0)							 
	); 
end PB_inverters;

--PB Inverter architecture: 

architecture ckt of PB_inverters is

begin
rst <= NOT(rst_n); --inverts the filtered pb inputs 
pb <= NOT(pb_n_filtered); --inverts the reset inputs


end ckt;