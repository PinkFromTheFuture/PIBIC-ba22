library verilog;
use verilog.vl_types.all;
entity ahb_slave_behavioral is
    generic(
        ahb_monitor     : integer := 0
    );
    port(
        ahb_clk_i       : in     vl_logic;
        ahb_rstn_i      : in     vl_logic;
        ahb_hgrant_o    : inout  vl_logic;
        ahb_hready_o    : inout  vl_logic;
        ahb_hresp_o     : inout  vl_logic_vector(1 downto 0);
        ahb_hrdata_o    : inout  vl_logic_vector(31 downto 0);
        ahb_hbusreq_i   : in     vl_logic;
        ahb_htrans_i    : in     vl_logic_vector(1 downto 0);
        ahb_haddr_i     : in     vl_logic_vector(31 downto 0);
        ahb_hwrite_i    : in     vl_logic;
        ahb_hsize_i     : in     vl_logic_vector(2 downto 0);
        ahb_hburst_i    : in     vl_logic_vector(2 downto 0);
        ahb_hprot_i     : in     vl_logic_vector(3 downto 0);
        ahb_hlock_i     : in     vl_logic;
        ahb_hwdata_i    : in     vl_logic_vector(31 downto 0)
    );
end ahb_slave_behavioral;
