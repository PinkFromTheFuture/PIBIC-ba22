library verilog;
use verilog.vl_types.all;
entity dpram8 is
    generic(
        ADDR_WIDTH      : integer := 11
    );
    port(
        wclk            : in     vl_logic;
        rclk            : in     vl_logic;
        we              : in     vl_logic;
        rd              : in     vl_logic;
        waddr           : in     vl_logic_vector;
        raddr           : in     vl_logic_vector;
        wdata           : in     vl_logic_vector(7 downto 0);
        rdata           : out    vl_logic_vector(7 downto 0)
    );
end dpram8;
