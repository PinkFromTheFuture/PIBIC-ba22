library verilog;
use verilog.vl_types.all;
entity cycloneive_oscillator is
    generic(
        lpm_type        : string  := "cycloneive_oscillator";
        OSC_PW          : integer := 6250
    );
    port(
        oscena          : in     vl_logic;
        clkout          : out    vl_logic
    );
end cycloneive_oscillator;
