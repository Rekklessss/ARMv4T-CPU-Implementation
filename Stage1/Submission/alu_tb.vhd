-- Testbench for ALU
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component alu is
port(
  op1: in std_logic_vector (31 downto 0);
  op2: in std_logic_vector (31 downto 0);
  cin: in std_logic;
  opcode: in std_logic_vector (3 downto 0);
  cout: out std_logic;
  res: out std_logic_vector (31 downto 0)
  );
end component;

signal c1, c2: std_logic;
signal code: std_logic_vector (3 downto 0);
signal op1_in, op2_in, res_out: std_logic_vector (31 downto 0);
begin

  -- Connect DUT
  DUT: alu port map(op1_in, op2_in, c1, code, c2, res_out);

  process
  begin
  
op1_in <= x"0001574d";
op2_in <= x"000005bf";
c1 <= '1';
code <= "0000";
wait for 1 ns;
assert(res_out=x"0000050d") report "Fail code0000 res_out" severity error;
code <= "0001";
wait for 1 ns;
assert(res_out=x"000152f2") report "Fail code0001 res_out" severity error;
code <= "0010";
wait for 1 ns;
assert(res_out=x"0001518e") report "Fail code0010 res_out" severity error;
code <= "0011";
wait for 1 ns;
assert(res_out=x"fffeae72") report "Fail code0011 res_out" severity error;
code <= "0100";
wait for 1 ns;
assert(res_out=x"00015d0c") report "Fail code0100 res_out" severity error;
code <= "0101";
wait for 1 ns;
assert(res_out=x"00015d0d") report "Fail code0101 res_out" severity error;
code <= "0110";
wait for 1 ns;
assert(res_out=x"0001518e") report "Fail code0110 res_out" severity error;
code <= "0111";
wait for 1 ns;
assert(res_out=x"fffeae72") report "Fail code0111 res_out" severity error;
code <= "1000";
wait for 1 ns;
assert(res_out=x"0000050d") report "Fail code1000 res_out" severity error;
code <= "1001";
wait for 1 ns;
assert(res_out=x"000152f2") report "Fail code1001 res_out" severity error;
code <= "1010";
wait for 1 ns;
assert(res_out=x"0001518e") report "Fail code1010 res_out" severity error;
code <= "1011";
wait for 1 ns;
assert(res_out=x"00015d0c") report "Fail code1011 res_out" severity error;
code <= "1100";
wait for 1 ns;
assert(res_out=x"000157ff") report "Fail code1100 res_out" severity error;
code <= "1101";
wait for 1 ns;
assert(res_out=x"000005bf") report "Fail code1101 res_out" severity error;
code <= "1110";
wait for 1 ns;
assert(res_out=x"00015240") report "Fail code1110 res_out" severity error;
code <= "1111";
wait for 1 ns;
assert(res_out=x"fffffa40") report "Fail code1111 res_out" severity error;
  
    -- Clear inputs
    op1_in <= "00000000000000000000000000000000";
    op2_in <= "00000000000000000000000000000000";
    code <= "0000";
    c1 <= '0';

    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
