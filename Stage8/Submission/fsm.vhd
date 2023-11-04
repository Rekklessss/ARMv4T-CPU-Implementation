library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    port (
        fstate : in fstate_type;
        instruction: in word;
        instr_class: in instr_class_type;
        ldr_str: in load_store_type;
        DP_operand_src : in DP_operand_src_type;
        reset: in std_logic;
        IorD: out std_logic;
        M2R: out std_logic;
        Rsrc: out bit_pair;
        Asrc1: out bit_pair;
        Asrc2: out std_logic_vector(2 downto 0);
        Fset: out std_logic;
        RW: out std_logic;
        AW: out std_logic;
        BW: out std_logic;
        ShW: out std_logic;
        IW: out std_logic;
        DW: out std_logic;
        PW: out std_logic;
        ReW: out std_logic;
        opcode_DP : out optype;
        cin: out std_logic;
        reg_fstate: out fstate_type;
        N: in std_logic;
        V: in std_logic;
        Z: in std_logic;
        C: in std_logic;
        cond: in nibble;
        half: in std_logic;
        write_back: in std_logic;
        post_pre: in std_logic;
        mul: in std_logic;
        mult_enable: out std_logic;
        mul_acc: in std_logic;
        mul_long_short: in std_logic;
        L: in std_logic;
        ret: in std_logic;
        rte: in std_logic;
        status: in std_logic;
        swi: in std_logic;
        mem_cond_res: out std_logic;
        pc: in word
    );
end entity;

