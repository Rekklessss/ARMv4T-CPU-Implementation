LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.all;
    use work.MyTypes.all;

ENTITY Mem IS
  PORT(
       wd : IN word;
       prog_add : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
       data_add: in std_logic_vector(5 downto 0);
       MW: IN nibble;
       clock : in std_logic;
       rd : OUT word;
       IorD: in std_logic
       );
END ENTITY;


ARCHITECTURE BEV OF Mem IS

--SIGNAL data_mem : memory_type;					--modify for program and data
SIGNAL address_m: INTEGER RANGE 0 TO 63;

signal address_i : INTEGER RANGE 0 TO 63;
signal mem :  memory_type :=
(0 => X"E3A01001",
1 => X"E3A02001",
2 => X"E3A05000",
3 => X"E0812002",
4 => X"E0421001",
5 => X"E2855001",
6 => X"E3550004",
7 => X"1AFFFFFA",
8 => X"E1A00002",
others => X"00000000"
);
BEGIN
    address_i<=to_integer(unsigned(prog_add));
    address_m<=to_integer(unsigned(data_add));
    rd<=mem(address_m+64) when IorD = '1' else mem(address_i);
    process(clock)
        begin   
        if (rising_edge(clock)) then
            IF(MW(0)='1')THEN
                mem(address_m+64)(7 DOWNTO 0)<=wd(7 DOWNTO 0);
            end if;
            IF(MW(1)='1')THEN
                mem(address_m+64)(15 DOWNTO 8)<=wd(15 DOWNTO 8);
            end if;
            IF(MW(2)='1')THEN
                mem(address_m+64)(23 DOWNTO 16)<=wd(23 DOWNTO 16);
            end if;
            IF(MW(3)='1')THEN
                mem(address_m+64)(31 DOWNTO 24)<=wd(31 DOWNTO 24);
            end if;
        end if;
  END PROCESS;
END BEV;