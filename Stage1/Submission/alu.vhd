library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
port(
  op1: in std_logic_vector (31 downto 0);
  op2: in std_logic_vector (31 downto 0);
  cin: in std_logic;
  opcode: in std_logic_vector (3 downto 0);
  cout: out std_logic;
  res: out std_logic_vector (31 downto 0)
  );
end alu;

architecture rtl of alu is
begin
  process(op1, op2, opcode, cin) is
  variable temp: std_logic_vector (32 downto 0);
  begin
  
  	case opcode is 
   		when "0000" =>	--and
    		res <= op1 and op2;
            cout <= cin;
            
        when "0001" =>	--eor
    		res <= op1 xor op2;
            cout <= cin;
            
        when "0010" =>	--sub
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + 1);
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when "0011" =>	--rsb
    		temp := std_logic_vector(signed('0' & op2) + signed(not('0' & op1)) + 1);
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when "0100" =>	--add
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2));
            res <= temp(31 downto 0);
            cout <= temp(32);
          
        when "0101" =>	--adc
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2) + cin);
            res <= temp(31 downto 0);
            cout <= temp(32);
           
        when "0110" =>	--sbc
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + cin);
            res <= temp(31 downto 0);
            cout <= temp(32);
        
        when "0111" =>	--rsc
    		temp := std_logic_vector(signed('0' & op2) + signed(not('0' & op1)) + cin);
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when "1000" =>	--tst
    		res <= op1 and op2;
            cout <= cin;
            
        when "1001" =>	--teq
    		res <= op1 xor op2;
            cout <= cin;
            
        when "1010" =>	--cmp
    		temp := std_logic_vector(signed('0' & op1) + signed(not('0' & op2)) + 1);
            res <= temp(31 downto 0);
            cout <= temp(32);
            
        when "1011" =>	--cmn
    		temp := std_logic_vector(signed('0' & op1) + signed('0' & op2));
            res <= temp(31 downto 0);
            cout <= temp(32);
          
        when "1100" =>	--orr
    		res <= op1 or op2;
            cout <= cin;
         
         when "1101" =>	--mov
    		res <= op2;
            cout <= cin;
            
         when "1110" =>	--bic
    		res <= op1 and not op2;
            cout <= cin;
            
         when "1111" =>	--mvn
    		res <= not op2;
            cout <= cin;
            
        when others =>
        	res <= op1;
            cout<= cin;
    end case;
  end process;
end rtl;
