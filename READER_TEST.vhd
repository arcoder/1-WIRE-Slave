--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:01:49 04/10/2013
-- Design Name:   
-- Module Name:   C:/Users/alberto/Documents/Progetti/SUBPROJECT/SEARCH_ROM/READER_TEST.vhd
-- Project Name:  SEARCH_ROM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Reader
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
 
ENTITY READER_TEST IS
END READER_TEST;
 
ARCHITECTURE behavior OF READER_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reader
    PORT(
         MASTER_EDGE_DOWN : IN  std_logic;
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         BUS_1WIRE : IN  std_logic;
         DATA : OUT  std_logic_vector(7 downto 0);
         READ_BYTE_ACK : OUT  std_logic;
         READ_BIT_ACK : OUT  std_logic;
         RE : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal MASTER_EDGE_DOWN : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal BUS_1WIRE : std_logic := '0';
   signal RE : std_logic := '0';

 	--Outputs
   signal DATA : std_logic_vector(7 downto 0);
   signal READ_BYTE_ACK : std_logic;
   signal READ_BIT_ACK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reader PORT MAP (
          MASTER_EDGE_DOWN => MASTER_EDGE_DOWN,
          CLK => CLK,
          RESET => RESET,
          BUS_1WIRE => BUS_1WIRE,
          DATA => DATA,
          READ_BYTE_ACK => READ_BYTE_ACK,
          READ_BIT_ACK => READ_BIT_ACK,
          RE => RE
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
			
			MASTER_EDGE_DOWN <= '0';
			BUS_1WIRE <= '1';
			RE <= '0';
			
			
			wait for 20 ms;
			RE <= '1';
			wait for 10 ms;
			-- 1 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			BUS_1wire <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			
			-- 0 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 89 us;
			BUS_1wire <= '1';
			wait for 1 us;
			
			-- 1 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			BUS_1wire <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			
			-- 0 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			BUS_1wire <= '1';
			wait for 1 us;
			-- 1 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			BUS_1wire <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			
			-- 0 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			BUS_1wire <= '1';
			wait for 1 us;
			-- 1 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			BUS_1wire <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			
			-- 0 --
			BUS_1wire <= '0';
			wait for 300 ns;
			MASTER_EDGE_DOWN <= '1';
			wait for 20 ns;
			MASTER_EDGE_DOWN <= '0';
			wait for 90 us;
			BUS_1wire <= '1';
wait for 1 us;
			
			
			wait for 10 ms;
			RE <= '0';
			
      wait;
   end process;

END;
