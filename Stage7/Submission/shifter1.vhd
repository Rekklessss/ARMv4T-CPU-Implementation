library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity shifter1 is
 Port  (
 		input: in word;
 		sel: in std_logic;
 		shift_type: in bit_pair;
        carryin: in std_logic;
   		carryout: out std_logic;
    	output: out word
    );
 end shifter1;

architecture beh of shifter1 is
begin 
process(input,sel)
begin
if(sel='1') then
	if(shift_type = "00") then
      output(31 downto 1)<=input(30 downto 0);
      output(0)<='0';
      
    else
	output(30 downto 0)<=input(31 downto 1);
    
    	if(shift_type = "00") then
    		output(31)<= '0';
    	elsif(shift_type = "01") then
                output(31)<= '0';
        elsif(shift_type = "10") then
                output(31)<= input(31);
        elsif(shift_type = "11") then
                output(31)<=input(0);
        else        
                output(31)<='0';
        end if;
    carryout<= input(0);
    end if;
    
else
	output<=input;
    carryout<=carryin;
end if;

end process;
end beh;
