library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;


entity ATB_FP_ADDER is
end entity ATB_FP_ADDER;

architecture ATB_FP_ADDER of ATB_FP_ADDER is

component FP_ADDER is
  port (
    A_VAL : in STD_LOGIC_VECTOR (31 downto 0 );
    B_VAL : in STD_LOGIC_VECTOR (31 downto 0 );
    F_VAL : out STD_LOGIC_VECTOR (31 downto 0 )
  );
end component FP_ADDER;

signal X_A_VAL : STD_LOGIC_VECTOR ( 31 downto 0 );
signal X_B_VAL : STD_LOGIC_VECTOR ( 31 downto 0 );
signal X_F_VAL : STD_LOGIC_VECTOR ( 31 downto 0 );

type DATA_ARRAY_TYPE is array ( 0 to 15 ) of STD_LOGIC_VECTOR ( 31 downto 0 );
constant DATA_ARRAY : DATA_ARRAY_TYPE := (
  X"3F800000", X"40000000", X"40800000", X"41000000",
  X"41800000", X"42000000", X"41200000", X"42800000",
  X"42C80000", X"447A0000", X"461C4000", X"461C4400",
  X"42C8051E", X"3F000000", X"3F0F5C28", X"4231C28F"
);
begin

UUT: FP_ADDER
  port map (
    A_VAL => X_A_VAL,
    B_VAL => X_B_VAL,
    F_VAL => X_F_VAL
  );
  
process
  file OUT_FILE: TEXT open WRITE_MODE is "FPADDvals.txt";
  variable BUF : LINE;
  constant STR : STRING ( 1 to 3 ) := "   ";
  constant HDR : STRING ( 1 to 42 ) := 
  "  A_VAL      B_VAL     Result        Time ";
  variable TM : TIME;
  variable FLAG : BOOLEAN := TRUE;
  variable I, J : INTEGER;
begin
  I := 0;
  J := 0;
  while TRUE loop
    X_A_VAL <= DATA_ARRAY(I);
    X_B_VAL <= DATA_ARRAY(J);
    wait for 25 ns;
    if FLAG then
      WRITE ( BUF, HDR );
      WRITELINE ( OUT_FILE, BUF );
      FLAG := FALSE;
    end if;
    HWRITE ( BUF, X_A_VAL );
    WRITE  ( BUF, STR );
    HWRITE ( BUF, X_B_VAL );
    WRITE  ( BUF, STR );
    HWRITE ( BUF, X_F_VAL );
    WRITE  ( BUF, STR );
    TM := 25 ns - X_F_VAL'LAST_EVENT;
    WRITE  ( BUF, TM, RIGHT, 6 );
    WRITELINE ( OUT_FILE, BUF );

    I := (I + 3) mod 16;
    J := (J + 4) mod 16;
  end loop;
end process;


end architecture ATB_FP_ADDER;
