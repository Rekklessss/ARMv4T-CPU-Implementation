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
    signal fstate : INTEGER RANGE 0 TO 10;
    signal reg_fstate : INTEGER RANGE 0 TO 10;

--DP instructions
signal Cond : std_logic_vector (3 downto 0);
signal instr_class: instr_class_type;             --this is F
signal DP_operand_src : DP_operand_src_type;      --reg imm
signal opcode_DP : optype;                        --16 opcodes
signal DP_subclass : DP_subclass_type;            --arith logic comp test
signal S: std_logic;
signal Rd, Rn, Rm, Rs: nibble;
signal Imm, const: word;
signal shift1,s1: std_logic;
signal shift2,s2: std_logic;
signal shift4,s4: std_logic;
signal shift8,s8: std_logic;
signal shift16,s16: std_logic;
signal shift_mode: std_logic;
signal shift_type: bit_pair;
signal rot: std_logic_vector (4 downto 0);
signal byte_type: std_logic_vector(2 downto 0);

--DT instructions
signal load_store : load_store_type;              --load store
signal Offset : word;

--Branch Instructions
signal Sext : std_logic_vector (5 downto 0);      --Sign extension for branch address
signal S_offset : word;

-- Register File
signal rad1: nibble;
signal rad2: nibble;
signal wad: nibble;
signal wd: word;
signal rd1: word;
signal rd2: word;
signal write_data: word;

--ALU
signal op1, op2, result, ex_offset, Off : word;
signal cin, cout: std_logic;
signal opcode: optype;
signal Fset: std_logic;

--pc
signal p_c, Rin, Min,wrt_data: word;
signal PW: std_logic;

--control signals
signal M2R, RW, Asrc1, AW, BW, ShW, IW, DW, ReW, IorD: std_logic;
signal Asrc2, Rsrc: bit_pair;
signal MW: nibble;

--DM signals
signal read_data:word;

--Registers
signal IR, DR, A, B, Sh, RES: word;

--Shifter
signal carry: std_logic;
signal shift_result,op: word;

--flags
signal N,Z,V,C: std_logic;
signal half: std_logic;


BEGin    


	Finite_State_Machine: entity work.fsm port map(fstate,IR, instr_class,load_store, DP_operand_src, reset,IorD, M2R, Rsrc, Asrc1, Asrc2, Fset, RW, AW, BW, ShW, IW, DW, PW, ReW, opcode_DP, cin, reg_fstate,N, V, Z, C, Cond, half);
    --all the control signals are specified and reg_fstate stores the next state;
    
    
      Decoderr: entity work.decoder port map(IR, instr_class, DP_subclass, DP_operand_src, load_store, Cond, S, Rn, Rd, Rm, Imm , Offset, Sext, S_offset, shift1, shift2, shift4, shift8, shift16, shift_type, Rs, shift_mode, rot, byte_type, half);
       
     
    connect: entity work.PMconnect port map(B, Rin, IR, byte_type, fstate, RES(1 downto 0), Min, read_data, MW);
    
    --make a process for write data of memory. check wrt byte_type and store respective data.
    
    process(byte_type,B,Min)
    begin
    	if(byte_type="00") then
    		wrt_data <=B;
        else
         	wrt_data <= Min;
        end if;
    end process;
    
    Memory: entity work.Mem port map(wrt_data, p_c(7 downto 2),RES(7 downto 2) , MW, clock ,read_data, IorD);			
    IR<=read_data when IW = '1';
    process(read_data)
    begin
    	if(DW = '1') then
    		DR<=read_data;
        end if;
	end process;

    
    
    
    Multiplexer3: entity work.mux3 port map(Rm, Rd, Rs, rad2, Rsrc);
    
    
    
    write_data<= DR when M2R='1' else RES;
    rad1<=Rn;
    wad<=Rd;
    Register_File: entity work.RF port map(write_data, rad1, rad2, RW , clock, rd1, rd2 ,wad);		--done
    A<=rd1 when AW = '1';
    Sh<=rd2 when ShW = '1';
    
    
    process(BW)
    begin
    if(BW='1' and fstate = 1) then
    	B<=rd2;
    elsif(BW='1' and fstate = 10 and instr_class /= DT) then
    	B<=shift_result;
    end if;
    end process;
    
    process(clock)
    begin
    if(IR(27 downto 25) = "001") then
    	s1<=rot(0);
        s2<=rot(1);
        s4<=rot(2);
        s8<=rot(3);
        s16<=rot(4);
    elsif(IR(27 downto 26) = "00" and IR(4) = '1' and IR(7) = '1') then
    	s1<='0';
        s2<='0';
        s4<='0';
        s8<='0';
        s16<='0';
    elsif(shift_mode='1') then
    	s1<=Sh(0);
        s2<=Sh(1);
        s4<=Sh(2);
        s8<=Sh(3);
        s16<=Sh(4);
    else
    	s1<=shift1;
        s2<=shift2;
        s4<=shift4;
        s8<=shift8;
        s16<=shift16;   
    end if;
    end process;
    
    process(clock)
    begin
    if(load_store = store and instr_class = DT) then
    	op<=Sh;
    elsif(IR(27 downto 25) = "001") then
    	op<=Imm;
    else 
    	op<=B;
    end if;
    end process;
    
    Shifter: entity work.shifter port map(op, s1, s2, s4, s8, s16, shift_type, carry, shift_result);
    
    --B<=shift_result when BW = '1' and fstate = 10;
    
    process(clock)
    begin
    if(IR(27 downto 26) = "01" and IR(25) = '0') then
    	Off<=Offset;
    elsif(instr_class = DT and IR(25) = '0' and IR(22) = '1') then
    	Off<=Offset;
    elsif(instr_class = DT and IR(25) = '0' and IR(22) = '0') then
    	Off<=shift_result;
    else
    	Off<=shift_result;
    end if;
    end process;
    
    --Off<= Offset when instr_class = DT and IR(25)='0' else shift_result;
    const<= shift_result;
    ex_offset<=shift_result when instr_class = DP else Off;
    Multiplexer: entity work.mux port map(B, "00000000000000000000000000000001", ex_offset, S_offset, op2, Asrc2); --S_offset is the signed branch offset

    op1<="00"&p_c(31 downto 2) when Asrc1='0' else A;
    ALUu: entity work.ALU port map(op1, op2, cin, opcode_DP, cout, result);

    RES<= result when ReW = '1';
    
    Flag_Update: entity work.flags port map(N,V,Z,C, opcode_DP, cout, S, op1, op2, result, clock, Fset);
    
    process(reset,reg_fstate)
    begin
    
    if(reset='1') then
           p_c<=x"00000000";
    elsif(PW='1') then
            p_c<=result(29 downto 0)&"00";
     end if;
    end process;
    process (clock)
    BEGin
        
        if (rising_edge(clock)) then
            fstate <= reg_fstate;
         end if;
        
    end process;

end beh;