library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity PMconnect is
 Port  (
 		Rout: in word;
 		Rin: out word;
 		instruction: in word;
        byte_type: in std_logic_vector(2 downto 0);
        fstate: in integer;
   		adr: in bit_pair;
    	Memory_input: out word;
        Mout: in word;
        MW: out nibble
    );
 end entity;

architecture beh of PMconnect is
begin 

process(fstate,Mout,Rout,instruction,byte_type,adr)
begin
	if(byte_type="000") then
    	--str
    	Memory_input <=Rout;
        if(fstate=5) then
			MW <= "1111";
        else
        	MW <= "0000";
        end if;
        
        --ldr
        Rin <=Mout;
        
        
    elsif(byte_type="001") then
    	--strh
    	Memory_input<= Rout(15 downto 0) & Rout(15 downto 0);
        if(fstate=5) then
          if(adr = "00") then	
              MW<="0011";
          else
              MW<="1100";
          end if;
        else
        	MW <= "0000";
        end if;
        
        --ldrh
        Rin(31 downto 16)<= "0000000000000000";
    	if(adr = "00") then	
        	 Rin(15 downto 0)<=Mout(15 downto 0);
        else
        	Rin(15 downto 0)<=Mout(31 downto 16);
        end if;
        
        
    elsif(byte_type="010") then
    	--strb
    	Memory_input<= Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0);
        if(fstate=5) then
          if(adr = "00") then
              MW<="0001";
          elsif(adr = "01") then
              MW<="0010";
          elsif(adr = "10") then
              MW<="0100";
          else
              MW<="1000";
          end if;
        else
        	MW <= "0000";
        end if;
        
        --ldrb
        Rin(31 downto 8)<= "000000000000000000000000";
        if(adr = "00") then
        	Rin(7 downto 0)<=Mout(7 downto 0);
        elsif(adr = "01") then
        	Rin(7 downto 0)<=Mout(15 downto 8);
        elsif(adr = "10") then
        	Rin(7 downto 0)<=Mout(23 downto 16);
        else
        	Rin(7 downto 0)<=Mout(31 downto 24);
        end if;
        
    elsif(byte_type="011") then
    	--ldrsh
        if(adr = "00") then	
        	 Rin(31 downto 16)<= Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15);
        	 Rin(15 downto 0)<=Mout(15 downto 0);
        else
        	Rin(31 downto 16)<= Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31);
        	Rin(15 downto 0)<=Mout(31 downto 16);
        end if;
        
    elsif(byte_type="100") then
    --ldrsb
    	
        if(adr = "00") then
        	Rin(31 downto 8)<= Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7) & Mout(7);
        	Rin(7 downto 0)<=Mout(7 downto 0);
        elsif(adr = "01") then
        	Rin(31 downto 8)<= Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15) & Mout(15);
        	Rin(7 downto 0)<=Mout(15 downto 8);
        elsif(adr = "10") then
        	Rin(31 downto 8)<= Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23) & Mout(23);
        	Rin(7 downto 0)<=Mout(23 downto 16);
        else
        	Rin(31 downto 8)<= Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31) & Mout(31);
        	Rin(7 downto 0)<=Mout(31 downto 24);
        end if;
    
    end if;
end process;
end beh;