library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

Entity Round is
 port(rndip : in signed(45 downto 0);
	  en : in std_logic;
	  rndop : out signed(22 downto 0);
	  addexp : out signed(7 downto 0));
end Round;

Architecture beh of Round is
begin
 process(en)
 variable tempop: signed(45 downto 0) := (others => '0');
 variable rndopt : signed(23 downto 0) := (others => '0');
 variable aexpt : signed(7 downto 0);

 begin
  if en = '1' and en'event then
   tempop := rndip;
   aexpt := (others => '0');
  
   for count1 in 45 downto 23 loop
   if rndip(count1) = '0' then 
    tempop := tempop(44 downto 0) & "0";
    aexpt := aexpt + 1;
   else 
    exit;
   end if;
   end loop;

   rndopt := tempop(45 downto 22); 
   if rndopt(0) = '1' then
    rndopt(23 downto 1) := rndopt(23 downto 1) + 1;
   end if;
  end if;
  rndop <= rndopt(23 downto 1);
  addexp <= aexpt;
 end process;
end beh;