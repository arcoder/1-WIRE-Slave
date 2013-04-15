----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Alberto Ruffo
-- Design Name: 
-- Module Name:    Sequencer - Behavioral 
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

entity Sequencer is port(

	RESET_ACK: in std_logic;	
	PRESENCE_ACK: in std_logic;
	READ_BYTE_ACK: in std_logic;
	WRITE_ACK: in std_logic;
	DATA:in std_logic_vector(7 downto 0);
	DATA_OUT:out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	RESET: in std_logic;
	READ_ENABLE:out std_logic;
	READ_BIT_ACK: in std_logic;
	WRITTEN_BIT_ACK: in std_logic;
	WRITE_ENABLE: out std_logic;
	ADDRA: out std_logic_vector(3 downto 0 );
	ROMDATA: in std_logic_vector(3 downto 0 );
	SENSOR_DATA: out std_logic_vector(7 downto 0 );
	SHIFT_CONTENT: in std_logic_vector(7 downto 0 );
	RE: in std_logic
	
);
end Sequencer;

architecture Behavioral of Sequencer is

	type STATUS is (
		IDLE, TRANS, READ_CMD, SENSOR_CMD,
		WRITE_BYTE, LOAD, SEND_BIT_ROM, LOAD_BIT_ROM, 
		READ_BIT_FROM_MASTER, NEXT_ROW, WAIT_CLK_FOR_MEM ,
		MATCH_ROM_READ, LOAD_FIRST_4BIT, LOAD_SECOND_4BIT, COMPARE, CHECK_CODE, INTERMEDIATE, REBRANCHING
		);
	signal PRESENT_STATE, NEXT_STATE: STATUS;
	
	signal cursor : std_logic_vector(3 downto 0) := ( others => '0');
	signal bit_position_value, load1, load2 : std_logic := '0';
	signal count_ack_bit : std_logic_vector(1 downto 0) := "00";
	signal count_enable, cursor_enable, cursor_reset, count_read_enable: std_logic := '0';
	signal compare_sg1, compare_sg2: std_logic_vector(3 downto 0) := (others => '0');
	signal count_read : std_logic_vector(2 downto 0) := "000";
begin


ADDRA <= cursor;