architecture beh of fsm is
type oparraytype is array (0 to 15) of optype;
constant oparray : oparraytype := (andop, eor, sub, rsb, add, adc, sbc, rsc, tst, teq, cmp, cmn, orr, mov, bic, mvn);
    begin
        process(fstate, reset, DP_operand_src, instruction, ldr_str)    
        begin   
            if (reset='1') then
                reg_fstate <= 0;
            else
                case fstate is
                    when 0 =>
                        IorD<='0';
                        M2R<='0';
                        if(instruction(27 downto 25) = "011" and instruction(4 downto 1) = "1000") then
                        	Rsrc<="11";
                        elsif(instruction (20) = '0' and instruction(27 downto 26) = "01") then
                        	Rsrc<="01";
                        elsif(instruction (20) = '0' and instruction(27 downto 25) = "000" and instruction(4) = '1' and instruction(7) = '1') then
                        	Rsrc<="01";
                        else 
                        	Rsrc<="00";
                        end if;
                        Asrc1<="00";
                        Asrc2<="001";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='1';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
						opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 1;
                       

                    when 1 =>
                        IorD<='0';
                        M2R<='0';
                        if(ldr_str = store and instr_class = DT) then
                        	Rsrc<="01";
                        else 
                        	Rsrc<="00";
                        end if;
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='1';
                        BW<='1';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='1';
                        ReW<='0';
                        cin<= '1';
                        opcode_DP<=adc;
                        mult_enable<='0';
                        reg_fstate <= 9;                        
                        
                   when 9 =>
                        IorD<='0';
                        M2R<='0';
                        if(half = '1') then
                        	Rsrc <="00";
                        elsif(instruction(4) = '1') then
                        	Rsrc<="10";
                        else 
                        	Rsrc<="00";
                        end if;
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='1';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
						opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 10;
                     
					 when 10 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        if instr_class = BRN then
                            if(ret = '1' or rte = '1') then
                                BW<='0';
                            end if;
                        elsif(instruction(27 downto 25) = "011" or instruction(27 downto 25) = "000") then
                        	BW<='1';
			            end if;
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
						opcode_DP <= oparray(to_integer(unsigned(instruction (24 downto 21))));
                        cin<= C;
                        mult_enable<='0';
                        if mul = '1' then
                            reg_fstate <= 11;
                            Asrc2<="010";        --check this
                        elsif instr_class = DP then --or if ret rte
                            reg_fstate <= 2;
                            Asrc2<="010";           --check this
                        elsif instr_class = DT then
                            reg_fstate <= 4;
                            Asrc2<="010";
                        elsif instr_class = BRN then
                            if(ret = '1' or rte = '1') then
                                reg_fstate <= 19;
                                Asrc2<="000";
                            else
                                Asrc2<="011";
                                reg_fstate <=18;
                            end if;
                        else
                            report "Reach undefined state";
                        end if;

                    when 2 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="01";
                        if(DP_operand_src= reg) then
                        	Asrc2<="000";
                        else 
                        	Asrc2<="010";
                        end if;
                        opcode_DP <= oparray(to_integer(unsigned(instruction (24 downto 21))));
                        Fset<='1';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        mult_enable<='0';
                        if(C = '1') then
                        	cin<= '1';
                        else 
                        	cin<= '0';
                        end if;
                        reg_fstate <=3;

                    when 19 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="01";
                        Asrc2<="000";
                        opcode_DP <= mov;
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        mult_enable<='0';
                        cin<= C;
                        reg_fstate <=20;

                    when 20 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        opcode_DP <= mov;
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        mult_enable<='0';
                        cin<= C;
                        reg_fstate <=0;
                          

                    when 3 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        if(instruction(24 downto 23) = "10") then --or if ret rte
                        	RW<='0';
                        else 
                        case to_integer(unsigned(cond)) is
                        	when 0 =>	RW <= Z;
                        	when 1 =>	RW <=not Z;
                               when 2 => 	RW <=C;
                               when 3 => 	RW <=not C;
                               when 4 =>	RW <=N;
                               when 5 => 	RW <=not N;
                               when 6 => 	RW <=V;
                               when 7 => 	RW <=not V;
                             	when 8 =>	RW <=C and (not Z);
                               when 9 => 	RW <=(not C) and Z;
                               when 10 => 	RW <=not(N xor V);
                               when 11 => 	RW <=N xor V;
                               when 12 => 	RW <=not(N xor V) and (not Z);
                               when 13 => 	RW <=(N xor V) and Z;
                               when 14 => 	RW <='1';
                       	when others =>	RW <='0';
                        end case;
                        end if;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        mult_enable<='0';
                        opcode_DP<=add;
                        cin<= C;
                        reg_fstate <= 0;

                    when 4 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="01";
                        Asrc2<="010";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        cin<= C;
                        mult_enable<='0';
                        if(instruction(20)='0') then        --Lbit
                            if(instruction(23) = '1') then  --Ubit
                                opcode_DP<= add;
                            else
                                opcode_DP<= sub;
                            end if;
                        end if;
                        if ldr_str = store then 
                            reg_fstate <= 5;
                        elsif ldr_str = load then
                            reg_fstate <= 6;
                        else
                            report "Reach undefined state";
                        end if;

                    when 5 =>
                        IorD<='1';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        if(write_back = '1') then
                            case to_integer(unsigned(cond)) is
                        	when 0 =>	RW <= Z;
                        	when 1 =>	RW <=not Z;
                               when 2 => 	RW <=C;
                               when 3 => 	RW <=not C;
                               when 4 =>	RW <=N;
                               when 5 => 	RW <=not N;
                               when 6 => 	RW <=V;
                               when 7 => 	RW <=not V;
                             	when 8 =>	RW <=C and (not Z);
                               when 9 => 	RW <=(not C) and Z;
                               when 10 => 	RW <=not(N xor V);
                               when 11 => 	RW <=N xor V;
                               when 12 => 	RW <=not(N xor V) and (not Z);
                               when 13 => 	RW <=(N xor V) and Z;
                               when 14 => 	RW <='1';
                       	when others =>	RW <='0';
                        end case;
                        else 
                            RW<='0';
                        end if;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        cin<= C;
                        opcode_DP<=add;
                        mult_enable<='0';
                        reg_fstate <= 0;

                        case to_integer(unsigned(cond)) is
                            when 0 =>	mem_cond_res <= Z;
                            when 1 =>	mem_cond_res <=not Z;
                               when 2 => 	mem_cond_res <=C;
                               when 3 => 	mem_cond_res <=not C;
                               when 4 =>	mem_cond_res <=N;
                               when 5 => 	mem_cond_res <=not N;
                               when 6 => 	mem_cond_res <=V;
                               when 7 => 	mem_cond_res <=not V;
                                 when 8 =>	mem_cond_res <=C and (not Z);
                               when 9 => 	mem_cond_res <=(not C) and Z;
                               when 10 => 	mem_cond_res <=not(N xor V);
                               when 11 => 	mem_cond_res <=N xor V;
                               when 12 => 	mem_cond_res <=not(N xor V) and (not Z);
                               when 13 => 	mem_cond_res <=(N xor V) and Z;
                               when 14 => 	mem_cond_res <='1';
                           when others =>	mem_cond_res <='0';
                        end case;

                    when 6 =>
                        IorD<='1';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='1';
                        PW<='0';
                        opcode_DP<=add;
                        ReW<='0';
                        cin<= C;
                        mult_enable<='0';
                        if(to_integer(unsigned(pc))<80 and status = '0') then 
                            reg_fstate <= 21;
                        else
                            reg_fstate <= 7;
                        end if;
                    
                    when 21 =>
                        IorD<='1';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='1';
                        PW<='0';
                        opcode_DP<=add;
                        ReW<='0';
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 6;

                    when 7 =>
                        IorD<='0';
                        M2R<='1';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        case to_integer(unsigned(cond)) is
                        	when 0 =>	RW <= Z;
                        	when 1 =>	RW <=not Z;
                               when 2 => 	RW <=C;
                               when 3 => 	RW <=not C;
                               when 4 =>	RW <=N;
                               when 5 => 	RW <=not N;
                               when 6 => 	RW <=V;
                               when 7 => 	RW <=not V;
                             	when 8 =>	RW <=C and (not Z);
                               when 9 => 	RW <=(not C) and Z;
                               when 10 => 	RW <=not(N xor V);
                               when 11 => 	RW <=N xor V;
                               when 12 => 	RW <=not(N xor V) and (not Z);
                               when 13 => 	RW <=(N xor V) and Z;
                               when 14 => 	RW <='1';
                       	when others =>	RW <='0';
                        end case;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        mult_enable<='0';
                        cin<= C;
                        reg_fstate <= 0;

                    when 18 =>  -- register file for bl and swi instructions
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<=L;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 8;

                    when 8 => --branch instructions
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="011";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        ReW<='0';
						opcode_DP<=adc;
                        cin<= '1';
                        PW<= '0';
                        reg_fstate <= 17;
                        mult_enable<='0';

                        

                    when 17 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        
                        ReW<='0';
                        opcode_DP<=add;
                        mult_enable<='0';
                        cin<= C;
                        reg_fstate <= 0;

                        --implement for all
                        case to_integer(unsigned(cond)) is
                        	when 0 =>	PW <= Z;
                        	when 1 =>	PW <=not Z;
                               when 2 => 	PW <=C;
                               when 3 => 	PW <=not C;
                               when 4 =>	PW <=N;
                               when 5 => 	PW <=not N;
                               when 6 => 	PW <=V;
                               when 7 => 	PW <=not V;
                             	when 8 =>	PW <=C and (not Z);
                               when 9 => 	PW <=(not C) and Z;
                               when 10 => 	PW <=not(N xor V);
                               when 11 => 	PW <=N xor V;
                               when 12 => 	PW <=not(N xor V) and (not Z);
                               when 13 => 	PW <=(N xor V) and Z;
                               when 14 => 	PW <='1';
                       	when others =>	PW <='0';
                        end case;

                    when 11 => -- read registers
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="10";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 12;
                    
                    when 12 =>  -- multiply
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="10";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= C;
                        mult_enable<='1';
                        reg_fstate <= 13;
                    
                    when 13 =>  --ALU add part 1
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="10";  --op1 is B
                        Asrc2<="100"; --op2 is Rdlo
                        if(mul_long_short = '1') then 
                            Fset<='1' ;
                        else
                            Fset<= '0';
                        end if;
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;     -- A is 19 to 16, B is 15 to 12
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 14;

                    when 14 =>      --store in register file1
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        case to_integer(unsigned(cond)) is
                        	when 0 =>	RW <= Z;
                        	when 1 =>	RW <=not Z;
                               when 2 => 	RW <=C;
                               when 3 => 	RW <=not C;
                               when 4 =>	RW <=N;
                               when 5 => 	RW <=not N;
                               when 6 => 	RW <=V;
                               when 7 => 	RW <=not V;
                             	when 8 =>	RW <=C and (not Z);
                               when 9 => 	RW <=(not C) and Z;
                               when 10 => 	RW <=not(N xor V);
                               when 11 => 	RW <=N xor V;
                               when 12 => 	RW <=not(N xor V) and (not Z);
                               when 13 => 	RW <=(N xor V) and Z;
                               when 14 => 	RW <='1';
                       	when others =>	RW <='0';
                        end case;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 15;

                    when 15 =>      --ALU add part 2
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="01"; -- op1 is A
                        Asrc2<="100"; --op2 is Rdhi
                        Fset<='1';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=adc;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 16;
                    
                    when 16 =>      --store in register file2
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<="00";
                        Asrc2<="000";
                        Fset<='0';
                        if(mul_long_short = '1') then 
                            case to_integer(unsigned(cond)) is
                        	when 0 =>	RW <= Z;
                        	when 1 =>	RW <=not Z;
                               when 2 => 	RW <=C;
                               when 3 => 	RW <=not C;
                               when 4 =>	RW <=N;
                               when 5 => 	RW <=not N;
                               when 6 => 	RW <=V;
                               when 7 => 	RW <=not V;
                             	when 8 =>	RW <=C and (not Z);
                               when 9 => 	RW <=(not C) and Z;
                               when 10 => 	RW <=not(N xor V);
                               when 11 => 	RW <=N xor V;
                               when 12 => 	RW <=not(N xor V) and (not Z);
                               when 13 => 	RW <=(N xor V) and Z;
                               when 14 => 	RW <='1';
                       	when others =>	RW <='0';
                        end case;
                        else
                            RW<= '0';
                        end if;
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        if(mul_long_short = '1') then 
                            ReW<='1' ;
                        else
                            ReW<= '0';
                        end if;
                        opcode_DP<=add;
                        cin<= C;
                        mult_enable<='0';
                        reg_fstate <= 0;

			
                    when others => 
                        report "Reach undefined state";
                end case;
            end if;
        end process;
end beh;