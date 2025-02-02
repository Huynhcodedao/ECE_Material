library ieee;
use ieee.std_logic_1164.all;library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


entity Cordic_TB IS
end entity;
  
architecture Cordic_TB of Cordic_TB is

signal Clock : std_logic;
signal Reset : std_logic;
signal Address : std_logic_vector(31 downto 0);
signal Request : std_logic;
signal Read_H : std_logic;

signal Data_Bus : std_logic_vector(31 downto 0);
signal Ack : std_logic;

signal Z_Value : std_logic;
signal X_Value : std_logic;
signal Y_Value : std_logic;

begin

Clock_Control : process
    begin
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wait for 10 ns;
    end process;    
        
Testbench_Cordic : process
    begin
      
      reset <= '1';
      address <= (others => 'Z');
      Request <= 'Z';
      Read_H <= 'Z';
      Data_Bus <= (others => 'Z');
      wait for 40 ns;
      reset <= '0';
      
      address <= X"FFFF_1040";      -- Write to Z (4 Event Protocol)
      Request <= '1';               -- 1
      Read_H <= '0';
      Data_Bus <= X"2000_0000";
      wait until ACK = '1';           -- 2
      wait for 20 ns;
      address <= (others => 'Z');
      Request <= '0';               -- 3
      Read_H <= 'Z';
      Data_Bus <= (others => 'Z');
      wait until ACK = '0';           -- 4    
      wait for 20 ns;
      request <= 'Z';
      wait for 20 ns;
      
      address <= X"FFFF_1044";      -- Master Read (4 Event Protocol)
      Request <= '1';               -- 1
      Read_H <= '1';
      Data_Bus <= (others => 'Z');  
      wait until ACK = '1';           -- 2
      wait for 20 ns;
  --    X_Value <= data_bus;
      address <= (others => 'Z');
      Read_H <= 'Z';
      Request <= '0';               -- 3
      wait until ACK = '0';           -- 4    
      wait for 20 ns;      
      request <= 'Z';
      wait for 20 ns;   
      
      
      
      
      
      
    
    
    
    
    wait;    
    end process;
    
    
    
    

Slave_Instantiation : entity work.slave
  port map(
    Clock => clock,       --: in std_logic;
    Reset => reset,       --: in std_logic;
    Address => address,   --: in std_logic;
    Request => request,   --: in std_logic;
    Read_H => read_h,     --: in std_logic;
    
    Data_Bus => data_bus, --: inout std_logic_vector(31 downto 0);
    Ack => ack            --: out std_logic;
    );    
    
    
        
end architecture; 