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

component decoder is
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
    PW: out std_logic;
    Fset: out std_logic
    );
end component;

component alu is 
port(
  op1: in word;
  op2: in word;
  cin: in std_logic;
  opcode: in optype;
  cout: out std_logic;
  res: out word
  );
end component;

component RF is
  PORT(
       datain : IN word;
       add_in1 : IN nibble;
       add_in2 : IN nibble;
       -- Write when 0, Read when 1
       w_r : IN STD_LOGIC;
       clk: in std_logic;
       data_out1 : out word;
       data_out2 : out word;
       add_out : in nibble
       );
END component;

component DM is
  PORT(
       DATAIN : IN word;
       ADDRESS : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
       write : IN nibble;
       clk : in std_logic;
       DATAOUT : OUT word
       );
END component;

component IM is
  PORT(
       ADDRESS : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
       DATAOUT : OUT word
       );
END component;

component flags is
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
  end component;

component condition is
  port(
    N: in std_logic;
    V: in std_logic;
    Z: in std_logic;
    C: in std_logic;
    cond: in nibble;
    result: out std_logic;
    instr_class: in instr_class_type
    );
end component;

component pc is
  port(
    offset: in std_logic_vector(23 downto 0);
    Psrc: in std_logic;
    clk: in std_logic;
    pc: out word
    );
  end component;


begin
  
  -- Extracting PM address from PC and getting the instruction
  Program_Memory: IM PORT MAP(p_c(7 downto 2), instruction);
  Decoderr: decoder port map(instruction, instr_class, opcode_DP, DP_subclass, DP_operand_src, load_store,
                          DT_offset_sign , Cond, S, Rn, Rd, Rm, Imm , opcode_DT, Ubit, Lbit, Offset, Sext, S_offset,
                          Rsrc, Asrc, M2R, RW, write);
  --now I have separated my instruction into all the small components i need
  --write address is the Rd
  --read address 1 is Rn
  --read address 2 is either Rm or Rd
  --need to think of a signal for datain, w_r, dataout12


  rad1<=Rn;
  rad2<=Rm when (Rsrc = '0') else Rd;
  wad<=Rd;
 write_data<=res when M2R = '0' else read_data;

  Register_File: RF port map(write_data, rad1, rad2, RW , clock, rd1, rd2 ,wad);
--RW loadstore

  --inputs to ALU
  op2<=rd2 when(Asrc = '0') else x"00000" & Offset;
  cin<='0';
  ALUu: ALU port map(rd1, op2, cin, opcode_DP, cout, res);

  --inputs to flag checker
  Flag_Update: flags port map(N,V,Z,C, opcode_DP, cout, S, rd1, op2, res, clock);

  --condn chck
  Condition_Checker: condition port map(N,V,Z,C,Cond,Psrc,instr_class);

  -- Data memory address
  --DMadr32 <= (signed(RF(Rn)) + signed(X"00000" & Offset)) when (Ubit = '1')
  --else (signed(RF(Rn)) - signed(X"00000" & Offset));
  --ad <= to_integer(DMadr32(7 downto 2));
  ad<= res(7 downto 2);
  Data_Memory: DM port map(rd2, ad, write, clock ,read_data);
  
  Program_Counter: pc port map(S_offset, Psrc, clock, p_c);

end behavior;

