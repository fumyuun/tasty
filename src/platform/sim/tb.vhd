library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity tb is
end entity;

architecture tb_arch of tb is
    signal clk_s : std_logic;
    signal rst_s : std_logic;

    signal btn_s : std_logic_vector(12 downto 0);

    signal js_clock_s : std_logic := '0';
    signal js_latch_s : std_logic := '0';
    signal js_data_s  : std_logic;

    signal clock_active_s : std_logic := '0';

    signal snes_js_btn_s : snes_js_btn_r;
    signal snes_js_bus_i_s : snes_js_bus_i_r;
    signal snes_js_bus_o_s : snes_js_bus_o_r;
begin

    -- up & b
    btn_s <= "0000000100001";

    snes_js_btn_s.up    <= btn_s(0);
    snes_js_btn_s.down  <= btn_s(1);
    snes_js_btn_s.left  <= btn_s(2);
    snes_js_btn_s.right <= btn_s(3);
    snes_js_btn_s.a     <= btn_s(4);
    snes_js_btn_s.b     <= btn_s(5);
    snes_js_btn_s.x     <= btn_s(6);
    snes_js_btn_s.y     <= btn_s(7);
    snes_js_btn_s.l     <= btn_s(8);
    snes_js_btn_s.r     <= btn_s(9);
    snes_js_btn_s.start <= btn_s(10);
    snes_js_btn_s.sel   <= btn_s(11);

    snes_js_bus_i_s.clock <= js_clock_s;
    snes_js_bus_i_s.latch <= js_latch_s;

    js_data_s <= snes_js_bus_o_s.data;

    clk_s <= '0';
    rst_s <= '1', '0' after 1 us;


    tasty: entity work.tasty_snes
    port map (
        snes_js_btn_i => snes_js_btn_s,
        snes_js_bus_i => snes_js_bus_i_s,
        snes_js_bus_o => snes_js_bus_o_s,
        debug_enabled_i => '1',
        btnreg_o => open
    );


    test_proc: process
    begin
        clock_active_s <= '0';

        wait for 10 us;
        js_latch_s <= '1';
        wait for 12 us;
        js_latch_s <= '0';
        wait for 6 us;
        clock_active_s <= '1';
        wait for 16*12 us;
        clock_active_s <= '0';

    end process;

    js_clock_s <= '0' when clock_active_s = '0' else not js_clock_s after 6 us;


end architecture tb_arch;
