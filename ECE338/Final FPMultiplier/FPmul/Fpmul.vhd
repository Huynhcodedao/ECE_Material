library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

Entity FPmul is
 port ( a,b : in signed(31 downto 0);
        en : in std_logic;
 		mulout : out signed(31 downto 0));
end FPmul;

Architecture structure of FPmul is

signal roundip : signed(45 downto 0) := (others => '0');
signal enrnd : std_logic := '0';
signal exp,expadd : signed(7 downto 0) := (others => '0');
signal temp : signed(22 downto 0);

component SAMul1 is
 generic (N : integer := 23; NN : integer := 46);
 port (a,b : in signed(N-1 downto 0);
	   en : in std_logic;
	   c : out signed(NN-1 downto 0);
	   done : out std_logic);
end  component;

component Round is
 port(rndip : in signed(45 downto 0);
	  en : in std_logic;
	  rndop : out signed(22 downto 0);
	  addexp : out signed(7 downto 0));
end component;

begin

 process(en)
 begin
  if en = '1' and en'event then
   mulout(31) <= a(31) xor b(31);
   exp <= a(30 downto 23) + b(30 downto 23) - 127;
  end if;
 end process;

 s1: SAMul1 port map(a(22 downto 0),b(22 downto 0),en,roundip,enrnd);

 rnd : Round port map(roundip,enrnd,temp,expadd);
 mulout(22 downto 0) <= roundip(45 downto 23);
 mulout(30 downto 23) <= exp + expadd;
end structure; 