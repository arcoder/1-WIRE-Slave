----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alberto Ruffo
-- 
-- Create Date:    12:09:46 11/25/2012 
-- Design Name: 
-- Module Name:    EdgeDetector - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EdgeDetector is port(
	BUS_1WIRE: in std_logic;
	UP:out std_logic;
	DOWN:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
);
end EdgeDetector;

architecture Behavioral of EdgeDetector is

signal Q: std_logic_vector (15 downto 0) := (others => '0');
signal Q_LAST, temp, temp2: std_logic := '0';

begin
--DOWN <= temp;
DOWN <= Q_LAST and (not temp) and (not Q(0));

UP   <= (not temp2) and Q(0) and (not Q_LAST);

temp <= Q(0) and (not BUS_1WIRE);
temp2<= (not Q(0)) and BUS_1WIRE;

process( CLK, RESET)
begin
if( RESET = '1') then  
	Q <= (others => '0');     
	Q_LAST <= '0';
elsif( CLK'event and CLK = '1' ) then 
	Q <= BUS_1WIRE & Q(15 downto 1);
	Q_LAST <= Q(0);
end if;  
end process;

end Behavioral;

