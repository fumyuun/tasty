library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity top_nexys4ddr is
    port (
        clk_i : in std_logic;

        nrst_i : in std_logic;

        -- push buttons
        btnu_i : in std_logic;
        btnl_i : in std_logic;
        btnr_i : in std_logic;
        btnd_i : in std_logic;
        btnc_i : in std_logic;

        -- pmods
        pmod_a_io_1 : in std_logic;
        pmod_a_io_2 : in std_logic;
        pmod_a_io_3 : out std_logic;

        pmod_b_io : in std_logic_vector(10 downto 0);

        led_o    : out std_logic_vector(15 downto 0);
        switch_i : in std_logic_vector(15 downto 0);

        sseg_c_o  : out std_logic_vector(7 downto 0);
        sseg_an_o : out std_logic_vector(7 downto 0)
    );
end entity top_nexys4ddr;

architecture behavioral of top_nexys4ddr is
    signal rst_s : std_logic;
    signal snes_js_btn_s : snes_js_btn_r;
    signal snes_js_bus_i_s : snes_js_bus_i_r;
    signal snes_js_bus_o_s : snes_js_bus_o_r;

    signal snes_js_btn_leds_s : snes_js_btn_r;

    signal pc_s       : std_logic_vector(15 downto 0);
    signal dropped_s  : std_logic_vector(15 downto 0);
    signal sseg_out_s : std_logic_vector(31 downto 0);
begin

    rst_s <= not nrst_i;

    sseg_out_s <= dropped_s & pc_s;

    clock_proc: process(clk_i)
    begin
        if rising_edge(clk_i) then
            snes_js_btn_s.up    <= btnu_i;
            snes_js_btn_s.down  <= btnd_i;
            snes_js_btn_s.left  <= btnl_i;
            snes_js_btn_s.right <= btnr_i;
            snes_js_btn_s.a     <= pmod_b_io(2);
            snes_js_btn_s.b     <= pmod_b_io(4);
            snes_js_btn_s.x     <= pmod_b_io(1);
            snes_js_btn_s.y     <= pmod_b_io(3);
            snes_js_btn_s.l     <= '0';
            snes_js_btn_s.r     <= '0';
            snes_js_btn_s.start <= btnc_i;
            snes_js_btn_s.sel   <= '0';

            snes_js_bus_i_s.latch <= pmod_a_io_1;
            snes_js_bus_i_s.clock <= pmod_a_io_2;

            pmod_a_io_3 <= snes_js_bus_o_s.data;
        end if;

    end process;


    led_o(0)  <= snes_js_btn_leds_s.up;
    led_o(1)  <= snes_js_btn_leds_s.down;
    led_o(2)  <= snes_js_btn_leds_s.left;
    led_o(3)  <= snes_js_btn_leds_s.right;
    led_o(4)  <= snes_js_btn_leds_s.a;
    led_o(5)  <= snes_js_btn_leds_s.b;
    led_o(6)  <= snes_js_btn_leds_s.x;
    led_o(7)  <= snes_js_btn_leds_s.y;
    led_o(8)  <= snes_js_btn_leds_s.l;
    led_o(9)  <= snes_js_btn_leds_s.r;
    led_o(10) <= snes_js_btn_leds_s.start;
    led_o(11) <= snes_js_btn_leds_s.sel;

    tasty: entity work.tasty_snes
    port map (
        clk_i => clk_i,
        rst_i => rst_s,
        snes_js_btn_i => snes_js_btn_s,
        snes_js_bus_i => snes_js_bus_i_s,
        snes_js_bus_o => snes_js_bus_o_s,
        debug_enabled_i => switch_i(15),
        clock_indicator_o => led_o(14),
        latch_indicator_o => led_o(15),
        btn_indicator_o => snes_js_btn_leds_s,
        switch_i => switch_i,
        pc_o => pc_s,
        dropped_o => dropped_s
    );

    seven_segment_ctrl0: entity work.seven_segment_ctrl
    port map (
        clk_i => clk_i,
        num_i => sseg_out_s,
        c_o   => sseg_c_o,
        an_o  => sseg_an_o
    );

end;
