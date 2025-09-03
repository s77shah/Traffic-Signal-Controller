-- Author: Session 202, Group 20, Sania Shah, Nidhi Subrahmanya
library ieee;
use ieee.std_logic_1164.all;

-- HOLDING REGISTER ENTITY 
entity holding_register is port (

			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 -- HOLDING REGISTER ARCHITECTURE 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;
	signal or_out, not_out, or_out2, and_out : std_logic; 
	
-- function: the holding register captures a signal and keeps it on until it receives a CLEAR signal from the state machine

BEGIN

-- the sensitivity list contains: clk 
    PROCESS (clk) is
    begin
        if (rising_edge(clk)) then --responds to clock rising edge
            -- Clear the register if reset or register_clr is active, otherwise load the register with din
            if (reset = '1' or register_clr = '1') then
                sreg <= '0';  -- Clear the register when reset or register_clr is active
            else
                sreg <= (sreg OR din);  -- Store data in the register
            end if;
        end if;
    end PROCESS;

    dout <= sreg; -- Output the synchronized register value
end circuit;
	