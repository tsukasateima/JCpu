library verilog;
use verilog.vl_types.all;
entity sc_interrupt_vlg_sample_tst is
    port(
        CLK_50          : in     vl_logic;
        intr            : in     vl_logic;
        mem_clk         : in     vl_logic;
        resetn          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end sc_interrupt_vlg_sample_tst;
