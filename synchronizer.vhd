-- Author: Session 202, Group 20, Sania Shah, Nidhi Subrahmanya
library ieee;
use ieee.std_logic_1164.all;

-- Synchronizer entity: 
entity synchronizer is port (

			clk			: in std_logic;
			reset		: in std_logic;
			din			: in std_logic;
			dout		: out std_logic
  );
 end synchronizer;
 
 
 --Synchronizer architecture: 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0);
-- function: synchronizer takes an external input, clock signal, uses 2 registered in series w a common clock to synch signals, used for several major components for a synch design
BEGIN

	PROCESS (clk) is
		begin 
			if (rising_edge(CLK)) then --responds on clock rising edge 
				if (RESET = '1') then 
				
					sreg <= "00"; --clear shift register on reset, set to "00"  
			
				else
			
					sreg(0) <= din; --first flipflop (bit 1) to external input signal  
					sreg(1) <= sreg(0); --second flip-flop stage (bit 2) to output of previous stage 
				end if;
			else
			end if; 
	end PROCESS; 
		
		dout <= sreg(1); --output synchronized signal 
	
	end circuit; 
	

