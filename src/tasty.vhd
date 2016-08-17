library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity tasty_snes is
    port (
        clk_i         : in std_logic;

        snes_js_btn_i : in snes_js_btn_r;

        snes_js_bus_i : in  snes_js_bus_i_r;
        snes_js_bus_o : out snes_js_bus_o_r;

        -- debug
        debug_enabled_i :  in std_logic; -- enable the buttons on the board
        switch_i        :  in std_logic_vector(15 downto 0);
        clock_indicator_o : out std_logic;
        latch_indicator_o : out std_logic;
        btn_indicator_o   : out snes_js_btn_r
    );
end entity tasty_snes;

architecture behavioral of tasty_snes is
    signal debug_js_inputs_s     : snes_js_btn_r;
    signal generated_js_inputs_s : snes_js_btn_r;
    signal selected_js_inputs_s  : snes_js_btn_r;
begin
    debug_js_inputs_s <= snes_js_btn_i;

    generated_js_inputs_s.up    <= switch_i(0);
    generated_js_inputs_s.down  <= switch_i(1);
    generated_js_inputs_s.left  <= switch_i(2);
    generated_js_inputs_s.right <= switch_i(3);
    generated_js_inputs_s.a     <= switch_i(4);
    generated_js_inputs_s.b     <= switch_i(5);
    generated_js_inputs_s.x     <= switch_i(6);
    generated_js_inputs_s.y     <= switch_i(7);
    generated_js_inputs_s.l     <= switch_i(8);
    generated_js_inputs_s.r     <= switch_i(9);
    generated_js_inputs_s.start <= switch_i(10);
    generated_js_inputs_s.sel   <= switch_i(11);

    selected_js_inputs_s <= debug_js_inputs_s when debug_enabled_i = '1'
                       else generated_js_inputs_s;

    btn_indicator_o <= selected_js_inputs_s;

    snes_btn_ctrl0: entity work.snes_btn_ctrl
    port map (
        clk_i => clk_i,
        snes_js_btn_i => selected_js_inputs_s,
        snes_js_bus_i => snes_js_bus_i,
        snes_js_bus_o => snes_js_bus_o,
        clock_indicator_o => clock_indicator_o,
        latch_indicator_o => latch_indicator_o
    );
end;
