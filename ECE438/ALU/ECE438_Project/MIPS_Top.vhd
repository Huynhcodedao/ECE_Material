library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MIPS_Top is
port(
  clock : in std_logic;
  reset : in std_logic
  --PCsrc : in std_logic
);

end entity MIPS_Top;

architecture MIPS_Top of MIPS_Top is

--****************Instruction_Memory_Block************************************************************
--Instruction_Memory_Block_Signals
signal Instruction_Address_PC : std_logic_vector(31 downto 0);
signal Instruction_Data : std_logic_vector(31 downto 0);
signal PC_Mux : std_logic_vector(31 downto 0);
signal Program_Counter : std_logic_vector(31 downto 0);
signal PCsrc : std_logic;

--Instruction_Fetch_Decode_Registers
signal Program_Counter_reg : std_logic_vector(31 downto 0);  
signal Instruction_Data_reg : std_logic_vector(31 downto 0); 

--***************Register_Block***************************************************************
--Register_Block_Signals
signal Write_Back : std_logic;
signal Memory_Read : std_logic;
signal Memory_Write : std_logic;
signal Execute : std_logic; 
signal Read_Register_1 : std_logic_vector(4 downto 0);
signal Reg_Value_1 : std_logic_vector(31 downto 0);
signal Read_Register_2 : std_logic_vector(4 downto 0);
signal Reg_Value_2 : std_logic_vector(31 downto 0);
signal Write_Address : std_logic_vector(4 downto 0);
signal Write_Value : std_logic_vector(31 downto 0);
--signal Write_Enable : std_logic;
signal Sign_Extended : std_logic_vector(31 downto 0);
--signal Instruction_20_Downto_16 : std_logic_vector(4 downto 0);
--signal Instruction_15_Downto_11 : std_logic_vector(4 downto 0);
signal Opcode_Register_Block : std_logic_vector(5 downto 0);
signal Write_Address_Mux : std_logic_vector(4 downto 0);
signal Write_Enable_Mux : std_logic;
signal Write_Value_Mux : std_logic_vector(31 downto 0);
signal LUI_Value : std_logic_vector(31 downto 0);

--Instruction_Decode_Execute_Registers
signal Write_Back_reg : std_logic;
signal Memory_Read_reg : std_logic;
signal Memory_Write_reg : std_logic;
signal Execute_reg : std_logic;
signal Program_Counter_2_reg : std_logic_vector(31 downto 0);
signal Read_Data_1_reg : std_logic_vector(31 downto 0);
signal Read_Data_2_reg : std_logic_vector(31 downto 0);
signal Sign_Extended_reg : std_logic_vector(31 downto 0);
signal RS_Instruction_25_Downto_21_reg : std_logic_vector(4 downto 0);
signal RT_Instruction_20_Downto_16_reg : std_logic_vector(4 downto 0);
signal RD_Instruction_15_Downto_11_reg : std_logic_vector(4 downto 0);
signal LUI_Value_reg : std_logic_vector(31 downto 0);
signal Opcode_ALU_Block_reg : std_logic_vector(5 downto 0);
 
--***************ALU_Block***************************************************************
--ALU_Block_Signals
signal ALU_Control : std_logic_vector(3 downto 0);
--signal ALU_Input_1 : std_logic_vector(31 downto 0);
signal ALU_Input_1 : std_logic_vector(31 downto 0);
signal ALU_Input_2 : std_logic_vector(31 downto 0);
signal ALU_Zero : std_logic;
signal ALU_Result : std_logic_vector(31 downto 0); 
--signal Reg_Dest : std_logic;
signal Instruction_Mux : std_logic_vector(4 downto 0);
signal Shift_Value : std_logic_vector(31 downto 0);
signal ALU_Addition : std_logic_vector(31 downto 0);
signal Use_ALU_Result : std_logic;
--signal ALU_Src : std_logic;

