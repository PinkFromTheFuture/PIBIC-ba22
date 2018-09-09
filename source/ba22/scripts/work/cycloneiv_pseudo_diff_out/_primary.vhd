library verilog;
use verilog.vl_types.all;
entity cycloneiv_pseudo_diff_out is
    generic(
        lpm_type        : string  := "cycloneiv_pseudo_diff_out"
    );
    port(
        i               : in     vl_logic;
        o               : out    vl_logic;
        obar            : out    vl_logic
    );
end cycloneiv_pseudo_diff_out;
