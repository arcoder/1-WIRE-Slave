----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:34:51 12/21/2012 
-- Design Name: 
-- Module Name:    Presence - Behavioral 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PresenceManager is port (
	RESET_ACK:in std_logic;
--	BUS_1WIRE:in std_logic;
--	WRITTEN:out std_logic;
--	NOZERO:out std_logic;
	BUS_1WIRE_OUT:out std_logic;
	START:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
);
end PresenceManager;

architecture Behavioral of PresenceManager is


type STATUS is ( WAITING_RESET_ACK, WAIT_30_HIGH, WRITE_70, CHECK_BUS_HIGH);
signal PRESENT_STATE, NEXT_STATE: STATUS;

signal count1, count2, count3_debug: std_logic_vector(11 downto 0) := (others => '0');
signal write_enable: std_logic := '0';


begin

-- DEGUB LED
--WRITTEN <= led;
--NOZERO <= led3;

BUS_1WIRE_OUT <= '1' when write_enable = '1' else '0';


process(CLK, RESET)
begin
if RESET = '1' then
	present_state <= WAITING_RESET_ACK;
elsif CLK'event and CLK='1' then
	present_state <= next_state;
end if;

end process;


process(CLK, RESET)
begin
if RESET = '1' then
	count1 <= (others => '0');
elsif CLK'event and CLK='1' then
	if present_state = WAIT_30_HIGH then
		count1 <= count1 + 1;
	else
		count1 <= (others => '0');
	end if;
end if;

end process;


process(CLK, RESET)
begin
if RESET = '1' then
	count2 <= (others => '0');
elsif CLK'event and CLK='1' then
	if present_state = WRITE_70 then
		count2 <= count2 + 1;
	else
		count2 <= (others => '0');
	end if;
end if;

end process;



process(CLK, RESET)
begin
if RESET = '1' then
	count3_debug <= (others => '0');
elsif CLK'event and CLK='1' then
	if present_state = CHECK_BUS_HIGH then
		count3_debug <= count3_debug + 1;
	else
		count3_debug <= (others => '0');
	end if;
end if;

end process;


comb: process(RESET_ACK, present_state, count1, count2, count3_debug)
begin
case present_state is
	when WAITING_RESET_ACK =>
		write_enable <= '0';
		if( RESET_ACK = '1' ) then
			next_state <= WAIT_30_HIGH;
		else
			next_state <= WAITING_RESET_ACK;
		end if;
		
		START <= '0';

	when WAIT_30_HIGH =>
		write_enable <= '0';
		-- ha contato per 30us 010111011100
		if( count1 = "010111011100" ) then
			next_state <= WRITE_70;
		else
			next_state <= WAIT_30_HIGH;
		end if;
		
		START <= '0';	
	when WRITE_70 =>
		-- ha contato per 70us
		if( count2 = "110110101100" ) then
			write_enable <= '0';
			next_state <= CHECK_BUS_HIGH;
			START <= '1';
		else
			next_state <= WRITE_70;
			write_enable <= '1';
			START <= '0';
		end if;
		
		
	when CHECK_BUS_HIGH =>
		write_enable <= '0';
		if count3_debug = "000101011110" then
			next_state <= WAITING_RESET_ACK;
		else

			next_state <= CHECK_BUS_HIGH;
		end if;

		START <= '0';
	when others =>
		write_enable <= '0';
		next_state <= WAITING_RESET_ACK;
		START <= '0';		

end case;
end process;


end Behavioral;

