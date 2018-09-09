library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

--library modelsim_lib;
--use modelsim_lib.util.all;

entity tb_imdct_arquivo is
port (
	--		clk          : in  std_logic                     := '0';             -- clock.clk-
	--		reset        : in  std_logic                     := '0';             -- .reset
			LEDG  		 : out std_logic 	 := '0';
			LEDR  		 : out std_logic   := '0' --;
--      ref_data    : out std_logic_vector(31 downto 0);
--      out_data    : out std_logic_vector(31 downto 0);
--      index       : out std_logic_vector(10 downto 0)
			);
end entity;

architecture rtl of tb_imdct_arquivo is

component imdct_top is
    port (
      clk                           : in  std_logic := '0';             -- clock.clk
      enable                        : in std_logic;
      tam_janela                    : in std_logic;
      done                          : out std_logic;
      -- Spec_in_RAM
      spec_in_addr1, spec_in_addr2  : out std_logic_vector(9 downto 0); -- 0 to 1023
      spec_in1, spec_in2            : in std_logic_vector(31 downto 0);
      -- Spec_out_RAM
      spec_out_addr1, spec_out_addr2 : out std_logic_vector(10 downto 0); -- 0 to 2047
      spec_out1, spec_out2          : out std_logic_vector(31 downto 0);
      spec_out_we1                  : out std_logic; --, spec_out_we2
      -- Re_RAM
      we_im_re                      : out std_logic; -- WE compartilhado para RE e IM
      addr_img_re                   : out std_logic_vector(8 downto 0);  -- ADDR compartilhado para RE e IM
      re_z1                         : out std_logic_vector(31 downto 0);    
      re_z1_o                       : in std_logic_vector(31 downto 0);
      -- IM_RAM
      im_z1                         : out std_logic_vector(31 downto 0);
      im_z1_o                       : in std_logic_vector(31 downto 0)
    );
end component;

component dual_ram is -- DUAL RAM
  generic 
  (
    DATA_WIDTH : natural := 8;
    ADDR_WIDTH : natural := 6
  );
  port 
  (
    clk   : in std_logic;
    addr_a  : in natural range 0 to 2**ADDR_WIDTH - 1;
    addr_b  : in natural range 0 to 2**ADDR_WIDTH - 1;
    data_a  : in std_logic_vector((DATA_WIDTH-1) downto 0);
    data_b  : in std_logic_vector((DATA_WIDTH-1) downto 0);
    we_a  : in std_logic := '1';
    we_b  : in std_logic := '1';
    q_a   : out std_logic_vector((DATA_WIDTH -1) downto 0);
    q_b   : out std_logic_vector((DATA_WIDTH -1) downto 0)
  );
end component;

  -- MEMORIA RAM -------------------------------

  component ramblock is -- SINGLE RAM
   generic
   (
     width : integer := 8;
     depth : integer := 16
   );
   port
   (
     clk_i : in std_logic;
     we_i : in std_logic;
     addr_i : in std_logic_vector(depth-1 downto 0);
     data_i : in std_logic_vector(width-1 downto 0);
     data_o : out std_logic_vector(width-1 downto 0)
   );
  end component;

	signal clk : std_logic := '0';
	signal reset : std_logic := '1';
	signal clk_control : std_logic := '0';
	signal enable : std_logic;
	signal done : std_logic;

	signal mux_RAM : std_logic := '0';

	signal tam_janela : std_logic := '1'; -- 0 = curta, 1 = longa

	signal spec_in_addr1, spec_in_addr2 : std_logic_vector(9 downto 0);
	signal spec_out_addr1, spec_out_addr2, addr_imdct_out, addr_tb : std_logic_vector(10 downto 0);
	signal spec_in1, spec_in2, spec_in : std_logic_vector(31 downto 0);
	signal spec_out1, spec_out2 : std_logic_vector(31 downto 0);
	signal spec_out_we1 : std_logic;
	signal imdct_out1, imdct_out2 : std_logic_vector(31 downto 0);
  signal imdct_in : std_logic_vector(31 downto 0);
  signal ram_init_we : std_logic := '0';
  signal addr_tb_in : std_logic_vector(9 downto 0);

	signal data_out_ref : std_logic_vector(31 downto 0);
	signal addr_a_1, addr_b_1, addr_imdct_in : natural range 0 to 2**10 - 1;
	signal addr_a_2, addr_b_2 : natural range 0 to 2**11 - 1;
	
	-- Sinais de Acesso ÃƒÂ s MemÃƒÂ³rias RAM (RE e IM)
	signal we_im_re : std_logic;
	signal addr_img_re : std_logic_vector(8 downto 0);
	signal re_z1, re_z1_o, im_z1, im_z1_o : std_logic_vector(31 downto 0);
 
	type states is (s_init_RAM, s0, s1, s2, s3, s4, termina, termina_falha); 
	signal state : states;

begin
  
clk <= not clk after 10 ns;
reset <= '0' after 30 ns;
tam_janela <= '1';

