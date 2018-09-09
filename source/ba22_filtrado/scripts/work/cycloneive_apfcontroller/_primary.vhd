library verilog;
use verilog.vl_types.all;
entity cycloneive_apfcontroller is
    generic(
        lpm_type        : string  := "cycloneive_apfcontroller"
    );
    port(
        usermode        : out    vl_logic;
        nceout          : out    vl_logic
    );
end cycloneive_apfcontroller;
