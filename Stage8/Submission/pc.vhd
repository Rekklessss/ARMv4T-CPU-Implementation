library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity pc is
 Port  (
 		reset: in std_logic;
 		reg_fstate: in fstate_type;
 		p_c: out word;
        PW: in std_logic;
   		result: in word;
    	clock: in std_logic;
        fstate: inout fstate_type;
        swi: in std_logic;
        ret: in std_logic;
        rte: in std_logic
    );
 end entity;

architecture beh of pc is
begin 

    process(reset,reg_fstate)
    begin
    if(reset='1') then
            p_c<=x"00000080";
    elsif(swi='1' and (fstate = 8 or fstate = 17)) then
            p_c<=x"00000008";
    elsif(fstate = 20 and (ret = '1' or rte = '1')) then
            p_c<=result;
    elsif(PW='1') then
            p_c<=result(29 downto 0)&"00";
     end if;
    end process;

    process (clock)
    BEGin
        if (rising_edge(clock)) then
            fstate <= reg_fstate;
         end if;
    end process;

end architecture;