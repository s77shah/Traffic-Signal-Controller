-- Author: Session 202, Group 20, Sania Shah, Nidhi Subrahmanya
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--state machine entity 
Entity State_Machine IS Port
(
 clk_input, reset, sm_clken, blink, req_NS, req_EW, OFFLINE		: IN std_logic;
 red2, amber2, green2,  red1, amber1, green1, NS_Clear, EW_Clear				: OUT std_logic;
 state 			: out std_logic_vector (3 downto 0) 
 );
END ENTITY;
 

 --holding register architecture 
 Architecture SM of State_Machine is
 
 

 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES
 



 BEGIN
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS 
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock 
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (sm_clken = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS : this describes how to move between states using sequential logic 
-- unless otherwise stated with if-else statements, the state machine will move from state n to state (n+1) 

Transition_Section: PROCESS (OFFLINE, req_NS, req_EW, current_state) 

BEGIN
  CASE current_state IS
        WHEN S0 =>		
				
				IF ((req_NS = '0') AND (req_EW = '1')) THEN -- if the EW request has been made and there is no NS request 
				next_state <= S6; -- jumps to state 6
				
				ELSE
				next_state <= S1;
				
				END IF; 

         WHEN S1 =>	
				IF ((req_NS = '0') AND (req_EW = '1')) THEN  -- if the EW request has been made and there is no NS request 
				next_state <= S6; -- jumps to state 6
				
				ELSE
				next_state <= S2;
				
				END IF; 

         WHEN S2 =>	
				next_state <= S3;
				
				
         WHEN S3 =>
				
				next_state <= S4;
				

         WHEN S4 =>	
				
				next_state <= S5;
				 

         WHEN S5 =>		
				next_state <= S6;
				
         WHEN S6 =>		
				next_state <= S7;
				
         WHEN S7 =>		
				next_state <= S8;
			 

			WHEN S8 =>		
				IF ((req_NS = '1') AND (req_EW = '0')) THEN  -- if the NS request has been made and there is no EW request 
				next_state <= S14; -- jumps to state 14
				
				ELSE
				next_state <= S9;
				
				END IF; 
			
			WHEN S9 =>		
				IF ((req_NS = '1') AND (req_EW = '0')) THEN -- if the NS request has been made and there is no EW request 
				next_state <= S14; -- jumps to state 14
				
				ELSE
				next_state <= S10;
				
				END IF; 
				
			WHEN S10 =>		
				                                       
				next_state <= S11;
				 
				
			WHEN S11=>	
				
				next_state <= S12;
				 
			
			WHEN S12 =>	
				
				next_state <= S13;
				 
			
			WHEN S13 =>		
				next_state <= S14;
			
			WHEN S14 =>		
				next_state <= S15;
				
			WHEN S15 =>		
			 --if offline switch is on: 
				IF (OFFLINE = '1') THEN
					next_state <= S15; --don't move to the next state, stay at 15
				
				ELSE
					next_state <= S0; -- if the offline mode is off, then just go back to s0 
				 
				END IF; 
				
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS 
-- red2, red1 are for segment a red with red2 for NS red (DIG2)  , and red1 for EW red (DIG1) 
-- amber2, amber1 are for segment g, amber with amber2 for NS (DIG2)  , and amber1 for EW  (DIG1)  
-- green2, green1 are for segment d, green with green2 for NS (DIG2)  , and green1 for EW  (DIG1) 

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN S0 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= blink; --NS blinking green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0000";
			
         WHEN S1 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= blink; --NS blinking green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0001";

         WHEN S2 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= '1'; --NS green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0010";

			
         WHEN S3 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= '1'; --NS green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0011";


         WHEN S4 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= '1'; --NS green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0100";


         WHEN S5 =>		
			red2 <= '0';
			amber2 <= '0';
			green2 <= '1'; --NS green
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0101";

				
         WHEN S6 =>		
			red2 <= '0';
			amber2 <= '1'; --NS is amber
			green2 <= '0';
			
			red1 <= '1'; --EW red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '1'; --clear the NS request, sent to holding register 
			EW_Clear <= '0';
			
			state <= "0110";

				
         WHEN S7 =>		
			red2 <= '0';
			amber2 <= '1'; --NS Amber
			green2 <= '0';
			
			red1 <= '1'; --EW Red
			amber1 <= '0';
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "0111";

				
         WHEN S8 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= blink; --EW Blinking green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1000";


			WHEN S9 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= blink; --EW blinking green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1001";


			WHEN S10 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= '1'; --EW green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1010";

			
			WHEN S11 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= '1'; --EW green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1011";

			
			WHEN S12 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= '1'; --EW green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1100";

			
			WHEN S13 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '0';
			green1 <= '1'; --EW green
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			state <= "1101";

			
			WHEN S14 =>		
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '1'; --EW amber
			green1 <= '0';
			
			NS_Clear <= '0';
			EW_Clear <= '1'; --clear EW req, send to holding register 
			
			state <= "1110";

			
			WHEN S15 =>	
		
			state <= "1111"; 
			
			NS_Clear <= '0';
			EW_Clear <= '0';
			
			if( OFFLINE = '1' ) then
				red2 <= blink; -- NS is red blinking
				amber2 <= '0';
				green2 <= '0'; 
				
				red1 <= '0';
				amber1 <= blink; -- EW amber blink
				green1 <= '0'; 
			
			else 
				
			red2 <= '1'; --NS red
			amber2 <= '0';
			green2 <= '0';
			
			red1 <= '0';
			amber1 <= '1'; --EW amber
			green1 <= '0';
			
			end if;
			
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
