library verilog;
use verilog.vl_types.all;
entity initram32 is
    generic(
        s0              : integer := 0;
        s1              : integer := 1;
        s_done          : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_out_rom    : in     vl_logic_vector(31 downto 0);
        addr_rom        : out    vl_logic_vector(13 downto 0);
        addr_ram        : out    vl_logic_vector(31 downto 0);
        data_in_ram     : out    vl_logic_vector(31 downto 0);
        byte_en         : out    vl_logic_vector(3 downto 0);
        load_done       : out    vl_logic
    );
end initram32;
