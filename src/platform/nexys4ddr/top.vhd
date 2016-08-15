library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity top_nexys4ddr is
    port (
        clk_i : in std_logic;

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
        switch_i : in std_logic_vector(15 downto 0)
    );
end entity top_nexys4ddr;

architecture behavioral of top_nexys4ddr is
    signal snes_js_btn_s : snes_js_btn_r;
    signal snes_js_bus_i_s : snes_js_bus_i_r;
    signal snes_js_bus_o_s : snes_js_bus_o_r;

    signal counter_1 : unsigned (31 downto 0);

begin

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

    tasty: entity work.tasty_snes
    port map (
        snes_js_btn_i => snes_js_btn_s,
        snes_js_bus_i => snes_js_bus_i_s,
        snes_js_bus_o => snes_js_bus_o_s,
        debug_enabled_i => switch_i(15),
        btnreg_o => led_o(11 downto 0)
    );

    clock_1: process (pmod_a_io_1) is
    begin
        if rising_edge (pmod_a_io_1) then
            counter_1 <= counter_1 + 1;
        end if;
    end process;

    led_o(15) <= counter_1(8);
end;
