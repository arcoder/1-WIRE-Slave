----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:52 03/05/2013 
-- Design Name: 
-- Module Name:    Interface - Behavioral 
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

entity Interface is port(
BUS_INOUT: inout std_logic;
RESET:in std_logic;
CLK:in std_logic;
DATA: out std_logic_vector(7 downto 0)
);
end Interface;

architecture Behavioral of Interface is

component EdgeDetector is port(	
	BUS_1WIRE: in std_logic;
	UP:out std_logic;
	DOWN:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
	);
end component;


component ResetManager is port(	
--	BUS_1WIRE: in std_logic;
	MASTER_EDGE_UP:in std_logic;
	MASTER_EDGE_DOWN:in std_logic;
	RESET_ACK:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
);
end component;

component PresenceManager is port(	
	RESET_ACK:in std_logic;
--	BUS_1WIRE:in std_logic;
	BUS_1WIRE_OUT:out std_logic;
	START:out std_logic;
	CLK:in std_logic;
	RESET:in std_logic
	);
end component;



component Reader is port(
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
end component;

component Sequencer is port(
	RESET_ACK: in std_logic;	
	PRESENCE_ACK: in std_logic;
	READ_BYTE_ACK: in std_logic;
	WRITE_ACK: in std_logic;
	DATA:in std_logic_vector(7 downto 0);
	DATA_OUT:out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	RESET: in std_logic;
--	OK_READ: out std_logic;
	READ_ENABLE:out std_logic;
	READ_BIT_ACK: in std_logic;
	WRITTEN_BIT_ACK: in std_logic;
	WRITE_ENABLE: out std_logic;
	ADDRA: out std_logic_vector(3 downto 0 );
	ROMDATA: in std_logic_vector(3 downto 0 );
	SHIFT_CONTENT: in std_logic_vector(7 downto 0 )
);
end component;

component Writer is port(
	MASTER_EDGE_DOWN:in std_logic;
	CLK:in std_logic;
	RESET:in std_logic;
	--BUS_1WIRE:in std_logic;
	BUS_1WIRE_OUT:out std_logic;
	DATA:in std_logic_vector(7 downto 0);
	DATA_OUT:out std_logic_vector(0 to 7);
	WRITTEN_BIT_ACK: out std_logic;
	WRITE_ACK: out std_logic;
	WE: in std_logic
);
end component;


COMPONENT ROM IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END component;

signal bus_in: std_logic;
signal master_edge_down, master_edge_up: std_logic := '0';

signal data_read: std_logic_vector(7 downto 0) := (others => '0');
signal mydata   : std_logic_vector(7 downto 0); -- := "11001111";
signal byte_ack, wbit_ack, rbit_ack, write_enable, reset_manager,  read_byte_enable, write_byte: std_logic := '0';

signal out1, out2, start_communication : std_logic; -- := '0';


signal pc: std_logic_vector(3 downto 0);
signal rom_data: std_logic_vector(3 downto 0);
signal write_shift_content : std_logic_vector(0 to 7) := (others => '0');


begin

bus_in <= to_x01(BUS_INOUT);
BUS_INOUT <= '0' when (out1 = '1' or out2 = '1') else 'Z';

DATA <= "11111111" when data_read = "11001100" else "ZZZZZZZZ";
--DATA <= mydata;

--DATA <= write_shift_content;


-- sensor <= "0000" & SENSOR_IN;









U0: EdgeDetector
port map( 
	BUS_1WIRE => BUS_IN, 
	UP => master_edge_up, 
	DOWN => master_edge_down, 
	RESET => RESET, 
	CLK => CLK
);



U1: ResetManager
port map( 
--	BUS_1WIRE => BUS_IN, 
	MASTER_EDGE_UP => master_edge_up, 
	MASTER_EDGE_DOWN => master_edge_down, 
	RESET => RESET, 
	RESET_ACK => reset_manager,
	CLK => CLK
);

U2: PresenceManager
port map( 
--	BUS_1WIRE => BUS_IN,
	BUS_1WIRE_OUT => out1,
	RESET => RESET, 
	RESET_ACK => reset_manager,
	CLK => CLK,
	START => start_communication
);


U3: Reader
port map(
--	MASTER_EDGE_UP => master_edge_up,
	MASTER_EDGE_DOWN => master_edge_down,
	CLK => CLK,
	RESET => RESET,
	BUS_1WIRE => BUS_IN,
	DATA => data_read,
	READ_BYTE_ACK => byte_ack,
	READ_BIT_ACK => rbit_ack,
	RE => read_byte_enable

);


U4: Writer
port map(
	MASTER_EDGE_DOWN => master_edge_down,
	CLK => CLK,
	RESET => RESET,
	BUS_1WIRE_OUT => out2,
	DATA => mydata,
	DATA_OUT => write_shift_content,
	WRITTEN_BIT_ACK => wbit_ack,
	WRITE_ACK => write_byte,
	WE => write_enable

);



U5: Sequencer
port map (
	RESET_ACK => reset_manager,
	PRESENCE_ACK => start_communication,
	READ_BYTE_ACK => byte_ack,
	WRITE_ACK => write_byte,
	WRITE_ENABLE => write_enable,
	DATA => data_read,
	DATA_OUT => mydata,
	CLK => CLK,
	RESET => RESET,
--	OK_READ => byte_ack,
	READ_BIT_ACK => rbit_ack,
	READ_ENABLE => read_byte_enable,
	WRITTEN_BIT_ACK => wbit_ack,
	ADDRA => pc,
	ROMDATA => rom_data,
	SHIFT_CONTENT => write_shift_content
);

U6: ROM
port map (
	addra => pc,
	douta => rom_data,
	clka => CLK
);
end Behavioral;

