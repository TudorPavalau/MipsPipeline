----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2025 09:39:28 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    port ( clk : in std_logic;
        en : in std_logic;
        memwrite: in std_logic;
        addr : in std_logic_vector(5 downto 0);
        di : in std_logic_vector(31 downto 0);
        do : out std_logic_vector(31 downto 0));
end MEM ;

architecture Behavioral of MEM is
    type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (
        X"0000000A",
        X"0000000B",
        X"00000008",
        X"00000007",
        X"00000006",
        X"00000005",
        X"00000004",
        X"00000003",
        X"00000002",
        X"00000001",
        X"00000000", 
        others => X"00000000"
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and memwrite = '1' then
                ram(conv_integer(addr)) <= di;
            end if;
        end if;
    end process;
    
    do <= ram(conv_integer(addr));
end Behavioral;