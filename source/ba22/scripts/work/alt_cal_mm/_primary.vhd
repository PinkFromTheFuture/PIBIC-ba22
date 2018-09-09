library verilog;
use verilog.vl_types.all;
entity alt_cal_mm is
    generic(
        number_of_channels: integer := 1;
        channel_address_width: integer := 1;
        sim_model_mode  : string  := "TRUE";
        lpm_type        : string  := "alt_cal_mm";
        lpm_hint        : string  := "UNUSED";
        idle            : integer := 0;
        ch_wait         : integer := 1;
        testbus_set     : integer := 2;
        offsets_pden_rd : integer := 3;
        offsets_pden_wr : integer := 4;
        cal_pd_wr       : integer := 5;
        cal_rx_rd       : integer := 6;
        cal_rx_wr       : integer := 7;
        dprio_wait      : integer := 8;
        sample_tb       : integer := 9;
        test_input      : integer := 10;
        ch_adv          : integer := 12;
        dprio_read      : integer := 14;
        dprio_write     : integer := 15;
        kick_start_rd   : integer := 13;
        kick_start_wr   : integer := 16;
        kick_pause      : integer := 17;
        kick_delay_oc   : integer := 18;
        sample_length   : integer := 0
    );
    port(
        busy            : out    vl_logic;
        cal_error       : out    vl_logic_vector;
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
        retain_addr     : out    vl_logic_vector(0 downto 0);
        start           : in     vl_logic;
        transceiver_init: in     vl_logic;
        testbuses       : in     vl_logic_vector
    );
end alt_cal_mm;