--Execute_Memory_Registers
signal Write_Back_2_reg : std_logic;
signal Memory_Read_2_reg : std_logic;
signal Memory_Write_2_reg :std_logic;
signal ALU_Addition_reg : std_logic_vector(31 downto 0);
signal ALU_Zero_reg : std_logic;
signal ALU_Result_reg : std_logic_vector(31 downto 0);
signal Read_Data_2_2_reg : std_logic_vector(31 downto 0);
signal Intruction_Mux_reg : std_logic_vector(4 downto 0); 
signal Opcode_Data_Memory_Block_reg : std_logic_vector(5 downto 0);

--***************Data_Memory_Block*************************************************************
--Data_Memory_Block_Signals
--signal Data_Address : STD_LOGIC_VECTOR (31 downto 0);
signal Data_Out : STD_LOGIC_VECTOR (31 downto 0);
signal Data_In : STD_LOGIC_VECTOR (31 downto 0);
--signal Memory_2_read_reg : std_logic;
--signal Memory_Read : STD_LOGIC;
--signal Memory_Write : STD_LOGIC;

--Memory_WriteBack_Registers
signal WB_MemtoReg_reg : std_logic;
signal Read_Data_reg : std_logic_vector(31 downto 0);
signal Address_Bypass_reg : std_logic_vector(31 downto 0);
signal Intruction_Mux_Mem_reg : std_logic_vector(4 downto 0); 
signal Opcode_Data_Write_Back_Block_reg : std_logic_vector(5 downto 0);


begin


--*******************Instruction_Memory_Block******************************

Instruction_Memory : entity work.I_MEMORY
  port map(
    I_ADDR => PC_Mux,                 --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    I_DATA => Instruction_Data,       --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    CLK => Clock                      --: in  STD_LOGIC
    );
    
--Mux_2_to_1
PC_Mux <= Program_Counter when PCsrc = '0' else
          ALU_Addition_reg when PCsrc = '1';

Program_Counter_Addition : process(clock, reset)
begin
  if reset = '1' then
    Program_Counter <= (others => '0');
  elsif rising_edge(clock) then
    Program_Counter <= Program_Counter + 4;
  end if;
end process;

Registers_Instruction_Fetch_Decode : process(clock, reset)
begin
  if reset = '1' then
    Program_Counter_reg <= (others => '0');
    Instruction_Data_reg <= (others => '0');
  elsif rising_edge(clock) then
    Program_Counter_reg <= Program_Counter; 
    Instruction_Data_reg <= Instruction_Data;
 end if;  
end process;

--***********************Register_Block*********************************************************************
Registers : entity work.REGISTERS
  port map(
    READ1 => Instruction_Data_reg(25 downto 21),    --: in  STD_LOGIC_VECTOR ( 4 downto 0 );
    R_VAL1 => Reg_Value_1,                          --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    READ2 => Instruction_Data_reg(20 downto 16),    --: in  STD_LOGIC_VECTOR ( 4 downto 0 );
    R_VAL2 => Reg_Value_2,                          --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    WADDR => Intruction_Mux_Mem_reg, --Write_Address_Mux,         --: in  STD_LOGIC_VECTOR ( 4 downto 0 );
    W_VAL => Write_Value,  --Write_Value_Mux,                          --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    WRIT_EN => WB_MemtoReg_reg, --Write_Enable_Mux,                     --: in  STD_LOGIC;
    CLK => Clock                                    --: in  STD_LOGIC
  );

--Opcode available for register block 
Opcode_Register_Block <= Instruction_Data_reg(31 downto 26); 
 
--Write_Address_Mux
--Write_Address_Mux <= Instruction_Data_reg(20 downto 16) when Opcode_Register_Block = "001111" else 
--                     Instruction_Data_reg(20 downto 16) when Opcode_Register_Block = "001101" else 
 --                    Intruction_Mux_Mem_reg; 
 
--Write_Value_Mux
--Write_Value_Mux <= ALU_Result when Write_Back_reg = '1' else 
--                   Instruction_Data_reg(15 downto 0) & X"0000" when Opcode_Register_Block = "001111" else
--                   Write_Value;  
  
--Write_Enable_Mux
--Write_Enable_Mux <= '1' when Opcode_Register_Block = "001111" else
                    --WB_MemtoReg_reg;

LUI_Value <= Instruction_Data_reg(15 downto 0) & X"0000";

