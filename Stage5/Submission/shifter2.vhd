library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity shifter2 is
 Port  (
 		input: in word;
 		sel: in std_logic;
 		shift_type: in bit_pair;
        carryin: in std_logic;
   		carryout: out std_logic;
    	output: out word
    );
 end shifter2;

architecture beh of shifter2 is
begin 
process(input,sel)
begin
if(sel='1') then
	if(shift_type = "00") then
      output(31 downto 2)<=input(29 downto 0);
      output(1 downto 0)<="00";
      
    else
	output(29 downto 0)<=input(31 downto 2);
    
    with shift_type select
    output(31 downto 30)<=  "00" when "00",
                  "00" when "01",
                  input(31) & input(31) when "10",
                  input(1 downto 0) when "11",
                  "00" when others;
    carryout<= input(1);
    end if;
else
	output<=input;
    carryout<=carryin;
end if;

end process;
end beh;