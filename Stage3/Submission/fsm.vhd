library ieee;
use ieee.std_logic_1164.all;
use work.Mytypes.all;
use IEEE.NUMERIC_STD.ALL;

entity fsm is
    port (
        fstate : in INTEGER RANGE 0 TO 8;
        instruction: in word;
        ldr_str: in load_store_type;
        DP_operand_src : in DP_operand_src_type;
        reset: in std_logic;
        IorD: out std_logic;
        M2R: out std_logic;
        Rsrc: out std_logic;
        Asrc1: out std_logic;
        Asrc2: out bit_pair;
        Fset: out std_logic;
        RW: out std_logic;
        AW: out std_logic;
        BW: out std_logic;
        MW: out nibble;
        IW: out std_logic;
        DW: out std_logic;
        PW: out std_logic;
        ReW: out std_logic;
        opcode_DP : out optype;
        cin: out std_logic;
        reg_fstate: out INTEGER RANGE 0 TO 8;
         N: in std_logic;
         V: in std_logic;
         Z: in std_logic;
         C: in std_logic;
         cond: in nibble
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
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="01";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='1';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
						opcode_DP<=add;
                        cin<= '0';
                        reg_fstate <= 1;
                                   
                    when 1 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<='1' when ldr_str = store and instruction (27 downto 26) = "01" else '0';
                        Asrc1<='0';
                        Asrc2<="11";
                        Fset<='0';
                        RW<='0';
                        AW<='1';
                        BW<='1';
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        PW<='1';
                        ReW<='0';
                        cin<= '1';
                        opcode_DP<=adc;
                        if instruction (27 downto 26) = "00" then 
                            reg_fstate <= 2;
                        elsif instruction (27 downto 26) = "01" then
                            reg_fstate <= 4;
                        elsif instruction (27 downto 26) = "10" then
                            reg_fstate <=8;
                        else
                            report "Reach undefined state";
                        end if;

                    when 2 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<='0';
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
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        cin<= '0';
                        reg_fstate <=3;

                    when 3 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0' when instruction(24 downto 23) = "10" else '1';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= '0';
                        reg_fstate <= 0;

                    when 4 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<='0';
                        Asrc1<='1';
                        Asrc2<="10";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='1';
                        cin<= '0';
                        if(instruction(20)='0') then
                            if(instruction(23) = '1') then
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
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        MW<="1111";
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        cin<= '0';
                        opcode_DP<=add;
                        reg_fstate <= 0;

                    when 6 =>
                        IorD<='1';
                        M2R<='0';
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='0';
                        DW<='1';
                        PW<='0';
                        opcode_DP<=add;
                        ReW<='0';
                        cin<= '0';
                        reg_fstate <= 7;

                    when 7 =>
                        IorD<='0';
                        M2R<='1';
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="00";
                        Fset<='0';
                        RW<='1';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        PW<='0';
                        ReW<='0';
                        opcode_DP<=add;
                        cin<= '0';
                        reg_fstate <= 0;

                    when 8 =>
                        IorD<='0';
                        M2R<='0';
                        Rsrc<='0';
                        Asrc1<='0';
                        Asrc2<="11";
                        Fset<='0';
                        RW<='0';
                        AW<='0';
                        BW<='0';
                        MW<="0000";
                        IW<='0';
                        DW<='0';
                        ReW<='0';
						opcode_DP<=adc;
                        cin<= '0';
                        reg_fstate <= 0;
                        with to_integer(unsigned(cond)) select
                        		PW <= Z when 0,
                        		not Z when 1,
                               '1' when 14,
                       			'0' when others;

                    when others => 
                        report "Reach undefined state";
                end case;
            end if;
        end process;
end beh;