--Control_Bubble
Write_Back <= '0' when reset = '1' else
              '1' when Opcode_Register_Block = "001111" else
              '1' when Opcode_Register_Block = "001101";--else
              --'0' when Opcode_Register_Block = "100011";
              
Memory_Read <= '0' when reset = '1' else
               '0' when Opcode_Register_Block = "001111" else
               '0' when Opcode_Register_Block = "001101" else
               '1' when Opcode_Register_Block = "100011" else
               '0' when Opcode_Register_Block = "101011"; 
               
Memory_Write <= '0' when reset = '1' else
                '0' when Opcode_Register_Block = "001111" else
                '0' when Opcode_Register_Block = "001101" else
                '1' when Opcode_Register_Block = "101011";  
                
Execute <= '0' when reset = '1' else
           '0' when Opcode_Register_Block = "001111" else
           '0' when Opcode_Register_Block = "001101";                                            

--Sign_Extend
Sign_Extended <= X"00000000" when reset = '1' else
                 X"0000" & Instruction_Data_reg(15 downto 0) when Instruction_Data_reg(15) = '0' else
                 X"1111" & Instruction_Data_reg(15 downto 0) when Instruction_Data_reg(15) = '1'; 

Registers_Instruction_Decode_Execute : process(clock, reset)
begin
  if reset = '1' then
    Write_Back_reg <= '0';
    Memory_Read_reg <= '0';
    Memory_Write_reg <= '0';
    Execute_reg <= '0';
    Program_Counter_2_reg <= (others => '0');
    Read_Data_1_reg <= (others => '0');
    Read_Data_2_reg <= (others => '0');
    Sign_Extended_reg <= (others => '0');
    RS_Instruction_25_Downto_21_reg <= (others => '0');
    RT_Instruction_20_Downto_16_reg <= (others => '0');
    RD_Instruction_15_Downto_11_reg <= (others => '0');
    Opcode_ALU_Block_reg <= (others => '0');
    LUI_Value_reg <= (others => '0');
  elsif rising_edge(clock) then
    Write_Back_reg <= Write_Back;
    Memory_Read_reg <= Memory_Read;
    Memory_Write_reg <= Memory_Write;
    Execute_reg <= Execute;
    Program_Counter_2_reg <= Program_Counter_reg;
    Read_Data_1_reg <= Reg_Value_1; 
    Read_Data_2_reg <= Reg_Value_2;
    Sign_Extended_reg <= Sign_Extended;
    RS_Instruction_25_Downto_21_reg <= Instruction_Data_reg(25 downto 21);
    RT_Instruction_20_Downto_16_reg <= Instruction_Data_reg(20 downto 16);
    RD_Instruction_15_Downto_11_reg <= Instruction_Data_reg(15 downto 11);
    LUI_Value_reg <= LUI_Value;
    Opcode_ALU_Block_reg <= Opcode_Register_Block;
  end if;  
end process;

--************************ALU_Block*******************************************************
ALU_Unit : entity work.ALU32
  port map(
    reset => reset,           --: in std_logic;
    ALU_CON => ALU_Control,   --: in std_logic_vector(3 downto 0);
    A_VAL => ALU_Input_1, --Read_Data_1_reg,     --: in std_logic_vector(31 downto 0);
    B_VAL => ALU_Input_2,     --: in std_logic_vector(31 downto 0);
    F_VAL => ALU_Result,      --: out std_logic_vector(31 downto 0);
    ZERO => ALU_Zero,
    O_FLO => open             --: out std_logic
    );

--ALU_Control_Bubble
ALU_Control <= "0001" when Opcode_ALU_Block_reg = "001101" else
               "0010" when Opcode_ALU_Block_reg = "000000" else
               "0011" when Opcode_ALU_Block_reg = "001111";
               

ALU_Input_1 <= ALU_Result_reg when RS_Instruction_25_Downto_21_reg = Instruction_Mux else--Use_ALU_Result = '1' else
               Reg_Value_1; 

