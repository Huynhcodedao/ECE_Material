library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test2 is
 generic (
    G_DELAY : TIME := 1 ns
  );
Port ( 	a 		: in std_logic_vector (3 downto 0);
			--s 		: out std_logic_vector (3 downto 0);
			G		: out std_logic
			);
end test;

architecture Behavioral of test2 is

begin

----	--s <= (a xor (b xor "000" & cin)) after G_DELAY;	
	
	G <=  A(3) and B(3) after G_DELAY;

end Behavioral;
