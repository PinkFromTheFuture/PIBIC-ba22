library verilog;
use verilog.vl_types.all;
entity tdpram8 is
    generic(
        ADDR_WIDTH      : integer := 13
    );
    port(
        clk             : in     vl_logic;
        we_a            : in     vl_logic;
        we_b            : in     vl_logic;
        addr_a          : in     vl_logic_vector;
        addr_b          : in     vl_logic_vector;
        wdata_a         : in     vl_logic_vector(7 downto 0);
        wdata_b         : in     vl_logic_vector(7 downto 0);
        rdata_a         : out    vl_logic_vector(7 downto 0);
        rdata_b         : out    vl_logic_vector(7 downto 0)
    );
end tdpram8;
