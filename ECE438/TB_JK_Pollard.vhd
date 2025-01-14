library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;

entity ASYN_TB is
end entity ASYN_TB;

use WORK.all;

architecture ASYN_TB of ASYN_TB is 

component JK_Flip_Flop is
  port (
    J_H   : in  STD_LOGIC;
    K_H   : in  STD_LOGIC;
    CLK_H : in  STD_LOGIC;
    Q_H   : out STD_LOGIC
  );
end component JK_Flip_Flop;


signal X_J_H   : STD_LOGIC := '0';
signal X_K_H   : STD_LOGIC := '0';
signal X_CLK_H : STD_LOGIC := '0';
signal X_Q_H   : STD_LOGIC := '0';

signal COUNT   : INTEGER := 0;

type SIG_ARY is array ( 0 to 1023 ) of STD_LOGIC_VECTOR ( 2 downto 0 );
constant IN_VALS : SIG_ARY := (
 "000", "001", "101", "111", "011", "010", "110", "100",
 "000", "100", "110", "010", "011", "111", "101", "001",
 "000", "010", "000", "001", "011", "001", "101", "100",
 "101", "001", "000", "100", "110", "010", "000", "010",
 "110", "100", "101", "100", "000", "001", "101", "111",
 "101", "111", "011", "010", "011", "010", "011", "010",
 "110", "111", "110", "111", "110", "111", "011", "001",
 "011", "111", "011", "010", "011",
 "001", "001", "000", "100",
 "101", "101", "100", "000",
 "001", "011", "010", "110",
 "111", "101", "100", "000",
 "001", "101", "100", "100",
 "101", "001", "000", "010",
 "011", "011", "010", "000",
 "001", "011", "010", "110",
 "111", "111", "110", "110",
 "111", "111", "110", "110",
 "111", "101", "100", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 "001", "001", "000", "000",
 others => "000"

);

begin

TCOMP: JK_Flip_Flop
  port map (
    J_H   => X_J_H,
    K_H   => X_K_H,
    CLK_H => X_CLK_H,
    Q_H   => X_Q_H
  );

process
begin
  X_J_H   <= IN_VALS(COUNT)(2);
  X_K_H   <= IN_VALS(COUNT)(1);
  X_CLK_H <= IN_VALS(COUNT)(0);
  COUNT <= COUNT + 1;
  wait for 15 ns;
end process;

WRITE_OUT_PROC:
  process ( X_J_H, X_K_H, X_CLK_H, X_Q_H ) is
  file OUT_FILE : TEXT open WRITE_MODE is "asynsysvals.txt";
  variable BUF : LINE;
  variable T0 : TIME;
  constant SPA : STRING := " ";
  constant HEADER : STRING := "J K C Q   Time";
  variable COUNT : INTEGER := 0;
  variable FIRST_TIME : BOOLEAN := TRUE;
  begin
    if COUNT mod 40 = 0 then
      if FIRST_TIME = FALSE then
        write ( BUF, SPA );
        writeline ( OUT_FILE, BUF );
      end if;
      write ( BUF, HEADER );
      writeline ( OUT_FILE, BUF );
      write ( BUF, SPA );
      writeline ( OUT_FILE, BUF );
      FIRST_TIME := FALSE;
    end if;
    COUNT := COUNT + 1;
    T0 := NOW;
    write ( BUF, X_J_H );
    write ( BUF, SPA );
    write ( BUF, X_K_H );
    write ( BUF, SPA );
    write ( BUF, X_CLK_H );
    write ( BUF, SPA );
    write ( BUF, X_Q_H );
    write ( BUF, SPA );
    write ( BUF, SPA );
    write ( BUF, T0 );
    writeline ( OUT_FILE, BUF );
  end process;

end architecture ASYN_TB;
