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
    signal fstate : INTEGER RANGE 0 TO 8;
    signal reg_fstate : INTEGER RANGE 0 TO 8;

--DP instructions
signal Cond : std_logic_vector (3 downto 0);
signal instr_class: instr_class_type;             --this is F
signal DP_operand_src : DP_operand_src_type;      --reg imm
signal opcode_DP : optype;                        --16 opcodes
signal DP_subclass : DP_subclass_type;            --arith logic comp test
signal S: std_logic;
signal Rd, Rn, Rm : nibble;
signal Imm : word;

--DT instructions
signal opcode_DT : std_logic_vector (5 downto 0);
signal Ubit : std_logic;
signal Lbit : std_logic;
signal load_store : load_store_type;              --load store
signal DT_offset_sign : DT_offset_sign_type;     --Plus minus
signal Offset : word;

--Branch Instructions
signal Sext : std_logic_vector (5 downto 0);      --Sign extension for branch address
signal S_offset : word;

--PC 
signal instruction : word;
signal p_c, pc_copy: word;

-- Register File
signal rad1: nibble;
signal rad2: nibble;
signal wad: nibble;
signal wd: word;
signal rd1: word;
signal rd2: word;
signal write_data: word;

--ALU
signal op1, op2, result, ex_offset : word;
signal cin, cout: std_logic;
signal opcode: optype;
signal Fset: std_logic;

--pc
--signal p_c: word;
signal PW: std_logic;


--control signals
signal Rsrc, M2R, RW, Asrc1, AW, BW, IW, DW, ReW, IorD: std_logic;
signal Asrc2: bit_pair;
signal MW: nibble;
--DM signals

signal read_data:word;
signal write: nibble;

--Registers
signal IR, DR, A, B, RES: word;

signal N,Z,V,C: std_logic;
BEGin    
	Finite_State_Machine: entity work.fsm port map(fstate,IR, load_store, DP_operand_src, reset, 
                                                    IorD, M2R, Rsrc, Asrc1, Asrc2, Fset, RW, AW, BW, MW, 
                                                    IW, DW, PW, ReW, opcode_DP, cin, reg_fstate,N, V, Z, C, Cond);
    --all the control signals are specified and reg_fstate stores the next state;
      Decoderr: entity work.decoder port map(IR, instr_class, DP_subclass, DP_operand_src, load_store,
                          DT_offset_sign , Cond, S, Rn, Rd, Rm, Imm , opcode_DT, Ubit, Lbit, Offset, Sext, S_offset);
       
     
    Memory: entity work.Mem port map(B, p_c(7 downto 2),RES(7 downto 2) , MW, clock ,read_data, IorD);			--done
    IR<=read_data when IW = '1';
    DR<=read_data when DW = '1';

    write_data<= DR when M2R='1' else RES;
    rad1<=Rn;
    rad2<=Rm when (Rsrc = '0') else Rd;
    wad<=Rd;
    Register_File: entity work.RF port map(write_data, rad1, rad2, RW , clock, rd1, rd2 ,wad);		--done
    A<=rd1 when AW = '1';
    B<=rd2 when BW = '1';
    
    ex_offset<=Imm when instr_class = DP else Offset;
    Multiplexer: entity work.mux port map(B, "00000000000000000000000000000001", ex_offset, S_offset, op2, Asrc2); --S_offset is the signed branch offset

    op1<="00"&p_c(31 downto 2) when Asrc1='0' else A;
    ALUu: entity work.ALU port map(op1, op2, cin, opcode_DP, cout, result);

    RES<= result when ReW = '1';
    --pc_copy<=result(29 downto 0)&"00" when PW = '1';
    
    Flag_Update: entity work.flags port map(N,V,Z,C, opcode_DP, cout, S, op1, op2, result, clock, Fset);
    
    process(reset,reg_fstate)
    begin
    
    if(reset='1') then
           p_c<=x"00000000";
           pc_copy<=x"00000000";
    elsif(PW='1') then
            p_c<=result(29 downto 0)&"00";
            pc_copy<=result(29 downto 0)&"00";
    else
    	p_c<=pc_copy;
     end if;
    end process;
    process (clock)
    BEGin
        
        if (rising_edge(clock)) then
            fstate <= reg_fstate;
         end if;
        
    end process;

end beh;