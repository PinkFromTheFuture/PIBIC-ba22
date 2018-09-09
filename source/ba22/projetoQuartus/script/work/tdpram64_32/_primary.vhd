library verilog;
use verilog.vl_types.all;
entity tdpram64_32 is
    generic(
        ADDR_WIDTH      : integer := 13
    );
    port(
        clk             : in     vl_logic;
        we_64           : in     vl_logic;
        we_32           : in     vl_logic;
        rd_32           : in     vl_logic;
        byte_en_64      : in     vl_logic_vector(7 downto 0);
        byte_en_32      : in     vl_logic_vector(3 downto 0);
        addr_64         : in     vl_logic_vector;
        addr_32         : in     vl_logic_vector;
        wdata_64        : in     vl_logic_vector(63 downto 0);
        wdata_32        : in     vl_logic_vector(31 downto 0);
        rdata_64        : out    vl_logic_vector(63 downto 0);
        rdata_32        : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end tdpram64_32;
