----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2025 08:42:24 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
    Port (
        instr_opcode: in STD_LOGIC_VECTOR(5 downto 0);
        regdst: out STD_LOGIC;
        extop: out STD_LOGIC;
        alusrc: out STD_LOGIC_VECTOR(1 downto 0);
        branch: out STD_LOGIC;
        bgez: out STD_LOGIC;
        jump: out STD_LOGIC;
        aluop: out STD_LOGIC_VECTOR(2 downto 0);
        memwrite: out STD_LOGIC;
        memtoreg: out STD_LOGIC;
        regwrite: out STD_LOGIC
    );
end UC;

architecture Behavioral of UC is

begin
    process(instr_opcode)
    begin
        case instr_opcode is
            when "000000" => --instructiune R 
                regdst <= '1';
                regwrite <= '1';
                aluop <= "000";
                memtoreg <= '0';
                alusrc <= "00";
                memwrite <= '0';
                jump <= '0';
                branch <= '0';
                bgez <= '0';
            when "001000" => --ADDI
                extop <= '1';
                regwrite <= '1';
                aluop <= "001";
                memwrite <= '0';
                jump <= '0';
                branch <= '0';
                alusrc <= "01";
                memtoreg <= '0';
                regdst <= '0';
                bgez <= '0';
            when "100011" => --LW
                extop <= '1';
                memtoreg <= '1';
                regwrite <= '1';
                aluop <= "001";
                alusrc <= "01";
                memwrite <= '0';
                jump <= '0';
                branch <= '0';
                regdst <= '0';
                bgez <= '0';
            when "000100" => --BEQ
                extop <= '1';
                alusrc <= "01";
                aluop <= "010";
                jump <= '0';
                branch <= '1';
                memwrite <= '0';
                regwrite <= '0'; 
                bgez <= '0';
            when "000010" => --J
                jump <= '1';
                memwrite <= '0';
                regwrite <= '0'; 
            when "101011" => --SW
                extop <= '1';
                memwrite <= '1';
                regwrite <= '0';
                memtoreg <= '1';
                aluop <= "001";
                jump <= '0';
                branch <= '0';
                alusrc <= "01";
                bgez <= '0';
            when "000001" => --bgez
                extop <= '1';
                alusrc <= "10";
                bgez <= '1';
                branch <= '0';
                memwrite <= '0';
                regwrite <= '0';
                aluop <= "010";
                jump <= '0';
            when "001100" => --andi
                extop <= '1';
                alusrc <= "10";
                bgez <= '0';
                memwrite <= '0';
                memtoreg <= '0';
                branch <= '0';
                regwrite <= '1';
                aluop <= "100";
                jump <= '0';
            when "001101" => --ori
                extop <= '1';
                alusrc <= "10";
                bgez <= '0';
                memwrite <= '0'; 
                memtoreg <= '0';
                regwrite <= '1';
                aluop <= "011";
                jump <= '0';
                branch <= '0';
            when others =>  regdst<='0';
                            extop<='0';
                            alusrc<="00";
                            branch<='0';
                            bgez<='0';
                            jump<='0';
                            aluop<="000";
                            memwrite<='0';
                            memtoreg<='0';
                            regwrite<='0';
        end case;
    end process;
end Behavioral;