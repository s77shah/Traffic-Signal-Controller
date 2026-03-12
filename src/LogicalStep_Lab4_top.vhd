-- Author: Session 202, Group 20, Sania Shah, Nidhi Subrahmanya

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- top level entity 
ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

-- top level architecture

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
             clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
            clkin      		    : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component; 
	component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end component;		
 
	component State_Machine port (
			clk_input, reset, sm_clken, blink, req_NS, req_EW, OFFLINE	: in std_logic;
			red2, amber2, green2, red1, amber1, green1	: out std_logic;
			NS_Clear, EW_Clear	: out std_logic; 
			state 	: 	out std_logic_vector (3 downto 0)
			
	);
	end component; 
	
----------------------------------------------------------------------------------------------------
-- SIGNALS AT THE TOP LEVEL 

	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads	-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic;
	SIGNAL sm_clken, blink_sig							: std_logic; 
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); 
	SIGNAL SYNCD_1, SYNCD_3, A2, G2, D2, A1, G1, D1   : std_logic;
	SIGNAL NS_Display : std_logic_vector(6 downto 0); 
	SIGNAL req_NS : std_logic;  
	SIGNAL EW_Display : std_logic_vector (6 downto 0); 
	SIGNAL req_EW : std_logic; 
	SIGNAL NS_Clear : std_logic; 
	SIGNAL EW_Clear : std_logic; 
	SIGNAL STATE_NUM  : std_logic_vector (3 downto 0); 
	SIGNAL OFFLINE : std_logic; 
-- START OF TOP LEVEL CIRCUIT	
BEGIN
-- instances at the top level of the file: 
-- PB FILTERS: filters the signals from the pb inputs 
INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);

--PB_INVERTERS: changes the pb inputs to active high using the pb signals that are filtered 
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);

--SNYCHRONIZER: sets up the synchronization for all the following instances
INST2: synchronizer     port map (clkin_50,'0', rst, synch_rst);

--CLOCK GENERATOR: depending on the simulation/compilation, the generator will change to generate the clock/blink_sig for the state machine	
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

--PB synchronizers: take the crossing req for NS/EW lights (causes it to skip steps )
INST4: synchronizer     port map (clkin_50, synch_rst , pb(0), SYNCD_1);	
INST5: synchronizer     port map (clkin_50, synch_rst, pb(1), SYNCD_3);	

--HOLDING REGISTERS: Holds NS/EW crossing requests, only returning when receiving register clear signal from state machine 
INST6: holding_register port map (clkin_50, synch_rst , NS_Clear , SYNCD_1, req_NS); 
INST7: holding_register port map (clkin_50, synch_rst , EW_Clear , SYNCD_3, req_EW);

--STATE MACHINE: the main traffic control unit, it takes in the global clock and sync reset, as well as the state machine clock enable, blink signal from the clock generator. 
--takes inputs for NS/EW crossing req from holding register, takes inputs for offline mode
-- outputs & signals the controlling for each light 
-- outputs a clear register signal for NS and EW, telling the holding register to release the crossing requests 
-- outputs a clear register signal for NS/EW, telling the holding register to release the crossing requests
-- outputs the current state number for visualization on the leds
INST8: State_Machine 	port map (clkin_50, synch_rst , sm_clken, blink_sig, req_NS, req_EW, OFFLINE,  A2, G2, D2, A1, G1, D1, NS_Clear, EW_Clear, STATE_NUM);

--7 SEGMENT MUX: takes the conctaenated signals and multiplexes them into the 7 segment display 
INST9: segment7_mux 		port map(clkin_50, NS_Display, EW_Display ,  seg7_data , seg7_char2, seg7_char1); 

--OFFLINE SWITCH: causes NS to eventually move to blink , them to the Seven Segment
INST10: synchronizer port map (clkin_50, synch_rst, sw(0), OFFLINE); 

NS_Display <= G2 & '0' &'0' & D2 & '0' &'0' & A2; -- concactenate NS digit for 7 seg display 
EW_display <= G1 & '0' & '0' & D1 & '0' &'0' & A1; --concatenate EW digit for 7 seg display 

leds (7 downto 4) <= STATE_NUM; --displays the current state number on the leds 7 to 4
leds(3) <= req_EW; -- shows if there is an EW crossing request
leds(1) <= req_NS; --shows if there is a NS crosisng request
leds(2) <= D1; -- turns on if EW is green/  blinkif EW is blinking green 
leds(0) <= D2; --turn on ifNS is green/blink is NS blinking green
END ;
