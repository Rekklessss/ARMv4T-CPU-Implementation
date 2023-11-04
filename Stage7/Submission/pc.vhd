library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity pc is
 Port  (
 		reset: in std_logic;
 		reg_fstate: in integer RANGE 0 TO 16;
 		p_c: out word;
        PW: in std_logic;
   		result: in word;
    	clock: in std_logic;
        fstate: out integer RANGE 0 TO 16
    );
 end entity;

architecture beh of pc is
begin 

    process(reset,reg_fstate)
    begin
    if(reset='1') then
           p_c<=x"00000000";
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