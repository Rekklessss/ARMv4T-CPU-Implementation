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
    
    
    	if(shift_type = "00") then
    		output(31 downto 30)<=  "00";
    	elsif(shift_type = "01") then
                output(31 downto 30)<=  "00";
        elsif(shift_type = "10") then
                output(31 downto 30)<= input(31) & input(31);
        elsif(shift_type = "11") then
                output(31 downto 30)<= input(1 downto 0);
        else        
                output(31 downto 30)<= "00";
        end if;
        
    carryout<= input(1);
    end if;
else
	output<=input;
    carryout<=carryin;
end if;

end process;
end beh;
