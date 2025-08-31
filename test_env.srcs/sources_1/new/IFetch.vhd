----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 08:24:34 AM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
  Port (
        jump: in STD_LOGIC;
        jump_addr: in STD_LOGIC_VECTOR(31 downto 0);
        pcsrc: in STD_LOGIC;
        branch_addr: in STD_LOGIC_VECTOR(31 downto 0);
        en: in STD_LOGIC;
        rst: in STD_LOGIC;
        clk: in STD_LOGIC;
        pcp4: out STD_LOGIC_VECTOR(31 downto 0);
        instruction: out STD_LOGIC_VECTOR(31 downto 0)
  );
end IFetch;

architecture Behavioral of IFetch is
    
    type t_rom is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal rom: t_rom := (
        b"000000_00000_00000_00110_00000_100000",     -- 0000 3020   add $6, $0, $0      ok=0.
        b"001000_00000_00010_0000000000001010",       -- 2002 000A   addi $2, $0, 5      n=10.
        b"000000_00000_00000_01000_00000_100000",     -- 0000 4020   add $8, $0, $0      a. 
        b"000000_00001_00001_00011_00000_100000",     -- 0020 1820   add $3, $1, $1      i=2.
        b"000100_00011_00010_0000000000001000",       -- 1062 0008   beq $3, $2, 6       --De aici
        b"100011_01000_00100_0000000000000000",       -- 8D04 0000   lw $4, M[$8]       
        b"001000_01000_01000_0000000000000100",       -- 2108 0004   addi $8,$8,4        
        b"001000_00011_00011_0000000000000001",       -- 2063 0001   addi $3,$3,1    
        b"100011_01000_00101_0000000000000000",       -- 8D05 0000   lw $5,M[$8]         Este bucla for,pot explica mult mai usor F2F oricand:)
        b"000000_00100_00101_00100_00000_100010",     -- 0085 2022   sub $4,$4,$5      
        b"000001_00100_00000_1111111111111001",       -- 0480 FFF9   bgez $4,-7     
        b"000000_00000_00001_00110_00000_100000",     -- 0001 3020   add $6,$0,$1 
        b"000010_00000000000000000000001101",         -- 0800 000D   j 13                Pana aici--   
        b"000000_00110_00110_00111_00000_100000",     -- 00C6 3820   add $7,$6,$6        int res =ok.
        others => X"00000000"
    );
    
    signal pcq: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal pcd: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    
    
begin

    process(jump,pcsrc,clk)
    begin
        case jump is 
            when '0' =>
                case pcsrc is
                    when '0' => pcd <= pcq + 4;
                    when '1' => pcd <= branch_addr;
                    when others =>pcd<=X"00000000";
                end case;
            when '1' => pcd <= jump_addr;
            when others =>pcd<=X"00000000";
        end case;
    end process;

    process(clk, rst,jump,pcsrc,pcd)
    begin
        if rst = '1' then
            pcq <= X"00000000";
        elsif rising_edge(clk) then
            if en = '1' then
                pcq <= pcd;
            end if;
        end if;
    end process;
    
    instruction <= rom(conv_integer(pcq(6 downto 2)));
    pcp4 <= pcq + 4;
    
end Behavioral;