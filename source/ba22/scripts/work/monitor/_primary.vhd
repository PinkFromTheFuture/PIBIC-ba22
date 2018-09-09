library verilog;
use verilog.vl_types.all;
entity monitor is
    generic(
        BA22_BUS        : string  := "AHB"
    );
    port(
        clk             : in     vl_logic;
        rst_i           : in     vl_logic;
        iqmem_stb       : in     vl_logic;
        iqmem_ack       : in     vl_logic;
        dqmem_ack       : in     vl_logic;
        iqmem_data      : in     vl_logic_vector(63 downto 0);
        dqmem_data      : in     vl_logic_vector(31 downto 0);
        dqmem_wdata     : in     vl_logic_vector(31 downto 0);
        iqmem_addr      : in     vl_logic_vector(31 downto 0);
        dqmem_addr      : in     vl_logic_vector(31 downto 0);
        dqmem_we        : in     vl_logic;
        intr            : out    vl_logic_vector(2 downto 0)
    );
end monitor;
