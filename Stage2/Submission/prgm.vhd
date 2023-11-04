LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;
    use work.MyTypes.all;

ENTITY IM IS
  PORT(
       ADDRESS : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
       DATAOUT : OUT word
       );
END ENTITY;

--Here address is the word address, 6 bits and the memory has entries of 32 bits. The data which is the output of this component is a 32 bit piece of data
ARCHITECTURE BEV OF IM IS
signal ADDR : INTEGER RANGE 0 TO 63;
signal MEMORY : memory_type := (0 => X"E3A0000A",
1 => X"E3A01005",
2 => X"E5801000",
3 => X"E2811002",
4 => X"E5801004",
5 => X"E5902000",
6 => X"E5903004",
7 => X"E0434002", others => X"00000000"
);
BEGIN

ADDR<=CONV_INTEGER(ADDRESS);
DATAOUT<=MEMORY(ADDR);
END BEV;