library IEEE;                                -- make IEEE library visible
use IEEE.STD_LOGIC_1164.all;                 -- open up 1164 package
use IEEE.STD_LOGIC_UNSIGNED.all;             -- open up UNSIGNED package
use IEEE.STD_LOGIC_TEXTIO.all;               -- open up TEXTIO package
use STD.TEXTIO.all;                          -- open up standard TEXTIO package

entity ATB_CORDIC is                         -- empty entity since test bench
end entity ATB_CORDIC;                       -- end of empty entity

architecture ATB_CORDIC of ATB_CORDIC is      -- start of arc - declar area

                                             -- component stmt is entity stmt from design unit
component CORDIC is                          -- start of ENTITY
  port (                                     -- port definition
    SYS_CLK_H  : in  STD_LOGIC;              -- system clock
    SYS_RST_H  : in  STD_LOGIC;              -- system reset
    D_BUS      : inout STD_LOGIC_VECTOR ( 31 downto 0 ); -- the data bus
    A_BUS      : in  STD_LOGIC_VECTOR ( 31 downto 0 ); -- the address bus
    READ_H     : in  STD_LOGIC;              -- READ line
    REQ_H      : in  STD_LOGIC;              -- REQUEST line
    ACK_H      : out STD_LOGIC               -- ACKnowledge line
  );                                         -- end of port
end component CORDIC;                        -- end of ENTITY

signal XX_CLK    : STD_LOGIC;                -- system clock
signal XX_RST    : STD_LOGIC;                -- system reset
signal XX_READ_H : STD_LOGIC;                -- the read line
signal XX_REQ_H  : STD_LOGIC;                -- the request line
signal XX_ACK_H  : STD_LOGIC;                -- the acknowledge line
signal XX_DBUS   : STD_LOGIC_VECTOR ( 31 downto 0 );
signal XX_ABUS   : STD_LOGIC_VECTOR ( 31 downto 0 );
signal XX_VAL    : STD_LOGIC_VECTOR ( 31 downto 0 ); -- X value output
signal YY_VAL    : STD_LOGIC_VECTOR ( 31 downto 0 ); -- Y value output
signal ZZ_VAL    : STD_LOGIC_VECTOR ( 31 downto 0 ); -- Z value
signal Z_END     : STD_LOGIC_VECTOR ( 31 downto 0 ); -- Z value

type STATES is ( IDLE, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9 );
                                             -- declaration for states for state machine
signal PSR : STATES;                         -- instantiate present state register
signal CNTR : INTEGER := 0;                  -- this counter has no real function, for info only
signal CYCLE : INTEGER := 1;                 -- count cycles from beginning

begin                                        -- begin of the hardware description

UUT: CORDIC                                  -- instantiate the component
  port map (                                 -- begin mapping of signals
    SYS_CLK_H  => XX_CLK,                     -- system clock
    SYS_RST_H  => XX_RST,                     -- system reset
    D_BUS      => XX_DBUS,                    -- ye ole data bus
    A_BUS      => XX_ABUS,                    -- ye ole address bus
    READ_H     => XX_READ_H,                  -- READ line
    REQ_H      => XX_REQ_H,                   -- REQUEST line
    ACK_H      => XX_ACK_H                    -- ACKnowledge line
  );

CLOCK_PROC:                                  -- the clock process (100 MHz)....
  process                                    -- no sensitivity list....
  begin                                      -- start of the process
    XX_CLK <= '1';                           -- okay, start with clock high
    wait for 5 ns;                           -- wait 5 ns
    XX_CLK <= '0';                           -- then take clock low 
    wait for 5 ns;                           -- wait for another 5 ns
    CYCLE <= CYCLE + 1;                      -- increment the cycle counter
  end process;                               -- and do it all over....

  XX_RST <= '1' when CYCLE < 5 else '0';     -- the reset statement (not synthesizable)

-- The following process implements the test bench state machine.
-- basic idea here is to handle handshake signals from module and
-- respond appropriately....

STATE_MACHINE_PROC:
  process ( XX_CLK, XX_RST ) is              -- sensitivity: clock and reset
  begin
    if XX_RST = '1' then                     -- if reset is asserted,
      PSR <= IDLE;                           -- force testbench to state IDLE
    elsif RISING_EDGE ( XX_CLK ) then        -- otherwise, on clock edge
      case PSR is                            -- based on the contents of PSR, do....
        when IDLE =>                         -- from state IDLE,
          PSR <= S0;                         -- go to state S0

        when S0 =>                           -- from State S0, always
          PSR <= S1;                         -- go to S1

        when S1 =>                           -- when in state S1,
          if XX_ACK_H = '1' then             -- if ACK_H is asserted,
            PSR <= S2;                       -- go to state S2
          else                               -- otherwise,
            PSR <= S1;                       -- go to state S0
          end if;

        when S2 =>                           -- when in state S2,
          PSR <= S3;                         -- always go to state S3

        when S3 =>                           -- when in state S3,
          if XX_ACK_H = '1' then             -- if ACK_H is asserted,
            PSR <= S4;                       -- go to state S4
          else                               -- otherwise,
            PSR <= S3;                       -- go to state S3
          end if;

        when S4 =>                           -- when in state S4,
          PSR <= S5;                         -- always go to state S5

        when S5 =>                           -- when in state S5,
          if XX_ACK_H = '1' then             -- if ACK_H is asserted,
            PSR <= S6;                       -- go to state S6
          else                               -- otherwise,
            PSR <= S5;                       -- stay in state S5
          end if;

        when S6 =>                           -- when in state S6,
          PSR <= S7;                         -- always go to state S7

        when S7 =>                           -- when in state S7,
          if XX_ACK_H = '1' then             -- if ACK_H is asserted,
            PSR <= S8;                       -- go to state S8
          else                               -- otherwise,
            PSR <= S7;                       -- stay in s7
          end if;

        when S8 =>                           -- when in state S8,
          PSR <= S9;                         -- always go to state S9

        when S9 =>                           -- when in state S9,
          PSR <= S0;                         -- always go to state S0

      end case;                              -- end of CASE construct
    end if;                                  -- end of edge check
  end process;                               -- end of PSR proc

  XX_REQ_H <= '1' when PSR = S1 or PSR = S3 or   -- REQ asserted 1,3,5,7
                       PSR = S5 or PSR = S7 else '0';

  XX_DBUS <= ZZ_VAL when PSR = S1 else ( others => 'Z'); -- data to slave in S1

  XX_ABUS <= X"FFFF_1040" when PSR = S1 else  -- write out a Z value
             X"FFFF_1040" when PSR = S3 else  -- read a Z value
             X"FFFF_1044" when PSR = S5 else  -- read a X value
             X"FFFF_1048" when PSR = S7 else  -- read a Y value
             (others => 'Z');                 -- otherwise get off bus

  XX_READ_H <= '0' when PSR = S1 else         -- write in S1
               '1' when PSR = S3 else         -- read in S3
               '1' when PSR = S5 else         -- read in S5
               '1' when PSR = S7 else 'Z';    -- read in S7

