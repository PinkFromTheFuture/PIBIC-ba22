library verilog;
use verilog.vl_types.all;
entity sram8 is
    generic(
        ADDR_WIDTH      : integer := 11
    );
    port(
        clk             : in     vl_logic;
        we              : in     vl_logic;
        rd              : in     vl_logic;
        addr            : in     vl_logic_vector;
        wdata           : in     vl_logic_vector(7 downto 0);
        rdata           : out    vl_logic_vector(7 downto 0)
    );
end sram8;
