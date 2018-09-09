library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

--library modelsim_lib;
--use modelsim_lib.util.all;

entity initram is
end entity;

architecture rtl of tb_imdct_clk is

begin

process (clk)
begin
	if rst = '1' then
		addr_rom <= (others => '0');
		addr_ram <= (others => '0');
		state <= s0;
		load_done <= '0';
	elsif rising_edge(clk) then
	load_done <= '0';
	we_ram <= '0';
		case state =>
			when s0 =>
				addr_ram <= addr_rom;
				addr_rom <= addr_rom + 1;
				state <= s1;
			when s1 =>
				we_ram <= '1';
				data_in_ram <= data_out_rom;
				addr_ram <= addr_rom;
				addr_rom <= addr_rom + 1;
				if (addr_rom == 1024) then
					state <= s_done;
				else
					state <= s1;
				end if;
			when s_done =>
				load_done <= '1';
				state <= s_done;
			when others =>
				null;
		end case;				


	end if;
end process;

end architecture;