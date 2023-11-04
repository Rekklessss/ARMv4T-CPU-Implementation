library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity mux3 is
 Port  (inp1: in nibble;
 	inp2: in nibble;
 	inp3: in nibble;
 	output: out nibble;
 	sel: in bit_pair);
 end entity;

architecture behavior of mux3 is
begin 
with sel select
    output <= 	inp1 when "00",
    		inp2 when "01",
    		inp3 when "10",
    		inp1 when others;
end architecture;

 