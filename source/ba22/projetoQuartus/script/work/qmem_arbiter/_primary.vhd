library verilog;
use verilog.vl_types.all;
entity qmem_arbiter is
    port(
        clk             : in     vl_logic;
        i_stb           : in     vl_logic;
        i_addr          : in     vl_logic_vector(31 downto 0);
        d_stb           : in     vl_logic;
        d_addr          : in     vl_logic_vector(31 downto 0);
        d_byte_en       : in     vl_logic_vector(3 downto 0);
        mem_ack         : in     vl_logic;
        mem_rdata       : in     vl_logic_vector(63 downto 0);
        d_wdata         : in     vl_logic_vector(31 downto 0);
        mem_stb         : out    vl_logic;
        mem_addr        : out    vl_logic_vector(31 downto 0);
        d_rdata         : out    vl_logic_vector(31 downto 0);
        i_rdata         : out    vl_logic_vector(63 downto 0);
        mem_byte_en     : out    vl_logic_vector(7 downto 0);
        mem_wdata       : out    vl_logic_vector(63 downto 0);
        d_ack           : out    vl_logic;
        i_ack           : out    vl_logic
    );
end qmem_arbiter;
