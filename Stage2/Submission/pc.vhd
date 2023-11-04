library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity pc is
port(
  offset: in std_logic_vector(23 downto 0);
  Psrc: in std_logic;
  clk: in std_logic;
  pc: out word
  );
end pc;

architecture rtl of pc is
signal program_counter: word:= x"00000000";
begin
    process(clk,Psrc) is
    begin
    if(rising_edge(clk)) then 
      if Psrc = '1' then 
        pc<= std_logic_vector(signed(program_counter(31 downto 2)) + 2 +signed(offset)) & "00";
        program_counter<= std_logic_vector(signed(program_counter(31 downto 2)) + 2 +signed(offset)) & "00";
      else    
        pc<= std_logic_vector(signed(program_counter) + 4 );
        program_counter<= std_logic_vector(signed(program_counter) + 4 );
      end if;
   end if;
  end process;
end rtl;
