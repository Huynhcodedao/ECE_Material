library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

entity IEEE_32_Bit_Floating_Point_Adder is
port(
	A_Val : in std_logic_vector(31 downto 0);
	B_Val : in std_logic_vector(31 downto 0);
	F_Val : out std_logic_vector(31 downto 0)
	);
end entity;	

architecture IEEE_32_Bit_Floating_Point_Adder of IEEE_32_Bit_Floating_Point_Adder is

signal A_Val_S : std_logic := '0';
signal B_Val_S : std_logic := '0';
signal A_Val_Exp : std_logic_vector(7 downto 0) := (others => '0');
signal B_Val_Exp : std_logic_vector(7 downto 0) := (others => '0');
signal A_Val_Mant : std_logic_vector(27 downto 0) := (others => '0');
signal B_Val_Mant : std_logic_vector(27 downto 0) := (others => '0');

signal AGTB : std_logic := '0';
signal ALTB : std_logic := '0';
signal AETB : std_logic := '0';
signal Subtract_Value : std_logic_vector(4 downto 0) := (others => '0');
signal Mant_Out : std_logic_vector(27 downto 0) := (others => '0');
signal Mant_Out_Big : std_logic_vector(27 downto 0) := (others => '0');
signal Shift_Output_Small : std_logic_vector(27 downto 0) := (others => '0');
signal Sum : std_logic_vector(27 downto 0) := (others => '0');
signal C_Out : std_logic := '0';

signal Post_Norm_S_Value : std_logic := '0';
signal Post_Norm_Exponent : std_logic_vector(7 downto 0) := (others => '0'); 
signal Post_Norm_Exponent_i : std_logic_vector(7 downto 0) := (others => '0'); 
signal Post_Norm_Value : std_logic_vector(27 downto 0) := (others => '0');
signal Exponent_Increment : std_logic := '0';

begin

A_Val_S <= A_Val(31);
B_Val_S <= B_Val(31);

A_Val_Exp <= A_Val(30 downto 23);
B_Val_Exp <= B_Val(30 downto 23);

A_Val_Mant <= "00000" & A_Val(22 downto 0);
B_Val_Mant <= "00000" & B_Val(22 downto 0);

Post_Norm_Exponent_i <= A_Val_Exp after 2 ns when AGTB = '1' else B_Val_Exp after 2 ns;
Post_Norm_Exponent <= Post_Norm_Exponent_i after 2 ns when Exponent_Increment = '0' else
                      Post_Norm_Exponent_i + 1 after 2 ns;
                      
Post_Norm_S_Value <=  A_Val_S when (AGTB = '1' or (AETB = '1' and A_Val_Mant > B_Val_Mant)) else B_Val_S after 2 ns;                      

Exponent_Compare_Unit : entity work.Exponent_Compare
port map (
  A_Val_Exp => A_Val_Exp,     --: in  std_logic_vector(7 downto 0);
  B_Val_Exp => B_Val_Exp,     --: in  std_logic_vector(7 downto 0);
  AGTB => AGTB,         --: out std_logic;
  ALTB => ALTB,        --: out std_logic;
  AETB => AETB         --: out std_logic
);

Exponent_Subtract_Unit : entity work.Exponent_Subtract
port map (
  A_Val_Exp => A_Val_Exp,    
  B_Val_Exp => B_Val_Exp,     
  AGTB => AGTB,        
  ALTB => ALTB,       
  AETB => AETB,        
  Subtract_Value => Subtract_Value    --: out std_logic_vector(4 downto 0)
);

Mant_2_To_1_Mux_Align_Unit : entity work.Mant_2_To_1_Mux_Align
port map (
  A_Val_Mant => A_Val_Mant,      --: in std_logic_vector(27 downto 0);
  B_Val_Mant => B_Val_Mant,      --: in std_logic_vector(27 downto 0);
  AGTB => AGTB,      --: in std_logic;
  ALTB => ALTB,      --: in std_logic;
  AETB => AETB,      --: in std_logic;
  Mant_Out => Mant_Out    --: out std_logic_vector(27 downto 0) 
);

Mant_2_To_1_Mux_Unit : entity work.Mant_2_To_1_Mux
port map (
  A_Val_Mant => A_Val_Mant,      --: in std_logic_vector(27 downto 0);
  B_Val_Mant => B_Val_Mant,      --: in std_logic_vector(27 downto 0);
  AGTB => AGTB,      --: in std_logic;
  ALTB => ALTB,      --: in std_logic;
  AETB => AETB,      --: in std_logic;
  Mant_Out => Mant_Out_Big    --: out std_logic_vector(27 downto 0) 
);

Shift_Unit : entity work.Shift
port map (
  Input_Val => Mant_Out(23 downto 0),       --: in  std_logic_vector(23 downto 0);
  Shift_Amt => Subtract_Value,       --: in std_logic_vector(4 downto 0);
  Output_Val => Shift_Output_Small       --: out std_logic_vector(27 downto 0)
);

LA_32_Bit_Adder_Unit : entity work.LA_32_Bit_Adder
port map (
  a => Shift_Output_Small, --: IN STD_LOGIC_VECTOR(27 downto 0);
  b => Mant_Out_Big, --: IN STD_LOGIC_VECTOR(27 downto 0);
  C_IN => '0', --: IN STD_LOGIC;
  SUM => Sum,     --: OUT STD_LOGIC_VECTOR(27 downto 0);
  C_OUT => C_OUT    --: OUT STD_LOGIC
);

Exponent_Increment <= '1' after 2 ns when sum(24) = '1' else '0' after 2 ns; 

Post_Norm_Unit : entity work.Post_Norm
port map (
  AddSubOut => Sum,         --: in std_logic_vector(27 downto 0);
  Post_N_Val => Post_Norm_Value       --out std_logic_vector(27 downto 0)
);

F_Val <= Post_Norm_S_Value & Post_Norm_Exponent & Post_Norm_Value(26 downto 4) after 2 ns;

end IEEE_32_Bit_Floating_Point_Adder;  