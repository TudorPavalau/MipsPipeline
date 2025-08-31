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

entity test_env is
    Port (
        clk: in STD_LOGIC;
        btn: in STD_LOGIC_VECTOR (4 downto 0);
        sw: in STD_LOGIC_VECTOR (15 downto 0);
        led: out STD_LOGIC_VECTOR (15 downto 0);
        an: out STD_LOGIC_VECTOR (7 downto 0);
        cat: out STD_LOGIC_VECTOR (6 downto 0)
    );
end test_env;

architecture Behavioral of test_env is            
    component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
    end component MPG;
    
    component SSD is
        Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
    end component SSD;
    
    component IFetch is
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
    end component IFetch;
    
    component ID is
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
    end component ID;
    
    component UC is
        Port (
            instr_opcode: in STD_LOGIC_VECTOR(5 downto 0);
            regdst: out STD_LOGIC;
            extop: out STD_LOGIC;
            alusrc:  out STD_LOGIC_VECTOR(1 downto 0);
            branch: out STD_LOGIC;
            bgez: out STD_LOGIC;
            jump: out STD_LOGIC;
            aluop: out STD_LOGIC_VECTOR(2 downto 0);
            memwrite: out STD_LOGIC;
            memtoreg: out STD_LOGIC;
            regwrite: out STD_LOGIC
        );
    end component UC;
    
    component MEM is
        port ( clk : in std_logic;
            en : in std_logic;
            memwrite: in std_logic;
            addr : in std_logic_vector(5 downto 0);
            di : in std_logic_vector(31 downto 0);
            do : out std_logic_vector(31 downto 0));
    end component MEM ;
    
    component EX is
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
    end component EX;
    
    signal mpg_en: STD_LOGIC := '0';
    signal mpg_en1: STD_LOGIC := '0';
    signal digits: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal instruction: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal pc: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
    signal pcsrc: STD_LOGIC := '0';
    signal jumpaddr: STD_LOGIC_VECTOR(31 downto 0);

    signal rd1: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal rd2: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal wd: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal extimm: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal reg7: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal func: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal sa: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    
    signal regdst: STD_LOGIC := '0';
    signal extop: STD_LOGIC := '0';
    signal alusrc: STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal branch: STD_LOGIC := '0';
    signal bgez: STD_LOGIC := '0';
    signal jump: STD_LOGIC := '0';
    signal aluop: STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal memwrite: STD_LOGIC := '0';
    signal memtoreg: STD_LOGIC := '0';
    signal regwrite: STD_LOGIC := '0';
    
    signal zero: STD_LOGIC := '0';
    signal sign: STD_LOGIC := '0';
    signal alures: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal branchaddr: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    signal memdata: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
begin
    
    mpg_1: MPG port map(mpg_en, btn(0), clk);
    mpg_2: MPG port map(mpg_en1, btn(1), clk);
    ssd_1: SSD port map(clk, digits, an, cat);
    fetch: IFetch port map(
      jump => jump,
      jump_addr => jumpaddr,
      pcsrc => pcsrc,
      branch_addr => branchaddr,
      en => mpg_en,
      rst => mpg_en1,
      clk => clk,
      pcp4 => pc,
      instruction => instruction
    );
    control: UC port map(instruction(31 downto 26), regdst, extop, alusrc, branch,bgez, jump, aluop, memwrite, memtoreg, regwrite);
    instr_deocde: ID port map(
        clk => clk,
        regwrite => regwrite,
        instr => instruction(25 downto 0),
        regdst => regdst,
        en => mpg_en,
        extop => extop,
        wd => wd,
        rd1 => rd1,
        rd2 => rd2,
        extimm => extimm,
        func => func,
        sa => sa,
        reg7 => reg7
    );
    executie: EX port map(
        rd1 => rd1,
        rd2 => rd2,
        alusrc => alusrc,
        extimm => extimm,
        sa => sa,
        func => func, 
        aluop => aluop,
        pcp4 => pc,
        zero => zero,
        sign => sign,
        alures => alures,
        branchaddr => branchaddr
    );
    memorie: MEM port map(
        clk => clk,
        en => mpg_en,
        memwrite => memwrite,
        addr => alures(7 downto 2),
        di => rd2,
        do => memdata
    );
    
    process(sw(7 downto 5))
    begin
        case sw(7 downto 5) is
            when "000" => digits <= instruction;
            when "001" => digits <= pc;
            when "010" => digits <= rd1;
            when "011" => digits <= rd2;
            when "100" => digits <= extimm; 
            when "101" => digits <= alures;
            when "110" => digits <= reg7;--!!!
            when "111" => digits <= wd;
            when others => digits<=X"00000000";
        end case;
    end process;
    
    wd <= alures when memtoreg = '0' else memdata;
    pcsrc <= (branch and zero) or ((not sign) and bgez);
    jumpaddr <= pc(31 downto 28) & instruction(25 downto 0) & "00";
    led(13 downto 0) <= aluop & regdst & extop & alusrc & branch & bgez & sign & jump & memwrite & memtoreg & regwrite;
    
end Behavioral;