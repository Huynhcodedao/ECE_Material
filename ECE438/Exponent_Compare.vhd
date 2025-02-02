library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity Exponent_Compare is
port(
  A_Val_Exp : in  std_logic_vector(7 downto 0);
  B_Val_Exp : in  std_logic_vector(7 downto 0);
  AGTB : out std_logic;
  ALTB : out std_logic;
  AETB : out std_logic
  );
end entity;

architecture Exponent_Compare of Exponent_Compare is  

signal AGTB_i : std_logic;
signal ALTB_i : std_logic;
signal AETB_i : std_logic;

begin
  
  AGTB <= '1' after 2 ns when A_Val_Exp > B_Val_Exp else '0' after 2 ns;
  ALTB <= '1' after 2 ns when A_Val_Exp < B_Val_Exp else '0' after 2 ns;
  AETB <= '1' after 2 ns when A_Val_Exp = B_Val_Exp else '0' after 2 ns;

end architecture;