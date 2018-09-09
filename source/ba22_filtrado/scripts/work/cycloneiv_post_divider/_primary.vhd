library verilog;
use verilog.vl_types.all;
entity cycloneiv_post_divider is
    generic(
        dpa_divider     : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cout            : out    vl_logic
    );
end cycloneiv_post_divider;
