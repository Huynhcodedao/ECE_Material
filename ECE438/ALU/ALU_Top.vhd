library IEEE;
use ieee.std_logic_1164.all;

entity ALU_Top is
  generic
  (
    reset_active : std_logic := '1'
  ); 
  port(
    ALU_Control : in std_logic_vector(3 downto 0);
    Word1 : in std_logic_vector(31 downto 0);
    Word2 : in std_logic_vector(31 downto 0);
    Answer : out std_logic_vector(32 downto 0)
    );
end entity ALU_Top;

architecture ALU_Top of ALU_Top is
  
signal Word1_reg : std_logic_vector(31 downto 0);
signal Word2_reg : std_logic_vector(31 downto 0);
    
begin
  
  Word1_reg <= Word1;
  Word2_reg <= Word2;
  
  
  
  
answer <= (Word1_reg AND Word2_reg) when ALU_Control = "0000" else
          (Word1_reg OR Word2_reg) when ALU_Control = "0001"  else
          (Word1_reg NOR Word2_reg) when ALU_Control = "0010";  
  
  
  







end ALU_Top;  

    
    