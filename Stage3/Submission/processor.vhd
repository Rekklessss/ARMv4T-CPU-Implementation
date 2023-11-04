library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MyTypes.all;


entity processor is
port(
	clock: in std_logic
  );
end entity;

architecture behavior of processor is

signal N,Z,V,C: std_logic;


--DP instructions
signal Cond : std_logic_vector (3 downto 0);
signal instr_class: instr_class_type;             --this is F
signal DP_operand_src : DP_operand_src_type;      --reg imm
signal opcode_DP : optype;                        --16 opcodes
signal DP_subclass : DP_subclass_type;            --arith logic comp test
signal S: std_logic;
signal Rd, Rn, Rm : nibble;
signal Imm : std_logic_vector (7 downto 0);

--DT instructions
signal opcode_DT : std_logic_vector (5 downto 0);
signal Ubit : std_logic;
signal Lbit : std_logic;
signal load_store : load_store_type;              --load store
signal DT_offset_sign : DT_offset_sign_type;     --Plus minus
signal Offset : std_logic_vector (11 downto 0);

--Branch Instructions
signal Sext : std_logic_vector (5 downto 0);      --Sign extension for branch address
signal S_offset : std_logic_vector (23 downto 0);
signal Psrc:  std_logic;

--PC 
signal instruction : word;

-- Register File
signal rad1: nibble;
signal rad2: nibble;
signal wad: nibble;
signal wd: word;
signal rd1: word;
signal rd2: word;
signal write_data: word;

--ALU
signal op1, op2, res : word;
signal cin, cout: std_logic;
signal opcode: optype;
signal Fset: std_logic;

--pc
signal p_c: word;
signal PW: std_logic;


--control signals
signal Rsrc, Asrc, M2R, RW: std_logic;

--DM signals
signal ad:STD_LOGIC_VECTOR(5 DOWNTO 0);
signal read_data:word;
signal write: nibble;

begin
  
  -- Extracting PM address from PC and getting the instruction
  Program_Memory: entity work.IM PORT MAP(p_c(7 downto 2), instruction);
  
  Decoderr: entity work.decoder port map(instruction, instr_class, opcode_DP, DP_subclass, DP_operand_src, load_store,
                          DT_offset_sign , Cond, S, Rn, Rd, Rm, Imm , opcode_DT, Ubit, Lbit, Offset, Sext, S_offset,
                          Rsrc, Asrc, M2R, RW, write);
  --now I have separated my instruction into all the small components i need

  rad1<=Rn;
  rad2<=Rm when (Rsrc = '0') else Rd;
  wad<=Rd;
 write_data<=res when M2R = '0' else read_data;

  Register_File: entity work.RF port map(write_data, rad1, rad2, RW , clock, rd1, rd2 ,wad);
--RW loadstore

  --inputs to ALU
  op2<=rd2 when(Asrc = '0') else x"00000" & Offset;
  cin<='0';
  ALUu: entity work.ALU port map(rd1, op2, cin, opcode_DP, cout, res);

  --inputs to flag checker
  Flag_Update: entity work.flags port map(N,V,Z,C, opcode_DP, cout, S, rd1, op2, res, clock);

  --condn chck
  Condition_Checker: entity work.condition port map(N,V,Z,C,Cond,Psrc,instr_class);

  ad<= res(7 downto 2);
  Data_Memory: entity work.DM port map(rd2, ad, write, clock ,read_data);
  
  Program_Counter: entity work.pc port map(S_offset, Psrc, clock, p_c);

end behavior;