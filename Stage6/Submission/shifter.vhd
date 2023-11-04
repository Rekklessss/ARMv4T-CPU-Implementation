library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity shifter is
 Port  (
 	operand: in word;
 	shift1: in std_logic;
 	shift2: in std_logic;
 	shift4: in std_logic;
 	shift8: in std_logic;
 	shift16: in std_logic;
 	shift_type: in bit_pair;
    carry: out std_logic;
    result: out word
    );
 end shifter;

architecture behavior of shifter is
signal res1:word;
signal res2: word;
signal res4:word;
signal res8:word;
signal carry1:std_logic;
signal carry2:std_logic;
signal carry4:std_logic;
signal carry8:std_logic;
begin 

Shifter1: entity work.shifter1 port map(operand, shift1, shift_type, '0', carry1, res1);
Shifter2: entity work.shifter2 port map(res1, shift2, shift_type, carry1, carry2, res2);
Shifter4: entity work.shifter4 port map(res2, shift4, shift_type, carry2, carry4, res4);
Shifter8: entity work.shifter8 port map(res4, shift8, shift_type, carry4, carry8, res8);
Shifter16: entity work.shifter16 port map(res8, shift16, shift_type, carry8, carry, result);
end behavior;