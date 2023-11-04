library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.ALL;

entity processor is
    port (
        reset : in std_logic := '0';
        clock : in std_logic
    );
end entity;

ARCHITECTURE beh OF processor IS

--control states
signal fstate : INTEGER RANGE 0 TO 16;
signal reg_fstate : INTEGER RANGE 0 TO 16;

--DP instructions
signal Cond : std_logic_vector (3 downto 0);
signal instr_class: instr_class_type;             --this is F
signal DP_operand_src : DP_operand_src_type;      --reg imm
signal opcode_DP : optype;                        --16 opcodes
signal DP_subclass : DP_subclass_type;            --arith logic comp test
signal S: std_logic;
signal Rd, Rn, Rm, Rs: nibble;
signal Imm: word;
signal shift1,s1: std_logic;
signal shift2,s2: std_logic;
signal shift4,s4: std_logic;
signal shift8,s8: std_logic;
signal shift16,s16: std_logic;
signal shift_mode: std_logic;
signal shift_type: bit_pair;
signal rot: std_logic_vector (4 downto 0);
signal byte_type: std_logic_vector(2 downto 0);
signal half: std_logic;
signal mul: std_logic;
signal mul_set_condcode: std_logic;
signal mul_acc: std_logic;
signal mul_long_short: std_logic;
signal mul_sign: std_logic;

--DT instructions
signal load_store : load_store_type;              --load store
signal Offset : word;

--Branch Instructions
signal Sext : std_logic_vector (5 downto 0);      --Sign extension for branch address
signal S_offset : word;

-- Register File
signal register_address1: nibble;
signal register_address2: nibble;
signal write_address_register: nibble;
signal wd: word;
signal read_register_data1: word;
signal read_register_data2: word;
signal write_data_register: word;
signal write_back: std_logic;
signal post_pre: std_logic;

--ALU
signal op1, op2, result, ex_offset, Off : word;
signal cin, cout: std_logic;
signal opcode: optype;

--pc
signal p_c: word;
signal PW: std_logic;

--control signals
signal M2R, RW, AW, BW, ShW, IW, DW, ReW, IorD, Fset: std_logic;
signal Asrc1, Rsrc: bit_pair;
signal Asrc2: std_logic_vector(2 downto 0);
signal MW: nibble;

--DM signals
signal read_memory_data,Register_input, Memory_input,write_data_memory:word;
signal memory_address: byte;

--Registers
signal IR, DR, A, B, Sh, RES: word;

--Shifter
signal carry: std_logic;
signal shift_result,op, Rm32, Rs32: word;

--flags
signal N,Z,V,C: std_logic;
signal Rd64: std_logic_vector (63 downto 0);
signal multop1, multop2: word;
signal mult_enable: std_logic;
signal mult_result: word;

--Rm = 3 downto 0
--Rd = 15 to 12
--Rs = 11 to 8

begin    

    Data: entity work.datapath port map(clock, load_store, instr_class, Sh, Imm, B, IR, op, shift_result, Offset, Off,
    rot, shift1, shift2, shift4, shift8, shift16, s1, s2, s4, s8, s16, half, shift_mode, BW, fstate, read_register_data2, 
    write_data_register, DR, RES, M2R, Rn, register_address1, write_address_register, A, AW, ShW, Rd, read_register_data1, 
    Memory_input, byte_type, write_data_memory, IW, DW, read_memory_data, ex_offset, p_c, Asrc1, op1, ReW, result, 
    Register_input, write_back, post_pre, memory_address, Rm, multop1, multop2, mult_result, Rd64, mult_enable, mul_long_short,
    mul_acc, mul);

	Finite_State_Machine: entity work.fsm port map(fstate,IR, instr_class,load_store, DP_operand_src, reset,IorD, M2R, Rsrc, 
    Asrc1, Asrc2, Fset, RW, AW, BW, ShW, IW, DW, PW, ReW, opcode_DP, cin, reg_fstate,N, V, Z, C, Cond, half, write_back, post_pre,
    mul, mult_enable, mul_acc, mul_long_short);
  
    Decoderr: entity work.decoder port map(IR, instr_class, DP_subclass, DP_operand_src, load_store, Cond, S, Rn, Rd, Rm, Imm , 
    Offset, Sext, S_offset, shift1, shift2, shift4, shift8, shift16, shift_type, Rs, shift_mode, rot, byte_type, half, write_back, 
    post_pre, mul, mul_set_condcode, mul_acc, mul_sign, mul_long_short);
     
    connect: entity work.PMconnect port map(B, Register_input, IR, byte_type, fstate, memory_address(1 downto 0), Memory_input, read_memory_data, MW);

    Memory: entity work.Mem port map(write_data_memory, p_c(7 downto 2),memory_address(7 downto 2) , MW, clock ,read_memory_data, IorD);			

    Multiplexer3: entity work.mux3 port map(Rm, Rd, Rs, register_address2, Rsrc);
    
    Register_File: entity work.RF port map(write_data_register, register_address1, register_address2, RW , clock, read_register_data1,
    read_register_data2 ,write_address_register);
    
    Shifter: entity work.shifter port map(op, s1, s2, s4, s8, s16, shift_type, carry, shift_result);

    Multiplexer: entity work.mux port map(B, "00000000000000000000000000000001", ex_offset, S_offset, mult_result, op2, Asrc2); --S_offset is the signed branch offset

    Multiply: entity work.multiplier port map(multop1,multop2, mul_sign, mult_enable,  Rd64); 

    ALUu: entity work.ALU port map(op1, op2, cin, opcode_DP, cout, result);
    
    Flag_Update: entity work.flags port map(N,V,Z,C, opcode_DP, cout, S, op1, op2, result, clock, Fset);
    
    program_counter: entity work.pc port map(reset, reg_fstate, p_c, PW, result, clock, fstate);

end beh;