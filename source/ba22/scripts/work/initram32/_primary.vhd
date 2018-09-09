library verilog;
use verilog.vl_types.all;
entity initram32 is
    generic(
        DELAY           : integer := 5
    );
    port(
        clk             : in     vl_logic;
        start_load      : in     vl_logic;
        addr            : out    vl_logic_vector(31 downto 0);
        data            : out    vl_logic_vector(31 downto 0);
        byte_en         : out    vl_logic_vector(3 downto 0);
        load_done       : out    vl_logic
    );
end initram32;
