library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
 Port(
    instruction : in word;
    instr_class : out instr_class_type;
    opcode_DP : out optype;
    DP_subclass : out DP_subclass_type;
    DP_operand_src : out DP_operand_src_type;
    load_store : out load_store_type;
    DT_offset_sign : out DT_offset_sign_type;
    Cond :out nibble;
    S: out std_logic;
    Rn : out nibble;
    Rd : out nibble;
    Rm : out nibble;
    Imm : out byte;
    opcode_DT: out std_logic_vector(5 downto 0);
    Ubit: out std_logic;
    Lbit: out std_logic;
    Offset: out std_logic_vector (11 downto 0);
    Sext: out std_logic_vector(5 downto 0);
    S_offset: out std_logic_vector (23 downto 0);
    Rsrc: out std_logic;
    Asrc: out std_logic;
    M2R: out std_logic;
    RW: out std_logic;
    write: out nibble;
    PW:out std_logic;
    Fset:out std_logic
    );
end Decoder;

architecture Behavioral of Decoder is

type oparraytype is array (0 to 15) of optype;
constant oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);
begin

with instruction (27 downto 26) select
    instr_class <= DP when "00",
    DT when "01",
    BRN when "10",
    none when others;

with instruction (24 downto 22) select
    DP_subclass <= arith when "001" | "010" | "011",
    logic when "000" | "110" | "111",
    comp when "101",
    test when others;


load_store <= load when instruction (20) = '1' else store;
DT_offset_sign <= plus when instruction (23) = '1' else minus;
DP_operand_src <= reg when instruction (25) = '0' else imm8;

Cond <= instruction(31 downto 28);
S<= instruction(20);
Rn <= instruction(19 downto 16);
Rd <= instruction(15 downto 12);
Rm <= instruction(3 downto 0);
Imm <= instruction(7 downto 0);
opcode_DT<= instruction(25 downto 20);
Ubit<= instruction(23);
Lbit<= instruction(20);
Offset<= instruction(11 downto 0);
-- Sign extension for branch address
Sext <= "111111" when (instruction(23) = '1') else "000000";
S_offset<= instruction(23 downto 0);


PW<='1';
Fset<='1';
write <= "1111" when instruction (27 downto 26) = "01" and instruction (20) = '0' else "0000";
Rsrc<= '1' when instruction (27 downto 26) = "01" and instruction (20) = '0' else '0'; --only store
Asrc<= '1' when instruction (27 downto 26) = "01" or instruction(25) = '1' else '0';
M2R<=instruction(20);

process(instruction)
begin 
if(instruction (27 downto 26) = "00") then 
    if(instruction (24 downto 21) = "1010") then
        RW<='0';
    else
        RW<='1';
    end if;
elsif(instruction (27 downto 26) = "01") then 
    if(instruction (20) = '1') then
        RW<= '1';
    else
        RW<= '0';
    end if;
end if;

if(instruction (27 downto 26) = "01") then 
    if(instruction(20)='0') then
        if(instruction(23) = '1') then
            opcode_DP<= add;
        else
            opcode_DP<= sub;
        end if;
        end if;
else 
    opcode_DP <= oparray(to_integer(unsigned(instruction (24 downto 21))));
end if; 
    end process;

end Behavioral;