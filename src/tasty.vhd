library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity tasty_snes is
    port (
        snes_js_btn_i : in snes_js_btn_r;

        snes_js_bus_i : in  snes_js_bus_i_r;
        snes_js_bus_o : out snes_js_bus_o_r;

        -- debug
        debug_enabled_i : in std_logic; -- enable the buttons on the board
        btnreg_o        : out std_logic_vector(15 downto 0)
    );
end entity tasty_snes;

architecture behavioral of tasty_snes is
    signal debug_js_inputs_s     : snes_js_btn_r;
    signal generated_js_inputs_s : snes_js_btn_r;
    signal selected_js_inputs_s  : snes_js_btn_r;
begin
    debug_js_inputs_s <= snes_js_btn_i;

    selected_js_inputs_s <= debug_js_inputs_s when debug_enabled_i = '1'
                       else generated_js_inputs_s;

    snes_btn_ctrl0: entity work.snes_btn_ctrl
    port map (
        snes_js_btn_i => selected_js_inputs_s,
        snes_js_bus_i => snes_js_bus_i,
        snes_js_bus_o => snes_js_bus_o,
        btnreg_o => btnreg_o
    );
end;
