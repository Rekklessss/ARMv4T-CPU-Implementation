library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    port (
        fstate : in INTEGER RANGE 0 TO 10;
        instruction: in word;
        instr_class: in instr_class_type;
        ldr_str: in load_store_type;
        DP_operand_src : in DP_operand_src_type;
        reset: in std_logic;
        IorD: out std_logic;
        M2R: out std_logic;
        Rsrc: out bit_pair;
        Asrc1: out std_logic;
        Asrc2: out bit_pair;
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
        reg_fstate: out INTEGER RANGE 0 TO 10;
         N: in std_logic;
         V: in std_logic;
         Z: in std_logic;
         C: in std_logic;
         cond: in nibble;
         half: in std_logic
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
                        Rsrc<="01" when ldr_str = store and instr_class = DT else "00";
                        Asrc1<='0';
                        Asrc2<="01";
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
                        reg_fstate <= 1;
                       

                    when 1 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="01" when ldr_str = store and instr_class = DT else "00";
                        Asrc1<='0';
                        Asrc2<="00";
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
                        Asrc1<='0';
                        Asrc2<="00";
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
                        reg_fstate <= 10;
                     
					 when 10 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='1' when instruction(27 downto 25) = "011" or instruction(27 downto 25) = "000";
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
						opcode_DP<=add;
                        cin<= C;
                        if instr_class = DP then 
                            reg_fstate <= 2;
                            Asrc2<="10";
                        elsif instr_class = DT then
                            reg_fstate <= 4;
                            Asrc2<="10";
                        elsif instr_class = BRN then
                        	Asrc2<="11";
                            reg_fstate <=8;
                        else
                            report "Reach undefined state";
                        end if;

                    when 2 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='1';
                        if(DP_operand_src= reg) then
                        	Asrc2<="00";
                        else 
                        	Asrc2<="10";
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
                        cin<= '1' when C = '1' else '0';
                        reg_fstate <=3;

                    when 3 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0' when instruction(24 downto 23) = "10" else '1';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= C;
                        reg_fstate <= 0;

                    when 4 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='1';
                        Asrc2<="10";
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
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        cin<= C;
                        opcode_DP<=add;
                        reg_fstate <= 0;

                    when 6 =>
                        IorD<='1';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='0';
                        Asrc2<="00";
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
                        reg_fstate <= 7;

                    when 7 =>
                        IorD<='0';
                        M2R<='1';
                        Rsrc<="00";
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='1';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= C;
                        reg_fstate <= 0;

                    when 8 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<="00";
                        Asrc1<='0';
                        Asrc2<="11";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        ShW<='0';
                        IW<='0';
                        DW<='0';
                        ReW<='0';
						opcode_DP<=adc;
                        cin<= C;
                        reg_fstate <= 0;
                        with to_integer(unsigned(cond)) select
                        		PW <= Z when 0,
                        		not Z when 1,
                                C when 2,
                                not C when 3,
                                N when 4,
                                not N when 5,
                                V when 6,
                                not V when 7,
                             	C and (not Z) when 8,
                                (not C) and Z when 9,
                                not(N xor V) when 10,
                                N xor V when 11,
                                not(N xor V) and (not Z) when 12,
                                (N xor V) and Z when 13,
                                '1' when 14,
                       			'0' when others;

                    when others => 
                        report "Reach undefined state";
                end case;
            end if;
        end process;
end beh;