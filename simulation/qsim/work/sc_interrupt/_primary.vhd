library verilog;
use verilog.vl_types.all;
entity sc_interrupt is
    port(
        CLK_50          : in     vl_logic;
        resetn          : in     vl_logic;
        inst            : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        aluout          : out    vl_logic_vector(31 downto 0);
        memout          : out    vl_logic_vector(31 downto 0);
        mem_clk         : in     vl_logic;
        intr            : in     vl_logic;
        inta            : out    vl_logic;
        overflow        : out    vl_logic;
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0)
    );
end sc_interrupt;
