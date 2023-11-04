library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity mux is
 Port  (inp1: in word;
 	inp2: in word;
 	inp3: in word;
 	inp4: in word;
	inp5: in word;
 	output: out word;
 	sel: in std_logic_vector(2 downto 0));
 end entity;

architecture behavior of mux is
begin 
with sel select
    output <= 	inp1 when "000",
    		inp2 when "001",
    		inp3 when "010",
    		inp4 when "011",
			inp5 when "100",
    		inp1 when others;
end architecture;

 