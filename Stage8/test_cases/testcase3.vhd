library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity mem is
PORT(
	wd : IN word;
	prog_add : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	data_add: in std_logic_vector(6 downto 0);
	MW: IN nibble;
	clock : in std_logic;
	rd : OUT word;
	IorD: in std_logic;
	mode: in std_logic
	);
end entity;

--rte = X'E6000011'
--ret = X'E6000010'
--swi = X'EF000000'
-- X'E3A00070'
-- X'E5900000'
architecture bev of mem is
    SIGNAL address_m: INTEGER RANGE 0 TO 127;
    signal address_i : INTEGER RANGE 0 TO 63;
    signal memm :  memory_type := (
	0 => X"EA000006",--instruction to branch to 8
	2 => X"EA00000C",--instruction to branch to 16
	8 => X"E3A0E080", -- ISR for reset
	9 => X"E6000011", --rte
	16 => X"E3A00070",    --swi ISR
	17 => X"E5900000",
	18 => X"E6000010", --ret
	32 => X"EF000000",
	others => X"00000000" );
begin
    address_i<=to_integer(unsigned(prog_add));
    address_m<=to_integer(unsigned(data_add));
    process(IorD, prog_add, data_add, mode, clock)
    begin
    	if(mode = '0' and address_m<32) then
    		rd<=x"00000000";
    	elsif(IorD = '1') then
    		rd<=memm(address_m);
    	else
    		rd<=memm(address_i);
    	end if;
    end process;
    process(clock)
    begin
            if (rising_edge(clock)) then
            	IF(MW(0)='1' and address_m>=32)THEN
            		memm(address_m)(7 DOWNTO 0)<=wd(7 DOWNTO 0);
            	end if;
            	IF(MW(1)='1' and address_m>=32)THEN
           		memm(address_m)(15 DOWNTO 8)<=wd(15 DOWNTO 8);
            	end if;
            	IF(MW(2)='1' and address_m>=32)THEN
           		memm(address_m)(23 DOWNTO 16)<=wd(23 DOWNTO 16);
            	end if;
            	IF(MW(3)='1' and address_m>=32)THEN
           		memm(address_m)(31 DOWNTO 24)<=wd(31 DOWNTO 24);
            	end if;
         end if;
	  END PROCESS;
END BEV;
