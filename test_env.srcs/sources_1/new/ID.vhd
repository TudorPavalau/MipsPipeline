----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2025 08:15:17 AM
-- Design Name: 
-- Module Name: ID - Behavioral
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
    
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    port (
        clk: in STD_LOGIC;
        regwrite: in STD_LOGIC;
        instr: in STD_LOGIC_VECTOR(25 downto 0);
        regdst: in STD_LOGIC;
        en: in STD_LOGIC;
        extop: in STD_LOGIC;
        wd: in STD_LOGIC_VECTOR(31 downto 0);
        rd1: out STD_LOGIC_VECTOR(31 downto 0);
        rd2: out STD_LOGIC_VECTOR(31 downto 0);
        extimm: out STD_LOGIC_VECTOR(31 downto 0);
        func: out STD_LOGIC_VECTOR(5 downto 0);
        sa: out STD_LOGIC_VECTOR(4 downto 0);
        reg7: out STD_LOGIC_VECTOR(31 downto 0)
    );
end ID;

architecture Behavioral of ID is
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : reg_array:= (X"00000000",
                                   X"0000000"& "0001",
                                   others => X"00000000");
    
    signal ra1: STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal ra2: STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal wa: STD_LOGIC_VECTOR(4 downto 0) := "00000";    
begin
    ra1 <= instr(25 downto 21);
    ra2 <= instr(20 downto 16);
    wa <= instr(20 downto 16) when regdst = '0' else instr(15 downto 11);
    
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and regwrite = '1' then
                reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;
    
    extimm(15 downto 0) <= instr(15 downto 0);
    extimm(31 downto 16) <= (others => instr(15)) when extop = '1' else x"0000";
    
    rd1 <= reg_file(conv_integer(ra1));
    rd2 <= reg_file(conv_integer(ra2));
        
    func <= instr(5 downto 0);
    sa <= instr(10 downto 6);
    reg7 <=reg_file(7);
end Behavioral;