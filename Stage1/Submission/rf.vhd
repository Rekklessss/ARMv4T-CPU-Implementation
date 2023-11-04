LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- RAM entity
ENTITY RF IS
  PORT(
       datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       add_in1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       add_in2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       -- Write when 0, Read when 1
       w_r : IN STD_LOGIC;
       clk: in std_logic;
       data_out1 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       data_out2 : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       add_out : in STD_LOGIC_VECTOR(3 DOWNTO 0)
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF RF IS

TYPE MEM IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL MEMORY : MEM;
SIGNAL addr1 : INTEGER RANGE 0 TO 15;
SIGNAL addr2 : INTEGER RANGE 0 TO 15;
SIGNAL addr3 : INTEGER RANGE 0 TO 15;

BEGIN
	  addr1<=CONV_INTEGER(add_in1);
      addr2<=CONV_INTEGER(add_in2);
      addr3<=CONV_INTEGER(add_out);
	  data_out1<=MEMORY(addr1);
      data_out2<=MEMORY(addr2);
process(clk)
begin
  if (rising_edge(clk)) then
    IF(W_R='0')THEN
      MEMORY(addr3)<=datain;      
    END IF;
  end if;
end process;

END BEV;
