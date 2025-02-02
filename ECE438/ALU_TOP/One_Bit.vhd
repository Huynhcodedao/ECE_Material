library ieee;
use ieee.std_logic_1164.all;

entity one_bit is
   port(
        A_VAL : in std_logic;
        B_VAL : in std_logic;
        ALU_CON : in std_logic_vector(3 downto 0);
        CARRY_IN : in std_logic;
        LESS : in std_logic;
        CARRY_OUT : out std_logic;
        F_VAL : out std_logic
        );
end entity;

architecture one_bit of one_bit is

signal A_AND_B : std_logic;
signal A_OR_B : std_logic;
signal A_ADD_B : std_logic;
signal A_SUBRACT_B : std_logic;
signal A_SET_LESS_THAN_B : std_logic;
signal A_NOR_B : std_logic;

begin
 
 
 F_VAL <= A_AND_B              when ALU_CON = "0000" else
          A_OR_B               when ALU_CON = "0001" else    
          A_ADD_B              when ALU_CON = "0010" else
          A_SUBRACT_B          when ALU_CON = "0011" else
          A_SET_LESS_THAN_B    when ALU_CON = "0111" else
          A_NOR_B              when ALU_CON = "1100";
           
 CARRY_OUT <= (A_VAL AND B_VAL) or (A_VAL AND CARRY_IN) or (B_VAL AND CARRY_IN);             
           
 A_AND_B <= A_VAL AND B_VAL;
 
 A_OR_B <= A_VAL OR B_VAL;
 
 A_ADD_B <= A_VAL XOR B_VAL XOR CARRY_IN;
 
 NEGATE <= Not(B_VAL);
 A_SUBRACT_B <= NEGATE + 1;
 
 A_NOR_B <= A_VAL NOR B_VAL;
        
 

end architecture; 
