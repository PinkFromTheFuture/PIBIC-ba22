library verilog;
use verilog.vl_types.all;
entity cycloneiv_controller is
    generic(
        lpm_type        : string  := "cycloneiv_controller"
    );
    port(
        usermode        : out    vl_logic;
        nceout          : out    vl_logic
    );
end cycloneiv_controller;
