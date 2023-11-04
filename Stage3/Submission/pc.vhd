library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity pc is
port(
  res: in word;
  PW: in std_logic;
  clk: in std_logic;
  prog_c: out word
  );
end pc;

architecture rtl of pc is
signal program_counter:word:= x"00000000";
begin

    process(clk,PW) is
    begin
    if(rising_edge(clk)) then 
    if(PW = '1') then
    prog_c<= program_counter;
    program_counter<= res;
     	
        
   end if;
   end if;
  end process;
end rtl;