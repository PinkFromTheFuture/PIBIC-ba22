library verilog;
use verilog.vl_types.all;
entity cycloneive_io_obuf is
    generic(
        open_drain_output: string  := "false";
        bus_hold        : string  := "false";
        lpm_type        : string  := "cycloneive_io_obuf"
    );
    port(
        i               : in     vl_logic;
        oe              : in     vl_logic;
        seriesterminationcontrol: in     vl_logic_vector(15 downto 0);
        devoe           : in     vl_logic;
        o               : out    vl_logic;
        obar            : out    vl_logic
    );
end cycloneive_io_obuf;
