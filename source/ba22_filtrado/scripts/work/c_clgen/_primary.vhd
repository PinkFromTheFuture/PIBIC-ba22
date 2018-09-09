library verilog;
use verilog.vl_types.all;
entity c_clgen is
    generic(
        count0          : integer := 0;
        count1          : integer := 1;
        count2          : integer := 2;
        count3          : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        load_done       : in     vl_logic;
        clk_o           : out    vl_logic;
        pm_clk_o        : out    vl_logic;
        rst_o           : out    vl_logic;
        pm_stalled_i    : in     vl_logic;
        pm_stall_o      : out    vl_logic
    );
end c_clgen;
