library verilog;
use verilog.vl_types.all;
entity light is
    port(
        SW              : in     vl_logic_vector(1 downto 0);
        LEDG            : out    vl_logic
    );
end light;
