library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity alu is
port(
  op1: in word;
  op2: in word;
  cin: in std_logic;
  opcode: in optype;
  cout: out std_logic;
  res: out word
  );
end alu;

architecture rtl of alu is

begin
  process(op1, op2, opcode, cin) is
  variable temp: std_logic_vector (32 downto 0);
  begin
  	case opcode is 
   		when andop =>
    		res <= op1 and op2;
            cout <= cin;
            
        when eor =>	
    		res <= op1 xor op2;
            cout <= cin;
            
        when sub =>	
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + x"00000001");
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when rsb =>	
    		temp := std_logic_vector(signed('0' & op2) + signed(not('0' & op1)) + x"00000001");
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when add =>	
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2));
            res <= temp(31 downto 0);
            cout <= temp(32);
          
        when adc =>	
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2) +("0000000000000000000000000000000"&cin));
            res <= temp(31 downto 0);
            cout <= temp(32);
           
        when sbc =>	
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + ("0000000000000000000000000000000"&cin));
            res <= temp(31 downto 0);
            cout <= temp(32);
        
        when rsc =>	
    		temp := std_logic_vector(signed('0' & op2) + signed(not('0' & op1)) + ("0000000000000000000000000000000"&cin));
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when tst =>	
    		res <= op1 and op2;
            cout <= cin;
            
        when teq =>	
    		res <= op1 xor op2;
            cout <= cin;
            
        when cmp =>	
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + x"00000001");
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when cmn =>	
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2));
            res <= temp(31 downto 0);
            cout <= temp(32);
          
        when orr =>	
    		res <= op1 or op2;
            cout <= cin;
         
         when mov =>	
    		  res <= op2;
            cout <= cin;
            
         when bic =>	
    		res <= op1 and not op2;
            cout <= cin;
            
         when mvn =>
    		res <= not op2;
            cout <= cin;

    end case;
  end process;
end rtl;