CNTR_PROC:                                   -- counter process
  process ( XX_RST, XX_CLK ) is              -- sensitivity: reset and clock
  begin                                      -- activity description
    if XX_RST = '1' then                     -- when reset asserted,
      CNTR <= 0;                             -- zero the counter
    elsif RISING_EDGE ( XX_CLK ) then        -- otherwise, on clock edge
      if PSR = S9 then                       -- if state machine is in state S9
        CNTR <= CNTR + 1;                    -- increment the count
      end if;                                -- end of state check
    end if;                                  -- end of edge check
  end process;                               -- end of process

REG_PROC:                                    -- a register process...
  process ( XX_RST, XX_CLK ) is              -- sensitivity: reset, clock
  begin
    if XX_RST = '1' then                     -- on reset,
      XX_VAL <= ( others => '0' );           -- zero the X register
      YY_VAL <= ( others => '0' );           -- zero the Y register
      Z_END <= ( others => '0' );            -- zero the Zend register
    elsif RISING_EDGE ( XX_CLK ) then        -- normally, look for edge...
      if PSR = S3 then                       -- S3 is for
        Z_END <= XX_DBUS;                    -- loading the Z value
      elsif PSR = S5 then                    -- S5 is for
        XX_VAL <= XX_DBUS;                   -- loading the X value
      elsif PSR = S7 then                    -- S7 is for
        YY_VAL <= XX_DBUS;                   -- loading the Y value
      end if;
    end if;
  end process;

INPUT_OUTPUT_PROC:                           -- process to handle file IO 
  process ( XX_CLK ) is                      -- sensitivity: clock
  file OUT_FILE : TEXT open WRITE_MODE is "CordicData.txt";  -- declare an output file
  file IN_FILE  : TEXT open READ_MODE  is "CordicInVals.txt"; -- declare an input file
  variable BUF : LINE;                       -- a buffer to do work in
  variable DATA_STR : STD_LOGIC_VECTOR ( 31 downto 0 ); -- data string variable
  constant SPA2 : STRING ( 1 to 2 ) := "  ";
  constant HEADER : STRING ( 1 to 34 ) := 
     "Num Input X_VAL Y_VAL Z_VAL  Time ";
  variable FLAG : BOOLEAN := TRUE;
  begin
    if RISING_EDGE ( XX_CLK ) then           -- on edge check...
      if PSR = S0 then                       -- when in state S0,
        if not ( ENDFILE ( IN_FILE )) then   -- if we're not at the end-of-file
          READLINE ( IN_FILE, BUF );         -- read line into BUF
          HREAD ( BUF, DATA_STR );           -- then, extract DATA_STR bits
        else                                 -- otherwise,
          DATA_STR := X"0000_0000";          -- just set DATA_STR to all zeros
        end if;                              -- end of peek at file
        ZZ_VAL <= DATA_STR;                  -- so set up Z value
      end if;                                -- end of state check
      if PSR = S9 then                       -- in state S9
        if FLAG then                         -- if FLAG set,
          FLAG := FALSE;                     -- clear the flag
          WRITE  ( BUF, HEADER );            -- and fill buffer with header
          WRITELINE ( OUT_FILE, BUF);        -- then writ it out.
        end if;                              -- end of flag check
        WRITE  ( BUF, CNTR, right, 3 );   WRITE  ( BUF, SPA2 ); -- buf <= count, space
        HWRITE ( BUF, ZZ_VAL ); WRITE  ( BUF, SPA2 ); -- and in val and space
        HWRITE ( BUF, XX_VAL ); WRITE  ( BUF, SPA2 ); -- and cosine and space
        HWRITE ( BUF, YY_VAL ); WRITE  ( BUF, SPA2 ); -- and sine and space
        HWRITE ( BUF, Z_END ); WRITE  ( BUF, SPA2 ); -- and in val and space
        WRITE  ( BUF, NOW );                 -- and time
        WRITELINE ( OUT_FILE, BUF);          -- then write whole thing out.
      end if;                                -- end of PSR check
    end if;                                  -- end of edge check
  end process;                               -- end of process

end architecture ATB_CORDIC;
