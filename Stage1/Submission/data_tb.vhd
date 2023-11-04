LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DATA_TB IS 

END ENTITY;

ARCHITECTURE BEV OF DATA_TB IS

SIGNAL datain : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
SIGNAL addr : STD_LOGIC_VECTOR(5 DOWNTO 0):="000000";
SIGNAL w_r : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
SIGNAL dataout : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CLK : STD_LOGIC := '0';


COMPONENT DATA IS
    PORT(
       DATAIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
       write : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       clk : in std_logic;
       DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
END COMPONENT;

BEGIN

  -- Connect DUT
  UUT: DATA PORT MAP( datain, addr, w_r, CLK, dataout );

  PROCESS
  BEGIN

    -- Write data into DM
    WAIT FOR 100 ns;
    addr<="100000";
    w_r<="0011";
    WAIT FOR 50 ns;
    datain<=x"01111111";
    WAIT FOR 50 ns;
        CLK<='1';
    WAIT FOR 100 ns;

    CLK<='0';
    WAIT FOR 100 ns;
    addr<="010000";
    w_r<="1101";
    datain<=x"10111111";
    WAIT FOR 100 ns;
    CLK<='1';
    WAIT FOR 50 ns;

    CLK<='0';
    WAIT FOR 100 ns;
    addr<="001000";
    w_r<="1100";
    datain<=x"10111111";
    WAIT FOR 100 ns;
    CLK<='1';
    WAIT FOR 100 ns;
    
    CLK<='0';
    WAIT FOR 50 ns;
    addr<="000100";
    w_r<="1001";
    datain<=x"10121111";
    WAIT FOR 100 ns;
    CLK<='1';
    WAIT FOR 100 ns;

    CLK<='0';
    WAIT FOR 50 ns;
    addr<="000010";
    w_r<="1111";
    datain<=x"10112311";
    WAIT FOR 100 ns;
    CLK<='1';
    WAIT FOR 100 ns;

    CLK<='0';
    WAIT FOR 50 ns;
    addr<="000001";
    datain<=x"10167111";
    WAIT FOR 50 ns;
    CLK<='1';
    WAIT FOR 100 ns;

    CLK<='0';
    WAIT FOR 100 ns;
    addr<="000000";
    datain<=x"10189111";
    WAIT FOR 100 ns;
    CLK<='1';
    WAIT FOR 100 ns;

    CLK<='0';
    WAIT FOR 110 ns;

 
    addr<="100000";
    WAIT FOR 100 ns;
    addr<="000000";
    WAIT FOR 100 ns;
    addr<="010000";
    WAIT FOR 100 ns;
    addr<="001000";
    WAIT FOR 100 ns;
    addr<="000100";
    WAIT FOR 100 ns;
        
    ASSERT FALSE REPORT "Test done FOR DATA MEMORY. Open EPWave to see signals." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END BEV;