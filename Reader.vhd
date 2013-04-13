----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:40:15 12/21/2012 
-- Design Name: 
-- Module Name:    Reader - Behavioral 
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

entity Reader is port(
--	MASTER_EDGE_UP:in std_logic;
	MASTER_EDGE_DOWN:in std_logic;
	CLK:in std_logic;
	RESET:in std_logic;
	BUS_1WIRE:in std_logic;
	DATA:out std_logic_vector(7 downto 0);
	READ_BYTE_ACK: out std_logic;
	READ_BIT_ACK: out std_logic;
	RE: in std_logic
);
end Reader;

architecture Behavioral of Reader is

signal count: std_logic_vector(12 downto 0) := (others => '0');
signal count_bit: std_logic_vector(2 downto 0) := (others => '0');

signal shift: std_logic_vector(7 downto 0):= (others => '0');

signal count_bit_enable, count_reset, shift_enable, read_bit_ack_temp, read_byte_ack_temp: std_logic := '0';

type STATUS is (WAITING_EDGE, SAMPLE, CHECK_IF_IS_READING, SEND_ACK, SVUOTA);
signal PRESENT_STATE, NEXT_STATE: STATUS;

begin

DATA <= shift; 
READ_BYTE_ACK <= read_byte_ack_temp;
READ_BIT_ACK <= read_bit_ack_temp;


counter: process(CLK, RESET)
begin
if RESET = '1' then
	count <= (others => '0');
elsif CLK'event and CLK = '1' then
		if count_reset = '0' then
			count <= count + 1;
		else
			count <= (others => '0');
		end if;
end if;
end process;



count_8_bit: process(CLK, RESET)
begin

if RESET = '1' then
	count_bit <= (others => '0');
elsif CLK'event and CLK = '1' then
	if RE = '1' then
			if count_bit_enable = '1' then
				count_bit <= count_bit + 1;
			end if;
	else
		count_bit <= (others => '0');
	end if;
end if;
end process;



shift_register: process( CLK, RESET )
begin
if( RESET = '1' ) then
	shift <= (others => '0');
elsif( CLK'event and CLK = '1' ) then
		if shift_enable = '1' then
			shift <= BUS_1WIRE & shift(7 downto 1);
		end if;
end if;
end process;



process(CLK, RESET)
begin
if RESET = '1' then
	present_state <= WAITING_EDGE;
elsif CLK'event and CLK='1' then
	if RE = '1' then
		present_state <= next_state;
	else
		present_state <= WAITING_EDGE;
	end if;
end if;

end process;



process(present_state, BUS_1wire, count, master_edge_down, count_bit)
begin
case present_state is
	when WAITING_EDGE =>
		if master_edge_down = '1' then
			next_state <= SAMPLE;
			count_reset <= '1';
			count_bit_enable <= '1';
		else
			next_state <= WAITING_EDGE;
			count_reset <= '0';
			count_bit_enable <= '0';
		end if;
		
		read_byte_ack_temp <= '0';
		read_bit_ack_temp <= '0';
		--count_bit_enable <= '0';
		shift_enable <= '0';
		
	when SAMPLE => 
		if count = "0010111011100" then
			shift_enable <= '1';
			--next_state <= CHECK_IF_IS_READING;
			next_state <= send_ack;
		else
			shift_enable <= '0';
			next_state <= SAMPLE;
		end if;
		
		count_reset <= '0';
		read_byte_ack_temp <= '0';
		read_bit_ack_temp <= '0';
		count_bit_enable <= '0';
		
--	when CHECK_IF_IS_READING =>
--		if count < "0101010001011" then
--			next_state <= CHECK_IF_IS_READING;
--			count_bit_enable <= '0';
--			count_reset <= '0';
--		elsif count >= "0101010001011" and count <= "1011001000011" then
--			if BUS_1WIRE = '1' then
--				next_state <= SEND_ACK;
--				count_bit_enable <= '1';
--			else	
--				next_state <= CHECK_IF_IS_READING;
--				count_bit_enable <= '0';
--			end if;
--			count_reset <= '0';
--		else
			-- se supero i 120us, probabilmente è partito un reset, faccio gestire tutto
			-- alla macchina stati principale, mentre qui ritorno in attesa di un nuovo fronte di discesa,
			-- nel frattempo nella macchina a stati principale, tolgo il RE
--			next_state <= WAITING_EDGE;
--			count_bit_enable <= '0';
--			count_reset <= '1';
--		end if;
		
--		read_byte_ack_temp <= '0';
--		read_bit_ack_temp <= '0';
--		shift_enable <= '0';
		
	when SEND_ACK =>
	
		if count_bit = "000" then
			read_byte_ack_temp <= '1';
		else
			read_byte_ack_temp <= '0';
		end if;
		
		read_bit_ack_temp <= '1';
		count_bit_enable <= '0';
		count_reset <= '0';
		shift_enable <= '0';
		
		next_state <= WAITING_EDGE;	
		
	when others =>
		next_state <= WAITING_EDGE;
		read_byte_ack_temp <= '0';
		read_bit_ack_temp <= '0';
		count_bit_enable <= '0';
		count_reset <= '0';
		shift_enable <= '0';
end case;
end process;



end Behavioral;