--Mux_2_to_1_ALU_Read_Data_Sign_Extended
ALU_Input_2 <= LUI_Value_reg when Opcode_ALU_Block_reg = "001111" else
               X"0000" & Sign_Extended_reg(15 downto 0) when Opcode_ALU_Block_reg = "001101" else
               X"0000" & Sign_Extended_reg(15 downto 0) when Opcode_ALU_Block_reg = "001000" else
               Reg_Value_2;

--Mux_2_to_1_ALU_rt_rd
Instruction_Mux <= RD_Instruction_15_Downto_11_reg when Opcode_ALU_Block_reg = "000000" else
                   RT_Instruction_20_Downto_16_reg when Execute_reg = '0';-- else --was RegDest
                  
                   

Shift_Left_2 : process (clock, reset)
begin
  if reset = '1' then
    Shift_Value <= (others => '0');
  elsif rising_edge(clock) then
    Shift_Value <= Sign_Extended_reg(29 downto 0) & "00";   
  end if;
end process;  
 
ALU_Adder : process(clock, reset)
begin
  if reset = '1' then
    ALU_Addition <= (others => '0');
  elsif rising_edge(clock) then
    ALU_Addition <= Program_Counter_2_reg + Shift_Value;
  end if;
end process;  
    
Registers_Execute_Memory : process(clock, reset)
begin
  if reset = '1' then
    Write_Back_2_reg <= '0';
    Memory_Read_2_reg <= '0';
    Memory_Write_2_reg <= '0';
    ALU_Addition_reg <= (others => '0');
    ALU_Zero_reg <= '0';
    ALU_Result_reg <= (others => '0');
    Read_Data_2_2_reg <= (others => '0');
    Intruction_Mux_reg <= (others => '0');
    Opcode_Data_Memory_Block_reg <= (others => '0');
  elsif rising_edge(clock) then
    Write_Back_2_reg <= Write_Back_reg;
    Memory_Read_2_reg <= Memory_Read_reg;
    Memory_Write_2_reg <= Memory_Write_reg;
    ALU_Addition_reg <= ALU_Addition; 
    ALU_Zero_reg <= ALU_Zero;
    ALU_Result_reg <= ALU_Result;
    Read_Data_2_2_reg <= Read_Data_2_reg;
    Intruction_Mux_reg <= Instruction_Mux;
    Opcode_Data_Memory_Block_reg <= Opcode_ALU_Block_reg;
 end if;  
end process;    

--************************Data_Memory_Block***********************************************************
Data_Memory : entity work.D_MEMORY
  port map(
    D_ADDR => ALU_Result_reg,           --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    D_OUT_DATA => Data_Out,           --: out STD_LOGIC_VECTOR ( 31 downto 0 );
    D_IN_DATA => Data_In,             --: in  STD_LOGIC_VECTOR ( 31 downto 0 );
    MEM_READ => Memory_Read_2_reg,          --: in  STD_LOGIC;
    MEM_WRITE => Memory_Write_2_reg,        --: in  STD_LOGIC;
    CLK => Clock                      --: in  STD_LOGIC
  );
   
--Branch "AND"
PCsrc <= '0'; --when reset = '1' else
          --ALU_Zero_reg AND Memory_2_reg;
   
Registers_Memory_Write_Back : process(clock, reset)
begin
  if reset = '1' then
    WB_MemtoReg_reg <= '0';
    Read_Data_reg <= (others => '0');
    Address_Bypass_reg <= (others => '0');
    Intruction_Mux_Mem_reg <= (others => '0');
    Opcode_Data_Write_Back_Block_reg <= (others => '0');
  elsif rising_edge(clock) then
    WB_MemtoReg_reg <= Write_Back_2_reg;
    Read_Data_reg <= Data_Out;
    Address_Bypass_reg <= ALU_Result_reg;
    Intruction_Mux_Mem_reg <= Intruction_Mux_reg;
    Opcode_Data_Write_Back_Block_reg <= Opcode_Data_Memory_Block_reg;
 end if;  
end process; 

--************************Write_Back_Block******************************************************
--Mux_2_to_1_WB 
Write_Value <= Read_Data_reg when Opcode_Data_Write_Back_Block_reg = "100011" else
               Address_Bypass_reg when WB_MemtoReg_reg = '1'; 

end MIPS_Top;