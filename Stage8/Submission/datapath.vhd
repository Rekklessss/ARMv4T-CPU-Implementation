library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
 Port  (
 		clock: in std_logic;
 		load_store: in load_store_type;
 		instr_class: in instr_class_type;
        Sh: inout word;
        Imm: in word;
        B: inout word;
   		IR: inout word;
    	op: out word;
        shift_result: in word;
        Offset: in word;
        Off: inout word;
        rot: in std_logic_vector (4 downto 0);
        shift1: in std_logic;
        shift2: in std_logic;
        shift4: in std_logic;
        shift8: in std_logic;
        shift16: in std_logic;
        s1: out std_logic;
        s2: out std_logic;
        s4: out std_logic;
        s8: out std_logic;
        s16: out std_logic;
        half: in std_logic;
        shift_mode: in std_logic;
        BW: in std_logic;
        fstate: in integer;
        rd2: in word;
        write_data_register: out word;
        DR: inout word;
        RES: inout word;
        M2R: in std_logic;
        Rn: in nibble;
        rad1: out nibble;
        wad: out nibble;
        A: inout word;
        AW: in std_logic;
        ShW: in std_logic;
        Rd: in nibble;
        rd1: in word;
        Memory_input: in word;
        byte_type: in std_logic_vector(2 downto 0);
        write_data_memory: out word;
        IW: in std_logic;
        DW: in std_logic;
        read_memory_data: in word;
        ex_offset: out word;
        p_c: in word;
        Asrc1: in bit_pair;
        op1: out word;
        ReW: in std_logic;
        result: in word;
        Register_input: in word;
        write_back: in std_logic;
        post_pre: in std_logic;
        memory_address: inout std_logic_vector(8 downto 0);
        Rm: in nibble;
        multop1: out word;
        multop2: out word;
        mult_result: inout word;
        Rd64: in std_logic_vector(63 downto 0);
        mult_enable: in std_logic;
        mul_long_short: in std_logic;
        mul_acc: in std_logic;
        mul: in std_logic;
        pc: in word;
        swi: in std_logic;
        ret: in std_logic;
        rte: in std_logic;
        mode: in std_logic;
        input_data: in word;
        Mem_input: out word
    );
 end entity;

architecture beh of datapath is
    signal Reg_rd64: std_logic_vector(63 downto 0);

begin 


    --setting operand of shifter
    process(clock)
    begin
        if(load_store = store and instr_class = DT) then
            op<=Sh;
        elsif(IR(25) = '1' and instr_class = DP) then
            op<=Imm;
        else 
            op<=B;
        end if;
    end process;




    --setting Offset
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




    --setting shifts
    process(clock)
    begin
    if(IR(27 downto 25) = "001") then
    	s1<=rot(0);
        s2<=rot(1);
        s4<=rot(2);
        s8<=rot(3);
        s16<=rot(4);
    elsif(half = '1') then
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




    --setting register B
    process(BW)
    begin
    if(BW='1' and fstate = 1) then
    	B<=rd2;
    elsif(BW='1' and fstate = 10 and instr_class /= DT) then
    	B<=shift_result;
    end if;
    end process;



    --setting data to be written in memory
    process(byte_type,B,Memory_input)
    begin
    	if(byte_type="000") then
    		write_data_memory <=B;
        else
         	write_data_memory <= Memory_input;
        end if;
    end process;

    memory_address<= A(8 downto 0) when post_pre = '0' else RES(8 downto 0);



    --storing data read from memory
    IR<=read_memory_data when IW = '1';
    DR<=Register_input when DW = '1';

    Mem_input <= "000000000000000000000000"&input_data(7 downto 0) when memory_address = "001110000" and mode = '1' else read_memory_data;

    --for register file
    process(DR, M2R, RES, pc, fstate)
    begin
        if(fstate = 18) then
            write_data_register<= pc;
        elsif(M2R = '1') then 
            write_data_register<= DR;
        else
            write_data_register<= RES;
        end if;
    end process;

    rad1<=Rm when fstate = 11 or fstate = 12 else Rn; --19 to 16
    A<=rd1 when AW = '1';
    Sh<=rd2 when ShW = '1';

    process(fstate, write_back)
    begin

    if(write_back = '1' and fstate = 5) then
        wad<=Rn;
    elsif(fstate =18) then
        wad<="1110";
    elsif(fstate =16) then
        wad<=Rn;
    elsif(mul_long_short = '0' and mul = '1') then
        wad<= Rn;
    else
        wad<=Rd;
    end if;
    end process;



    --storing the required offset
    ex_offset<=shift_result when instr_class = DP else Off;



    --ALU
    process(Asrc1, p_c)
    begin 
    if(Asrc1 = "00") then
        op1<="00"&p_c(31 downto 2);
    elsif(Asrc1 = "01") then
        op1<=A;
    else
        op1<=B;
    end if;
    end process;

    process(ReW,fstate)
    begin
        if(ReW = '1') then
            if(mul_acc = '0' and fstate = 13) then
                RES<= mult_result;
            elsif(mul_acc = '0' and fstate = 14) then
                RES<= mult_result;
            elsif(mul_acc = '0' and fstate = 15) then
                RES<= mult_result;
            elsif(mul_acc = '0' and fstate = 16) then
                RES<= mult_result;
            else
                RES<= result;
            end if;
        end if;
    end process;

    --multiplier
    multop1<= rd1;
    multop2<= rd2;

    Reg_rd64<=Rd64 when mult_enable = '1';
    mult_result<= Reg_rd64(63 downto 32) when fstate = 15 or fstate = 16 else Reg_rd64(31 downto 0);

end architecture;