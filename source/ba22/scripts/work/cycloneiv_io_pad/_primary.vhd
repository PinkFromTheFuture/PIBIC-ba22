library verilog;
use verilog.vl_types.all;
entity cycloneiv_io_pad is
    generic(
        lpm_type        : string  := "cycloneiv_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end cycloneiv_io_pad;
