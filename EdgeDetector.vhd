----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alberto Ruffo
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

entity EdgeDetector is port(
	BUS_1WIRE: in std_logic;
	UP:out std_logic;
	DOWN:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
);
end EdgeDetector;

architecture Behavioral of EdgeDetector is

signal Q: std_logic_vector (1 downto 0) := (others => '0');
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
	Q <= BUS_1WIRE & Q(1);
	Q_LAST <= Q(0);
end if;  
end process;

end Behavioral;

