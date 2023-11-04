library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MyTypes.all;

entity flags is
port(
  N: out std_logic;
  V: out std_logic;
  Z: out std_logic;
  C: out std_logic;
  opcode: in optype;
  cin: in std_logic;
  S: in std_logic;
  op1: in word;
  op2: in word;
  res: in word;
  clk: in std_logic
  );
end flags;

architecture rtl of flags is

begin
  process(clk) is
  begin
  if(rising_edge(clk)) then
  	case opcode is 
   		when add | sub | rsb | adc | sbc | rsc=>
            if S = '1' then 
                N <= res(31);
                C <= cin;
                V <= (op1(31) and op2(31) and (not res(31))) or ((not op1(31)) and (not op2(31)) and res(31));
                if to_integer(unsigned(res)) = 0 then
                    Z <='1';
                else
                    Z <='0';
                end if;
            end if;

        when cmp | cmn=>	
            N <= res(31);
            C <= cin;
            V <= (op1(31) and op2(31) and (not res(31))) or ((not op1(31)) and (not op2(31)) and res(31));
            if to_integer(unsigned(res)) = 0 then
                Z <='1';
            else
                Z <='0';
            end if;
          
        when andop | orr | eor | bic | mov | mvn=>
            if S = '1' then 
                N <= res(31);
                if to_integer(unsigned(res)) = 0 then
                    Z <='1';
                else
                    Z <='0';
                end if;
            end if;
         
        when tst | teq =>	
            N <= res(31);
            if to_integer(unsigned(res)) = 0 then
                Z <='1';
            else
                Z <='0';
            end if;

    end case;
            end if;
  end process;
end rtl;
