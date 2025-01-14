library ieee;                                       --Libraries used in file
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity CORDIC is
  port(
    SYS_CLK_H : in std_logic;                       --System Clock
    SYS_RST_H : in std_logic;                       --System Reset
    D_BUS : inout std_logic_vector(31 downto 0);    --Data Bus  
    A_BUS : in std_logic_vector(31 downto 0);       --Address Bus
    READ_H : in std_logic;                          --Read/Write Line Read = '1', Write = '0'
    REQ_H : in std_logic;                           --Request line controlled by Master  
    ACK_H : out std_logic                           --Acknowledge controlled by Slave
    );
  end entity;
  
architecture CORDIC of CORDIC is

type State_Type is (Reset_State, Idle, S2, S4, S5, S6, S7, S8);               --State used within CORDIC system

signal Current_State : State_Type;                                            --Current_State used to define PSR         
signal shift_count : integer := 0;                                            --Counts iterations up to 36 for work states
signal zeros : std_logic_vector(35 downto 0) := (others => '0');              --Register full of zeros used to shift the shift register 

signal X_Value_Shift : std_logic_vector(35 downto 0):= (others => '0');       --Shifted Y Value basically: (Yi x 2^-1)
signal Y_Value_Shift : std_logic_vector(35 downto 0):= (others => '0');       --Shifted X Value basically: (Xi x 2^-1)

signal Z_Value : std_logic_vector(35 downto 0) := X"000000000";               --Z Value Register intialized to 0
signal Y_Value : std_logic_vector(35 downto 0) := X"000000000";               --Y Value Register intialized to 0 
signal X_Value : std_logic_vector(35 downto 0) := X"04DBA5E35";               --X Value register intialized to 0.60725

type arctan_array_type is array(0 to 35) of std_logic_vector(35 downto 0);    --Arctan array hardcoded to represent 36 values of (arctan(2^-i))
constant arctan_array: Arctan_array_type := (x"6487ED511", x"3B58CE0AC", x"1F5B75F92", 
            x"0FEADD4D5", x"07FD56EDC", x"03FFAAB77", x"01FFF555B", x"00FFFEAAA", x"007FFFD55", 
            x"003FFFFAA", x"001FFFFF5", x"000FFFFFE", x"0007FFFFF", x"0003FFFFF", x"0001FFFFF", 
            x"0000FFFFF", x"00007FFFF", x"00003FFFF", x"00001FFFF", x"00000FFFF", x"000007FFF", 
            x"000003FFF", x"000001FFF", x"000000FFF", x"0000007FF", x"0000003FF", x"0000001FF", 
            x"000000100", x"000000080", x"000000040", x"000000020", x"000000010", x"000000008", 
            x"000000004", x"000000002", x"000000001");

begin
  
Current_State_Control : process (SYS_CLK_H, SYS_RST_H)  --Process SM used to control PSR and work  
begin
if (SYS_RST_H = '1') then                               --System reset parameters    
  D_BUS <= (others => 'Z');
  ACK_H <= 'Z';
  Current_State <= Idle;

elsif RISING_EDGE(SYS_CLK_H) then                       --SM functions on rising edge of clock
  case Current_State is
    when Reset_state =>                                 --Reset State reintializes all signals between reading and writing functions   
      D_BUS <= (others => 'Z');
      ACK_H <= 'Z';
      Current_State <= Idle;
      Shift_Count <= 0;
      X_Value_Shift <= X"04DBA5E35";
      Y_Value_Shift <= X"000000000";

            
  when Idle =>                                          --Sits and waits for Request to go high else stays in idle
    if REQ_H = '0' then
      current_state <= idle;
    elsif REQ_H = '1' and READ_H = '0' and A_BUS = X"FFFF_1040" then    --If request = '1' and write mode on 
      current_state <= S6;                                              --Check for Z Address  
      Z_Value <= D_Bus & "0000";                                        --If address valid load Z register with intial Z alue from bus
      X_Value <= X"04DBA5E35";                                          --Reintialize X and Y values for work to come  
      Y_Value <= X"000000000"; 
    else 
      current_state <= S4;                              --If Request = '1' and read mode goto State 4   
    end if;  
             
  when S4 => 
    ACK_H <= '1';
    if REQ_H = '1' then
      if A_BUS = X"FFFF_1040" then
        D_BUS <= Z_Value(35 downto 4);
        current_state <= S2;
      elsif A_BUS = X"FFFF_1044" then 
        D_BUS <= X_Value(35 downto 4);
        current_state <= S2;
      elsif A_BUS = X"FFFF_1048" then 
        D_BUS <= Y_Value(35 downto 4);
        current_state <= S2;    
      else  
        current_state <= idle;
      end if;
    else      
      current_state <= S5;
    end if;  
  
  when S6 =>
    if shift_count <= 35 then  
      if Z_Value(35) = '0' then
        Z_Value <= Z_Value - arctan_array(shift_count);
        X_Value <= X_Value - Y_Value_Shift; 
        Y_Value <= Y_Value + X_Value_Shift;   
      else
        Z_Value <= Z_Value + arctan_array(shift_count);
        X_Value <= X_Value + Y_Value_Shift; 
        Y_Value <= Y_Value - X_Value_Shift; 
      end if; 
      current_state <= S7;
      shift_count <= shift_count + 1; 
    else
      current_state <= S4; --was S4
      --ACK_H <= '1';       
    end if; 
  
  when S7 =>
    if shift_count = 1 then
      Y_Value_shift <= '0' & Y_Value(35 downto 1);
      X_Value_shift <= '0' & X_Value(35 downto 1);   
    else
      Y_Value_shift <= zeros(shift_count - 1 downto 0) & Y_Value(35 downto shift_count);
      X_Value_shift <= zeros(shift_count - 1 downto 0) & X_Value(35 downto shift_count);
    end if;  
    current_state <= S6;
    
  when S2 =>
    ACK_H <= '0';
    if REQ_H = '1' then
      current_state <= S2;
    else
      current_state <= S5;
    end if;  
    
  when S5 =>
    ACK_H <= '0';
    current_state <= S8;  
   
  when S8 =>
    current_state <= reset_state;       
    
end case;
end if;
end process;





end architecture; 
    