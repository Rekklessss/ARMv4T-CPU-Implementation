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
    DT_offset_sign : out DT_offset_sign_type;
    Cond :out nibble;
    S: out std_logic;
    Rn : out nibble;
    Rd : out nibble;
    Rm : out nibble;
    Imm : out word;
    opcode_DT: out std_logic_vector(5 downto 0);
    Ubit: out std_logic;
    Lbit: out std_logic;
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
    rot: out std_logic_vector (4 downto 0)
    );
end Decoder;

architecture Behavioral of Decoder is

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
Imm <= "000000000000000000000000" & instruction(7 downto 0);
rot<= instruction(11 downto 8) & '0';
opcode_DT<= instruction(25 downto 20);
Ubit<= instruction(23);
Lbit<= instruction(20);
Offset<= "00000000000000000000" & instruction(11 downto 0);
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

end Behavioral;