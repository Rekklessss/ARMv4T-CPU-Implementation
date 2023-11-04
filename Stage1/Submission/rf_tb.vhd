LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY RF_TB IS 
-- empty
END ENTITY;

ARCHITECTURE BEV OF RF_TB IS

SIGNAL datain : STD_LOGIC_VECTOR(31 DOWNTO 0):=x"0000000a";
SIGNAL add_read1 : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL add_read2 : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL add_write : STD_LOGIC_VECTOR(3 DOWNTO 0):="0000";
SIGNAL w_r : STD_LOGIC:='0';
SIGNAL clk : STD_LOGIC:='0';
SIGNAL data_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

-- DUT component
COMPONENT RF IS
    PORT(datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       add_in1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       add_in2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       -- Write when 0, Read when 1
       w_r : IN STD_LOGIC;
       clk: in std_logic;
       data_out1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       data_out2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       add_out : in STD_LOGIC_VECTOR(3 DOWNTO 0)
       );
END COMPONENT;

BEGIN

  -- Connect DUT
  UUT: RF PORT MAP(datain, add_read1, add_read2, w_r, clk, data_out1, data_out2, add_write);

  PROCESS
  BEGIN
    -- Write data into RAM
    wait for 50 ns;
    clk <= '1';
    WAIT FOR 50 ns;
    add_write<="0000";
    datain<=x"00000005";
    
    wait for 50 ns;
    clk <= '0';
    WAIT FOR 50 ns;
    add_write<="0001";
    datain<=x"00000006";
    add_read1<="0000";
    add_read2<="0000";
    
    wait for 50 ns;
    clk <= '1';
    WAIT FOR 50 ns;
    add_write<="0010";
    datain<=x"00000007";
    add_read1<="0001";
    add_read2<="0001";
    
    wait for 50 ns;
    clk <= '0';
    WAIT FOR 50 ns;
    add_write<="0011";
    datain<=x"00000008";
    add_read1<="0010";
    add_read2<="0010";
    
    wait for 50 ns;
    clk <= '1';
    WAIT FOR 50 ns;
    add_write<="0100";
    datain<=x"00000009";
    add_read1<="0011";
    add_read2<="0011";
    
    ASSERT FALSE REPORT "Test done. Open EPWave to see signals." SEVERITY NOTE;
    WAIT;
  END PROCESS;

END BEV;