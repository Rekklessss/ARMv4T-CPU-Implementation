library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity condition is
port(
  N: in std_logic;
  V: in std_logic;
  Z: in std_logic;
  C: in std_logic;
  cond: in nibble;
  result: out std_logic;
  instr_class: in instr_class_type
  );
end condition;

architecture rtl of condition is
begin
    process(cond,Z)
    begin
        if instr_class = BRN then 
            case to_integer(unsigned(cond)) is
                when 0 =>
                    result <= Z;
                
                when 1 =>
                    result <= not Z;

                when others =>
                    result <= '0';

            end case;
        end if;
    end process;
end rtl;
