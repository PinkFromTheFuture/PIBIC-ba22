library verilog;
use verilog.vl_types.all;
entity cycloneiv_oscillator is
    generic(
        lpm_type        : string  := "cycloneiv_oscillator";
        OSC_PW          : integer := 6250
    );
    port(
        oscena          : in     vl_logic;
        observableoutputport: out    vl_logic;
        clkout          : out    vl_logic
    );
end cycloneiv_oscillator;
