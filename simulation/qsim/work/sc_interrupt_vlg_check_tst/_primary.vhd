library verilog;
use verilog.vl_types.all;
entity sc_interrupt_vlg_check_tst is
    port(
        HEX0            : in     vl_logic_vector(6 downto 0);
        HEX1            : in     vl_logic_vector(6 downto 0);
        HEX2            : in     vl_logic_vector(6 downto 0);
        HEX3            : in     vl_logic_vector(6 downto 0);
        HEX4            : in     vl_logic_vector(6 downto 0);
        HEX5            : in     vl_logic_vector(6 downto 0);
        aluout          : in     vl_logic_vector(31 downto 0);
        inst            : in     vl_logic_vector(31 downto 0);
        inta            : in     vl_logic;
        memout          : in     vl_logic_vector(31 downto 0);
        overflow        : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end sc_interrupt_vlg_check_tst;
