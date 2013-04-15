----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alberto Ruffo
-- 
-- Create Date:    10:27:45 02/26/2013 
-- Design Name: 
-- Module Name:    WRITER - Behavioral 
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


entity WRITER is port(
--	MASTER_EDGE_UP:in std_logic;
	MASTER_EDGE_DOWN:in std_logic;
	CLK:in std_logic;
	RESET:in std_logic;
	--BUS_1WIRE:in std_logic;
	BUS_1WIRE_OUT:out std_logic;
	DATA:in std_logic_vector(7 downto 0);
	DATA_OUT:out std_logic_Vector(0 to 7);
	WRITE_ACK: out std_logic;
	WRITTEN_BIT_ACK: out std_logic;
	WE: in std_logic
);
end WRITER;

architecture Behavioral of WRITER is


signal count: std_logic_vector(2 downto 0) := (others => '0');
signal count2: std_logic_vector(12 downto 0) := ( others => '0');
signal shift: std_logic_vector(7 downto 0) := (others => '0');
signal myack, load_data, count_enable, count2_enable, shift_enable, out_bit, bit_ack: std_logic := '0';

signal myout : std_logic := '0';

type STATUS is ( LOAD, WAIT_EDGE, SHIFT_BIT, WRITE_BIT, SEND_ACK);
signal PRESENT_STATE, NEXT_STATE: STATUS;


begin

BUS_1WIRE_OUT <= myout;
WRITTEN_BIT_ACK <= bit_ack;

WRITE_ACK <= myack;
out_bit <= shift(7);
DATA_OUT <= shift;

shift_register: process( CLK, RESET )
begin
if( RESET = '1' ) then
	shift <= (others => '0');
elsif( CLK'event and CLK = '1' ) then
	if load_data = '1' then
		shift <= DATA;
	else
		if shift_enable = '1' then
			shift <= shift(6 downto 0) & '0';
		end if;
	end if;
end if;
end process;


counter: process(CLK, RESET)
begin
if RESET = '1' then
	count <= (others => '0');
elsif CLK'event and CLK = '1' then
	if count_enable = '1' then
		count <= count +1;
	end if;
end if;
end process;


counter2: process(CLK, RESET)
begin
if RESET = '1' then
	count2 <= (others => '0');
elsif CLK'event and CLK = '1' then
	if count2_enable = '1' then
		count2 <= count2 + 1;
	else
		count2 <= (others => '0');
	end if;
end if;
end process;


state: process(CLK, RESET)
begin
if RESET = '1' then
	present_state <= LOAD;
elsif CLK'event and CLK = '1' then
	present_state <= next_state;
end if;
end process;





process(WE, master_edge_down, count, count2, out_bit, present_state)
begin
case present_state is

	when LOAD =>
		if WE = '1' then
			load_data <= '0';
			shift_enable <= '0';
			next_state <= WAIT_EDGE;
		else
			load_data <= '1';
			shift_enable <= '0';
			next_state <= LOAD;
		end if;

		count_enable <= '0';
		count2_enable <= '0';
		myack <= '0';
		myout <= '0';
		bit_ack <= '0';

	when WAIT_EDGE =>
		if WE = '1' then
			if master_edge_down = '1' then
				next_state <= WRITE_BIT;
			else
				next_state <= WAIT_EDGE;
			end if;
		else
			next_state <= LOAD;
		end if;

		load_data <= '0';		
		count_enable <= '0';
		count2_enable <= '0';
		bit_ack <= '0';
		shift_enable <= '0';
		myack <= '0';
		myout <= '0';

	when WRITE_BIT =>
		if out_bit = '1' then
			if count2 < "0000011111010" then
				myout <= '1';
				next_state <= WRITE_BIT;
			else
				myout <= '0';
				next_state <= SEND_ACK;
			end if;
		else
			if count2 < "0111110100000" then
				myout <= '1';
				next_state <= WRITE_BIT;
			else
				myout <= '0';
				next_state <= SEND_ACK;
			end if;		
		end if;

		bit_ack <= '0';	
		load_data <= '0';		
		count_enable <= '0';
		shift_enable <= '0';
		count2_enable <= '1';
		myack <= '0';


	WHEN SEND_ACK =>
		if count = "111" then
			myack <= '1';
		else
			myack <= '0';
		end if;

		bit_ack <= '1';		
		load_data <= '0';
		next_state <= LOAD;
		count_enable <= '1';
		shift_enable <= '1';
		count2_enable <= '0';
		myout <= '0';

	when others =>

		load_data <= '0';
		next_state <= LOAD;
		count_enable <= '0';
		count2_enable <= '0';
		shift_enable <= '0';
		myack <= '0';
		myout <= '0';
		bit_ack <= '0';

end case;
end process;
end Behavioral;
