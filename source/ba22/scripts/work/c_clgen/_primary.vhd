library verilog;
use verilog.vl_types.all;
entity c_clgen is
    generic(
        ref_clk_per     : real    := 0.000000;
        clk_div         : integer := 0;
        pm_clk_div      : integer := 0
    );
    port(
        rst_o           : out    vl_logic;
        clk_o           : out    vl_logic;
        wb_clk_o        : out    vl_logic;
        pm_clk_o        : out    vl_logic;
        pm_stall_o      : out    vl_logic;
        pm_stalled_i    : in     vl_logic
    );
end c_clgen;
