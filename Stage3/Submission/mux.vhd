library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity mux is
 Port  (inp1: in word;
 	inp2: in word;
 	inp3: in word;
 	inp4: in word;
 	output: out word;
 	sel: in bit_pair);
 end entity;

architecture behavior of mux is
begin 
with sel select
    output <= 	inp1 when "00",
    		inp2 when "01",
    		inp3 when "10",
    		inp4 when "11",
    		inp1 when others;
end architecture;

 