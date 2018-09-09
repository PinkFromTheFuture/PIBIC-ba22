library verilog;
use verilog.vl_types.all;
entity qmem_ctrl is
    port(
        initram_addr    : in     vl_logic_vector(31 downto 0);
        initram_data    : in     vl_logic_vector(31 downto 0);
        initram_byte_en : in     vl_logic_vector(3 downto 0);
        initram_stb     : in     vl_logic;
        ben_le_sel_i    : in     vl_logic;
        iqmem_stb       : out    vl_logic;
        iqmem_we        : out    vl_logic;
        iqmem_byte_en   : out    vl_logic_vector(3 downto 0);
        iqmem_wdata     : out    vl_logic_vector(31 downto 0);
        iqmem_addr      : out    vl_logic_vector(31 downto 0)
    );
end qmem_ctrl;
