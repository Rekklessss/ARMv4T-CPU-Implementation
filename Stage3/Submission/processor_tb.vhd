library IEEE;
use IEEE.std_logic_1164.all;
use work.MyTypes.all;

entity processor_tb is
-- empty
end entity; 

architecture tb of processor_tb is
signal clock: std_logic:='0';
signal reset: std_logic:='1';
signal p_c: word;
begin
  DUT: entity work.processor port map(reset, clock, p_c);
  process
  begin
  wait for 1 ns;
  reset<='0';
  for i in 1 to 40 loop
	clock <= '1';
	wait for 1 ns;
	clock <= '0';
	wait for 1 ns;
	end loop;
	wait;
    --assert false report "Test done." severity note;
  end process;
end tb;