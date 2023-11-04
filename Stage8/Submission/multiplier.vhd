library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
 Port  (
 		Rm: in word;
 		Rs: in word;
        signed_unsigned: in std_logic;
        enable: in std_logic;
    	Rd: out std_logic_vector(63 downto 0)
    );
 end multiplier;

architecture beh of multiplier is
signal p_s: signed(65 downto 0);
signal x1,x2: std_logic;
begin 
    x1<= Rm(31) when signed_unsigned = '1' else '0';
    x2<= Rs(31) when signed_unsigned = '1' else '0';
    p_s<=signed(x1 & Rm) * signed(x2 & Rs) when enable = '1' else "000000000000000000000000000000000000000000000000000000000000000000";
    Rd<= std_logic_vector(p_s(63 downto 0));
end architecture;