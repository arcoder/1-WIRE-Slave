--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:45 04/06/2013
-- Design Name:   
-- Module Name:   C:/Users/alberto/Documents/Progetti/SUBPROJECT/SEARCH_ROM/MATCH_ROM_BENCH.vhd
-- Project Name:  SEARCH_ROM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Interface
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MATCH_ROM_BENCH IS
END MATCH_ROM_BENCH;
 
ARCHITECTURE behavior OF MATCH_ROM_BENCH IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Interface
    PORT(
         BUS_INOUT : INOUT  std_logic;
         RESET : IN  std_logic;
         CLK : IN  std_logic;
         DATA : OUT  std_logic_vector(7 downto 0);
         RE   : IN   std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';

	--BiDirs
   signal BUS_INOUT : std_logic;

 	--Outputs
   signal DATA : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Interface PORT MAP (
          BUS_INOUT => BUS_INOUT,
          RESET => RESET,
          CLK => CLK,
          DATA => DATA,
          RE   => '1'
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

		BUS_INOUT <= 'H';
		--wait for 30 ms;
		--BUS_INOUT <= '0';
		--wait for 490 us;
		--BUS_INOUT <= 'H';
		--wait for 19510 us;
		
		wait for 50 us;
		BUS_INOUT <= '0';
		wait for 480 us;
		BUS_INOUT <= 'H';
		
		wait for 120 us;
	

		-- 1 --
		BUS_INOUT <= '0';
		wait for 20 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;	
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

		-- 1 --
		BUS_INOUT <= '0';
		wait for 20 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
	
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --
		BUS_INOUT <= '0';
		wait for 20 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
	
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

		-- 1 --	
		BUS_INOUT <= '0';
		wait for 20 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
	
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		---FINE COMANDO MATCH_ROM --
		
		wait for 10 ms;
		
		--- INIZIO INVIO 64bit codice dal master


		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

      -- SECONDO BYTE START ----
		wait for 10 ms;


		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;

		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;

		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		wait for 10 ms;
		-- TERZO 0x1F ---------------
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;		
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;		
				
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

		wait for 10 ms;
		-- WAIT FOR 0x8D ---------------------------
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;		
				
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;	

		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;			
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;

		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;		

		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;

		-- WAIT FOR 0x70 ---------------------------
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
	
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;

		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- WAIT FOR 0x00 ---------------------------		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
			
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- WAIT FOR 0x00 ---------------------------		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
			
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- WAIT FOR 0x00 ---------------------------		
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		-- 1 --	
		BUS_INOUT <= '0';
		wait for 300 ns;
		BUS_INOUT <= 'H';
		wait for 90 us;
			
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
		
		
		-- 0 --		
		BUS_INOUT <= '0';
		wait for 90 us;
		BUS_INOUT <= 'H';
		wait for 10 us;
      wait;
   end process;

END;
