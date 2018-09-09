library verilog;
use verilog.vl_types.all;
entity cycloneive_io_pad is
    generic(
        lpm_type        : string  := "cycloneive_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end cycloneive_io_pad;