output: process( CLK )
begin
	if( CLK'event and CLK = '1' ) then
		if( PRESENT_STATE = SEND_BIT_ROM and count_ack_bit="00") then
			bit_position_value <= SHIFT_CONTENT(7);
		end if;
	end if;
end process;


counter_written_ack_bit: process(CLK, RESET)
begin
if RESET = '1' then
	count_ack_bit <= (others => '0');
elsif CLK'event and CLK = '1' then
	if count_ack_bit = "10" then 
		count_ack_bit <= (others => '0');
	else
		if count_enable = '1' then
			count_ack_bit <= count_ack_bit + 1;
		end if;
	end if;
end if;
end process;

count_read_block: process(CLK, RESET)
begin
if RESET = '1' then
	count_read <= (others => '0');
elsif CLK'event and CLK = '1' then
	if count_read = "100" then 
		count_read <= (others => '0');
	else
		if count_read_enable = '1' then
			count_read <= count_read + 1;
		end if;
	end if;
end if;
end process;



cursor_counter: process(CLK, RESET)
begin
if RESET = '1' then
	cursor <= (others => '0');
elsif CLK'event and CLK = '1' then
	if cursor_enable = '1' then
		cursor <= cursor + 1;
	else
		if cursor_reset = '1' then
			cursor <= (others => '0');
		end if;
	end if;
end if;
end process;


count_compare1: process(CLK, RESET)
begin
if RESET = '1' then
	compare_sg1 <= (others => '0');
elsif CLK'event and CLK = '1' then
	if load1 = '1' then
		compare_sg1 <= ROMDATA;
	end if;
end if;
end process;

count_compare2: process(CLK, RESET)
begin
if RESET = '1' then
	compare_sg2 <= (others => '0');
elsif CLK'event and CLK = '1' then
	if load2 = '1' then		
		compare_sg2 <= ROMDATA;
	end if;
end if;
end process;

main_state_machine: process(  RESET_ACK, PRESENCE_ACK, RE,
										READ_BYTE_ACK, DATA, 
										PRESENT_STATE, READ_BIT_ACK, 	
										WRITTEN_BIT_ACK, ROMDATA, 
										WRITE_ACK, count_ack_bit, SHIFT_CONTENT, bit_position_value, 
										cursor, count_read, compare_sg1, compare_sg2)
begin
case PRESENT_STATE is

	when IDLE =>
		if PRESENCE_ACK = '1' then
		  NEXT_STATE <= READ_CMD;
		else
		  NEXT_STATE <= IDLE;
		end if;
		
		DATA_OUT <= SHIFT_CONTENT;
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
		
when READ_CMD =>

		if RESET_ACK = '0' then
			if READ_BYTE_ACK = '0' then
				READ_ENABLE <= '1';
				NEXT_STATE <= READ_CMD;
			else
				-- IF DATA IS SEARCH ROM COMMAND
				if DATA = "11110000" then
				--	DATA_OUT <= "00011000";
					NEXT_STATE <= LOAD_BIT_ROM;
				elsif DATA = "01010101" then
					NEXT_STATE <= MATCH_ROM_READ;
				elsif DATA = "00001111" then
					NEXT_STATE <= SENSOR_CMD;
				else
					NEXT_STATE <= READ_CMD;
				end if;

				READ_ENABLE <= '0';
			end if;
		else
			NEXT_STATE <= IDLE;
			READ_ENABLE <= '0';
		end if;
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		cursor_reset <= '1';
		load1 <= '0';
		load2 <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		SENSOR_DATA <= "ZZZZZZZZ";
		
when SENSOR_CMD =>

		if RESET_ACK = '0' then
			if READ_BYTE_ACK = '0' then
				READ_ENABLE <= '1';
				NEXT_STATE <= SENSOR_CMD;
			else			
				NEXT_STATE <= SENSOR_CMD;
				READ_ENABLE <= '0';
			end if;
		else
			NEXT_STATE <= IDLE;
			READ_ENABLE <= '0';
		end if;
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		cursor_reset <= '1';
		load1 <= '0';
		load2 <= '0';
		if RE = '1' then
			SENSOR_DATA <= DATA;
		else
			SENSOR_DATA <= "ZZZZZZZZ";
		end if;
		DATA_OUT <= SHIFT_CONTENT;

------------------------------------ MATCH ROM START -----------------------------------------------

	when MATCH_ROM_READ =>
	
		if READ_BYTE_ACK = '0' then
			READ_ENABLE <= '1';
			NEXT_STATE <= MATCH_ROM_READ;
		else
			NEXT_STATE <= LOAD_FIRST_4BIT;
			READ_ENABLE <= '0';
			
		end if;
		
		cursor_enable <= '0';
		cursor_reset <= '0';
		WRITE_ENABLE <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
	
	when LOAD_FIRST_4BIT =>
		-- CARICO i primi 4 bit della rom, a destra, per poi caricare i secondi a sinistra
		NEXT_STATE <= INTERMEDIATE;
		load1 <= '1';
		load2 <= '0';
		
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '1';
		cursor_reset <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		DATA_OUT <= DATA;
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when INTERMEDIATE =>

		load1 <= '0';
		load2 <= '0';

		NEXT_STATE <= LOAD_SECOND_4BIT;
		
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		cursor_reset <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		--DATA_OUT <= "0100" & cursor;
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when LOAD_SECOND_4BIT =>
	
		NEXT_STATE <= COMPARE;
		DATA_OUT <= SHIFT_CONTENT;
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		if cursor = "1111" then
			cursor_enable <= '0';
		else
			cursor_enable <= '1';
		end if;
		cursor_reset <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		load1 <= '0';
		load2 <= '1';
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when COMPARE =>
		if (DATA(3 downto 0) = compare_sg1) and (DATA(7 downto 4) = compare_sg2) then
			NEXT_STATE <= CHECK_CODE;
		else
			NEXT_STATE <= IDLE;
		end if;

		load1 <= '0';
		load2 <= '0';
		
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		cursor_reset <= '0';	
		DATA_OUT <= SHIFT_CONTENT;
		DATA_OUT <= DATA;
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when CHECK_CODE =>
	
		if cursor = "1111" then
			NEXT_STATE <= READ_CMD;
		else
			NEXT_STATE <= MATCH_ROM_READ;
		end if;

		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
		count_read_enable <= '0';
		cursor_reset <= '0';	
		DATA_OUT <= SHIFT_CONTENT;
		load1 <= '0';
		load2 <= '0';
		DATA_OUT <= DATA;
		SENSOR_DATA <= "ZZZZZZZZ";
------------------------------------ MATCH ROM END -----------------------------------------------

when REBRANCHING =>
 		WRITE_ENABLE <= '0';
		READ_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		NEXT_STATE <= LOAD_BIT_ROM;
		SENSOR_DATA <= "ZZZZZZZZ";
		
when LOAD_BIT_ROM =>
	
		WRITE_ENABLE <= '0';
		READ_ENABLE <= '0';
		NEXT_STATE <= SEND_BIT_ROM;
		DATA_OUT <= ROMDATA(0) & not (ROMDATA(0)) &
					ROMDATA(1) & not (ROMDATA(1)) &
					ROMDATA(2) & not (ROMDATA(2)) &
					ROMDATA(3) & not (ROMDATA(3));	
					
					
		cursor_enable <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when SEND_BIT_ROM =>
		DATA_OUT <= SHIFT_CONTENT;

		-- Finchè non scrivo pure il complementare rimango qui
		if count_ack_bit < "10" then
			if WRITTEN_BIT_ACK = '0' then
				WRITE_ENABLE <= '1';
				count_enable <= '0';
			else
				count_enable <= '1';
				WRITE_ENABLE <= '0';
			end if;
			NEXT_STATE <= SEND_BIT_ROM;
		else
			NEXT_STATE <= READ_BIT_FROM_MASTER;
			count_enable <= '0';
			WRITE_ENABLE <= '0';
		end if;
		
		READ_ENABLE <= '0';
		cursor_enable <= '0';
		count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
	when READ_BIT_FROM_MASTER =>
	
		WRITE_ENABLE <= '0';
		DATA_OUT <= SHIFT_CONTENT;
		--if count_read < "111" then
		if READ_BYTE_ACK = '0' then
			if READ_BIT_ACK = '0' then
				READ_ENABLE <= '1';
				NEXT_STATE <= READ_BIT_FROM_MASTER;
				count_read_enable <= '0';
			else
				READ_ENABLE <= '0';
				count_read_enable <= '1';
				if DATA(7) = bit_position_value then
					NEXT_STATE <= NEXT_ROW;
				else
					NEXT_STATE <= REBRANCHING;
				end if;
			end if;
		else
			count_read_enable <= '1';
			READ_ENABLE <= '1';
			if DATA(7) = bit_position_value then
				NEXT_STATE <= NEXT_ROW;
			else
				NEXT_STATE <= IDLE;
			end if;
		end if;
		cursor_enable <= '0';
		count_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
		-- PASSO ALLA NUOVA CELLA DI MEMORIA
	when NEXT_ROW =>
		if count_read = "100" then
			if cursor = "1111" then
				NEXT_STATE <= READ_CMD;
			else
				NEXT_STATE <= WAIT_CLK_FOR_MEM;
			end if;
			cursor_enable <= '1';
		else
			cursor_enable <= '0';
			NEXT_STATE <= SEND_BIT_ROM;	
		end if;

		DATA_OUT <= SHIFT_CONTENT;			
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
		
	when WAIT_CLK_FOR_MEM =>
	
		NEXT_STATE <= LOAD_BIT_ROM;
		DATA_OUT <= SHIFT_CONTENT;	
		WRITE_ENABLE <= '0';
		READ_ENABLE <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';		
		cursor_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";

	when others =>
	
	DATA_OUT <= SHIFT_CONTENT;
	READ_ENABLE <= '0';
	NEXT_STATE <= IDLE;
	DATA_OUT <= "00000000";
		READ_ENABLE <= '0';
		WRITE_ENABLE <= '0';
		cursor_enable <= '0';
		count_enable <= '0';
	   count_read_enable <= '0';
		cursor_reset <= '0';
		load1 <= '0';
		load2 <= '0';
		SENSOR_DATA <= "ZZZZZZZZ";
end case;
end process;


state: process(RESET, CLK )
begin
If RESET = '1' then
	PRESENT_STATE <= IDLE;
elsif( CLK'event and CLK = '1' ) then
		PRESENT_STATE <= NEXT_STATE;
end if;
end process;
end Behavioral;

