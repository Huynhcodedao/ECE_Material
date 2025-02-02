library IEEE;
use IEEE.std_logic_1164.all;

entity TB_compare is

end entity TB_compare;

architecture TB_compare of TB_compare is

signal gt, lt, et: std_logic;
signal a_exp, b_exp: std_logic_vector(7 downto 0);



begin  


process
begin
  a_exp <= (others => '0');
  b_exp <= (others => '0');
  wait for 80 ns;
assert et = '1' report "incorrect" severity warning;

  a_exp <= (others => '1');
  b_exp <= (others => '0');
  wait for 80 ns;
assert gt = '1' report "incorrect" severity warning;

  a_exp <= (others => '0');
  b_exp <= (others => '1');
  wait for 80 ns;
assert lt = '1' report "incorrect" severity warning;
  
  a_exp <= "00110011";
  b_exp <= "00110010";
  wait for 80 ns;
assert gt = '1' report "incorrect" severity warning;

  a_exp <= "00110011";
  b_exp <= "00110011";
  wait for 80 ns;
assert et = '1' report "incorrect" severity warning;

  a_exp <= "00110000";
  b_exp <= "00110010";
  wait for 80 ns;
assert lt = '1' report "incorrect" severity warning;

  a_exp <= "00110011";
  b_exp <= "00110000";
  wait for 80 ns;
assert gt = '1' report "incorrect" severity warning;

  a_exp <= "00111111";
  b_exp <= "00110010";
  wait for 80 ns;
assert gt = '1' report "incorrect" severity warning;

  
  
  
  wait;
end process;





UUT_compare: entity work.compare_mux_top
port map(
  A_Val_Exp => A_exp,     -- : in  std_logic_vector(7 downto 0);
  B_Val_Exp => B_exp,     -- : in  std_logic_vector(7 downto 0);
  AGTB => gt,             --: out std_logic;
  ALTB  => lt,            --: out std_logic;
  AETB => et               --: out std_logic
  );



end architecture TB_compare; 

