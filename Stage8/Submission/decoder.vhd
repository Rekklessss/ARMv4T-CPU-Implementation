library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
 Port(
    instruction : in word;
    instr_class : out instr_class_type;
    DP_subclass : out DP_subclass_type;
    DP_operand_src : out DP_operand_src_type;
    load_store : out load_store_type;
    Cond :out nibble;
    S: out std_logic;
    Rn : out nibble;
    Rd : out nibble;
    Rm : out nibble;
    Imm : out word;
    Offset: out word;
    Sext: out std_logic_vector(5 downto 0);
    S_offset: out word;
    shift1: out std_logic;
    shift2: out std_logic;
    shift4: out std_logic;
    shift8: out std_logic;
    shift16: out std_logic;
    shift_type: out bit_pair;
    shift_register: out nibble;
    shift_mode: out std_logic;
    rot: out std_logic_vector (4 downto 0);
    byte_type: out std_logic_vector(2 downto 0);
    half: out std_logic;
    write_back: out std_logic;
    post_pre: out std_logic;
    mul: out std_logic;
    mul_set_condcode: out std_logic;
    mul_acc: out std_logic;
    mul_sign: out std_logic;
    mul_long_short: out std_logic;
    L: out std_logic;
    swi: out std_logic;
    ret: out std_logic;
    rte: out std_logic;
    mode: out std_logic
    );
end Decoder;

architecture Behavioral of Decoder is

begin

process(instruction)
begin
  if(instruction (27 downto 26) = "01") then
    if(instruction(25)='1' and instruction(4)='1') then
      instr_class<=BRN;
    else
  	  instr_class <= DT;
    end if;
  elsif(instruction (27 downto 26) = "00") then
  	if(instruction(4) = '1' and instruction(7) = '1') then
    	instr_class <=DT;
    else
  		instr_class <=DP;
    end if;
  elsif(instruction (27 downto 26) = "10" or instruction (27 downto 26) = "11") then
  	instr_class <=BRN;
  else
  	instr_class <=none;
  end if;
end process;

with instruction (24 downto 22) select
    DP_subclass <= arith when "001" | "010" | "011",
    logic when "000" | "110" | "111",
    comp when "101",
    test when others;
    
process(instruction)
begin

if(instruction (27 downto 26) = "01") then
	if(instruction(22) = '1') then
		byte_type <="010";
    else
		byte_type <="000";
    end if;
elsif(instruction (27 downto 26) = "00") then
	if(instruction(6 downto 5) = "01") then
		byte_type <="001";
    elsif(instruction(6 downto 5) = "10") then
		byte_type <="100";
    elsif(instruction(6 downto 5) = "11") then
		byte_type <="011";
    end if;
end if;
end process;

load_store <= load when instruction (20) = '1' else store;

half<= '1' when instruction(27 downto 25) = "000" and instruction(4) = '1' and instruction(7) = '1' and instruction(6 downto 5) /= "00" else '0';
mul<= '1' when instruction(27 downto 24) = "0000" and instruction(7 downto 4) = "1001" else '0';
mul_set_condcode<=instruction(20);
mul_acc<=instruction(21);
mul_sign<= instruction(22);
mul_long_short<=instruction(23);

process(instruction)
begin
  if(instruction(27 downto 25) = "000" and instruction(4) = '1' and instruction(7) = '1') then
  	if(instruction(22) = '0') then
    	DP_operand_src <= reg;
    else
    	DP_operand_src <= imm8;
    end if;
  elsif(instruction (25) = '0') then
  	DP_operand_src <= reg;
  else
  	DP_operand_src <= imm8;
  end if;
end process;

Cond <= instruction(31 downto 28);
S<= instruction(21) when instruction(27 downto 24) = "0000" and instruction(7 downto 4) = "1001" else instruction(20);
Rn <= instruction(19 downto 16);
Rd <= instruction(15 downto 12);
Rm <= instruction(3 downto 0);
Imm <= "000000000000000000000000" & instruction(7 downto 0);
rot<= instruction(11 downto 8) & '0';
write_back<=instruction(21) or not(instruction(24));
post_pre<= instruction(24);
L<= instruction(24);

--store offset
Offset<= "000000000000000000000000" & instruction(11 downto 8) & instruction(3 downto 0) when instruction(27 downto 26) = "00" and instruction(4) = '1' and instruction(7) = '1' else "00000000000000000000" & instruction(11 downto 0);

-- Sign extension for branch address
Sext <= "111111" when (instruction(23) = '1') else "000000";
S_offset<= "00000000" & instruction(23 downto 0) when instruction(23) = '0' else "11111111"& instruction(23 downto 0);


shift_mode<= instruction(4);
shift_type<= "11" when instruction(27 downto 25) = "001" else instruction(6 downto 5);
shift_register<= instruction(11 downto 8);
shift1<= instruction(7);
shift2<= instruction(8);
shift4<= instruction(9);
shift8<= instruction(10);
shift16<= instruction(11);


swi<= '1' when instruction(27 downto 24) = "1111" else '0';
ret<= '1' when instruction(27 downto 25) = "011" and instruction(4 downto 0) = "10000" else '0';
rte<= '1' when instruction(27 downto 25) = "011" and instruction(4 downto 0) = "10001" else '0';

process(instruction)
begin
if(instruction(27 downto 24) = "1111") then
  mode<='1';
elsif(instruction(27 downto 25) = "011" and instruction(4 downto 0) = "10001") then
  mode<='0';
end if;
end process;

end Behavioral;