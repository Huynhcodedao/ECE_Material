library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity ieee_32Bit_Floating_Point_Adder_TB  is
end entity;	

architecture ieee_32Bit_Floating_Point_Adder_TB of ieee_32Bit_Floating_Point_Adder_TB is

signal A_Val : std_logic;
signal B_Val : std_logic;
signal F_Val : std_logic;

component eight_bit_compare is
port(
  A_Val_Exp : in  std_logic_vector(7 downto 0);
  B_Val_Exp : in  std_logic_vector(7 downto 0);
  AGTB : out std_logic_vector(7 downto 0);
  ALTB : out std_logic_vector(7 downto 0);
  AETB : out std_logic_vector(7 downto 0)
  );
end entity;



begin
  
A_Val <= '0';
B_Val <= '0';  



entity work.top
  port map(
    	A_Val <= A_Val,        --: in std_logic_vector(31 downto 0);
	   B_Val <= B_Val,        --: in std_logic_vector(31 downto 0);
	   F_Val <= F_Val         --: out std_logic_vector(31 downto 0)
	   );
	   
end entity;

end architecture;