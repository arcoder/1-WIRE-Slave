----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alberto Ruffo
-- 
-- Design Name: 
-- Module Name:    ResetManager - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ResetManager is port(
	MASTER_EDGE_UP:in std_logic;
	MASTER_EDGE_DOWN:in std_logic;
	RESET_ACK:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
);
end ResetManager;

architecture Behavioral of ResetManager is

signal count: std_logic_vector(15 downto 0) := (others => '0'); 
signal start: std_logic := '0';

begin

RESET_ACK <= start;


counter: process( RESET, CLK )
begin
if( RESET = '1' ) then
	count <= (others => '0');
elsif( CLK'event and CLK = '1' ) then
	if( MASTER_EDGE_DOWN = '1' ) then
		count <= (others => '0');
	else  
		if count >= "0101110110111111" and count <= "111110011111111" then
			if MASTER_EDGE_UP = '1' then
				start <= '1';
			else
				start <= '0';
			end if;
		elsif count < "0101110110111111" then
			if MASTER_EDGE_UP = '0' then
				count <= count + 1;
			else
				count <= (others => '0');
			end if;
		else
			count <= (others => '0');				
		end if;
	end if;
end if;
end process;

end Behavioral;

