library verilog;
use verilog.vl_types.all;
entity alt_cal_sv is
    generic(
        number_of_channels: integer := 1;
        channel_address_width: integer := 1;
        sim_model_mode  : string  := "TRUE";
        lpm_type        : string  := "alt_cal_sv";
        lpm_hint        : string  := "UNUSED";
        sample_length   : integer := 100;
        pma_base_address: integer := 0
    );
    port(
        busy            : out    vl_logic;
        clock           : in     vl_logic;
        dprio_addr      : out    vl_logic_vector(15 downto 0);
        dprio_busy      : in     vl_logic;
        dprio_datain    : in     vl_logic_vector(15 downto 0);
        dprio_dataout   : out    vl_logic_vector(15 downto 0);
        dprio_rden      : out    vl_logic;
        dprio_wren      : out    vl_logic;
        quad_addr       : out    vl_logic_vector(8 downto 0);
        remap_addr      : in     vl_logic_vector(11 downto 0);
        reset           : in     vl_logic;
        start           : in     vl_logic;
        testbuses       : in     vl_logic_vector(7 downto 0)
    );
end alt_cal_sv;
