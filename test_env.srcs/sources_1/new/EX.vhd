----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 08:56:07 AM
-- Design Name: 
-- Module Name: ex - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith .ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port (
        rd1: in STD_LOGIC_VECTOR(31 downto 0);
        rd2: in STD_LOGIC_VECTOR(31 downto 0);
        alusrc: in STD_LOGIC_VECTOR(1 downto 0);
        extimm: in STD_LOGIC_VECTOR(31 downto 0);
        sa: in STD_LOGIC_VECTOR(4 downto 0);
        func: in STD_LOGIC_VECTOR(5 downto 0);
        aluop: in STD_LOGIC_VECTOR(2 downto 0);
        pcp4: in STD_LOGIC_VECTOR(31 downto 0);
        zero: out STD_LOGIC;
        sign: out STD_LOGIC;
        alures: out STD_LOGIC_VECTOR(31 downto 0);
        branchaddr: out STD_LOGIC_VECTOR(31 downto 0)
    );
end EX;

architecture Behavioral of EX is
    signal aluctrl: STD_LOGIC_VECTOR(2 downto 0);
    signal a: STD_LOGIC_VECTOR(31 downto 0);
    signal b: STD_LOGIC_VECTOR(31 downto 0);
    signal c: STD_LOGIC_VECTOR(31 downto 0);
begin
    
    a <= rd1;
    with alusrc select
             b <= rd2 when "00",
                  extimm when "01",
                  X"00000000" when others;
    
    control: process(aluop, func)
    begin
        case aluop is
            when "000" => --codR
                case func is
                    when "100000" => aluctrl <= "001"; --cod+
                    when "100010" => aluctrl <= "010"; --cod-
                    when "100101" => aluctrl <= "011"; --cod |
                    when "100100" => aluctrl <= "100"; --cod &
                    when "000000" => aluctrl <= "101"; --cod <
                    when "000010" => aluctrl <= "110"; --cod >
                    when "100110" => aluctrl <= "111"; --cod xor
                    when "000011" => aluctrl <= "000"; --cod sra
                    when others => aluctrl <= (others => 'X');
                end case;
            when "001" => aluctrl <= "001"; --cod+
            when "010" => aluctrl <= "010"; --cod-
            when "011" => aluctrl <= "011"; --cod |
            when "100" => aluctrl <= "100"; --cod &
            when others => aluctrl <= (others => 'X');
        end case;
    end process;
    
    
    process(a, b, aluctrl, sa)
    begin
        case aluctrl is
            when "000" => c <= to_stdlogicvector(to_bitvector(b) sra conv_integer(a));
            when "001" => c <= a + b;
            when "010" => c <= a - b;
            when "011" => c <= a or b;
            when "100" => c <= a and b;
            when "101" => c <= to_stdlogicvector(to_bitvector(b) sll conv_integer(a));
            when "110" => c <= to_stdlogicvector(to_bitvector(b) srl conv_integer(a));
            when "111" => c <= a xor b;
            when others => c <= (others => 'X');
        end case;
    end process;
    alures <= c;
    sign <= c(31);
    zero <= '1' when c = X"00000000" else '0';
    branchaddr <= (extimm(29 downto 0) & "00") + pcp4;

end Behavioral;