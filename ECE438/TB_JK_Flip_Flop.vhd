library ieee;                 --My Test Bench                     
use ieee.std_logic_1164.all;

entity TB_JK_Flip_Flop is
end entity;
  
architecture TB_JK_Flip_Flop of TB_JK_Flip_Flop is

signal J : std_logic;
signal K : std_logic;
signal Clock : std_logic;
signal Q : std_logic;

begin
  
Clock_Control : process
  begin
      Clock <= '1';
      wait for 10 ns;
      Clock <= '0';
      wait for 10 ns;
  end process; 
  
TestBench : process
begin
  
J <= '0';
K <= '0';
wait for 25 ns;

J <= '0';
K <= '1';
wait for 40 ns;

J <= '0';
K <= '0';
wait for 40 ns;

J <= '1';
K <= '0';
wait for 40 ns;

J <= '0';
K <= '0';
wait for 40 ns;

J <= '1';
K <= '1';
wait for 120 ns;

J <= '0';
K <= '0';
wait for 40 ns;

J <= '0';
K <= '1';
wait for 40 ns;

J <= '1';
K <= '0';
wait for 40 ns;

J <= '0';
K <= '1';
wait for 40 ns;

J <= '0';
K <= '1';
wait for 40 ns;

J <= '1';
K <= '1';
wait for 40 ns;

J <= '1';
K <= '0';
wait for 40 ns;

J <= '1';
K <= '1';
wait for 40 ns;



wait;
end process;  
  
  

  
UUT : entity work.JK_Flip_Flop 
  port map(
    J_H => J,         --: in std_logic;
    K_H => K,         --: in std_logic;
    CLK_H => Clock, --: in std_logic;
    Q_H => Q          --: out std_logic
    );
    
  
end architecture;  