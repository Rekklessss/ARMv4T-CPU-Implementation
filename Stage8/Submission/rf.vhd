LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
    use work.MyTypes.all;

-- RAM entity
ENTITY RF IS
  PORT(
       datain : IN word;
       add_in1 : IN nibble;
       add_in2 : IN nibble;
       -- Write when 0, Read when 1
       w_r : IN STD_LOGIC;
       clk: in std_logic;
       data_out1 : out word;
       data_out2 : out word;
       add_out : in nibble
       );
END ENTITY;

-- RAM architecture
ARCHITECTURE BEV OF RF IS

SIGNAL MEMORY : RF_type;
SIGNAL addr1 : INTEGER RANGE 0 TO 15;
SIGNAL addr2 : INTEGER RANGE 0 TO 15;
SIGNAL addr3 : INTEGER RANGE 0 TO 15;

BEGIN
	  addr1<=to_INTEGER(unsigned(add_in1));
    addr2<=to_INTEGER(unsigned(add_in2));
    addr3<=to_INTEGER(unsigned(add_out));
	  data_out1<=MEMORY(addr1);
    data_out2<=MEMORY(addr2);
process(clk)
begin
  if (rising_edge(clk)) then
    IF(w_r='1')THEN
      MEMORY(addr3)<=datain;      
    END IF;
  end if;
end process;

END BEV;