clk_control_c : process (clk)
variable i_clk: integer;
begin
  if (reset = '1') then
    i_clk := 0;
  elsif (clk'event and clk='1') then
    if (i_clk < 30) then
      i_clk := i_clk + 1;
    else
      i_clk := 0;
      clk_control <= not clk_control;
    end if;
  end if;
end process;


imdct_top_c: imdct_top
port map (
      clk   => clk, --clk_control,
      enable => enable,
      tam_janela => tam_janela,
      done => done,
      spec_in_addr1 => spec_in_addr1, 
      spec_in_addr2 => spec_in_addr2, --: out std_logic_vector(9 downto 0); -- 0 to 1023
      spec_out_addr1 => spec_out_addr1, --: out std_logic_vector(10 downto 0); -- 0 to 2047
      spec_out_addr2 => spec_out_addr2,
      spec_in1 => spec_in1,
      spec_in2 => spec_in2, -- : in std_logic_vector(31 downto 0);
      spec_out1 => spec_out1, 
      spec_out2 => spec_out2, -- : out std_logic_vector(31 downto 0);
      spec_out_we1 => spec_out_we1, --: out std_logic --, spec_out_we2
      we_im_re    => we_im_re,
      addr_img_re => addr_img_re,
      re_z1       => re_z1,
      re_z1_o     => re_z1_o,
      im_z1       => im_z1,
      im_z1_o     => im_z1_o
  );

------------- BLOCOS de MEMORIA (DUAL CHANNEL)------------
addr_a_1 <= to_integer(unsigned(spec_in_addr1));
addr_b_1 <= to_integer(unsigned(spec_in_addr2));

addr_a_2 <= to_integer(unsigned(addr_imdct_out));
addr_b_2 <= to_integer(unsigned(spec_out_addr2));

ram_imdct_out : dual_ram
  generic map
  (
    DATA_WIDTH => 32,
    ADDR_WIDTH => 11
  )
  port map
  (
    clk   => clk,
    addr_a  => addr_a_2,
    addr_b  => addr_b_2,
    data_a  => spec_out1,
    data_b  => spec_out2,
    we_a  => spec_out_we1,
    we_b  => spec_out_we1,
    q_a   => imdct_out1,
    q_b   => imdct_out2
  );

addr_imdct_out <= addr_tb when mux_RAM = '0' else spec_out_addr1;

ram_imdct_in : dual_ram
  generic map
  (
    DATA_WIDTH => 32,
    ADDR_WIDTH => 10
  )
  port map
  (
    clk   => clk,
    addr_a  => addr_imdct_in,
    addr_b  => addr_b_1,
    data_a  => imdct_in,
    data_b  => (others => '0'),
    we_a  => ram_init_we,
    we_b  => '0',
    q_a   => spec_in1,
    q_b   => spec_in2
  );

addr_imdct_in <= to_integer(unsigned(addr_tb_in)) when mux_RAM = '0' else addr_a_1;

------------- BLOCOS de MEMORIA (SINGLE CHANNEL)------------

ram_img : ramblock
  generic map
  (
    width => 32,
    depth => 9
  )
  port map
  (
    clk_i => clk,
    we_i => we_im_re,
    addr_i => addr_img_re,
    data_i => im_z1,    
    data_o => im_z1_o 
  );

ram_re : ramblock
  generic map
  (
    width => 32,
    depth => 9
  )
  port map
  (
    clk_i => clk,
    we_i => we_im_re,
    addr_i => addr_img_re, 
    data_i => re_z1,    
    data_o => re_z1_o
  );  

incrementa_addr : process(clk)
begin
  if (clk'event and clk='1') then
    if (ram_init_we = '0') then
      addr_tb_in <= (others => '0');
    else
      addr_tb_in <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_tb_in)) + 1, 10));
    end if;
  end if;
end process;


maquina: process(clk)
file ref_imdct_in  : text open read_mode is "coef_spec_antes.txt";
file ref_imdct_out : text open read_mode is "coef_spec_depois.txt";
file mod_imdct_out : text open write_mode is "mod_imdct_out.txt";
VARIABLE L, L_in, L_out: LINE;
variable spec_tmp, spec_ref : integer;
variable i : integer range 0 to 4095 := 0;
variable erros : integer range 0 to 2047 := 0;
  begin
    if reset = '1' then
       state    <= s_init_RAM;
       mux_RAM  <= '1';
       enable   <= '0';
		   LEDR <= '0';
       LEDG <= '0';
       addr_tb <= (others => '0');
       i := 0;
    elsif (clk'event and clk='1') then
      mux_RAM  <= '0';
      LEDR <= '0';
      LEDG <= '0';
      ram_init_we <= '0';
      case state is
      -- Executa Modulo de TESTE (IMDCT) 
      when s_init_RAM =>
        readline(ref_imdct_in, L_in);
        read(L_in, spec_tmp);
        imdct_in <= std_logic_vector(to_signed(spec_tmp, 32));
        ram_init_we <= '1';
        i := i + 1;
        if (i = 1024) then
          state <= s0;
        else
          state <= s_init_RAM;
        end if;
      when s0 =>
        mux_RAM  <= '1';
        enable   <= '1';
        if done = '1' then
          state <= s1;
        else
          state <= s0;
        end if;
      when s1 =>
        state <= s2;
		i := 0;
        addr_tb <= (others => '0');
      when s2 =>
        i := i + 1;
        state <= s3;
      when s3 =>
        addr_tb <= std_logic_vector(to_signed(i, 11));
        readline(ref_imdct_out, L_out);
        read(L_out, spec_tmp);
        data_out_ref <= std_logic_vector(to_signed(spec_tmp, 32));
        if (data_out_ref = imdct_out1) then
          state <= s4;
        else
          state <= termina_falha;
        end if;
        spec_tmp := to_integer(signed(imdct_out1));
        write(L, spec_tmp);
        writeline(mod_imdct_out, L);
      when s4 =>        
        if i = 2048 then
          state <= termina;
        else
          state <= s2;
        end if; 
      when termina_falha =>
          LEDR <= '1';
          --state <= termina_falha;
          state <= s4;
       when termina =>
          LEDG <= '1';
          state <= termina;
       when others =>
           null;
      end case;
     end if;
  end process;

end architecture rtl; 