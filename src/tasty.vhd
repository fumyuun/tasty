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

    generated_js_inputs_s.up    <= '0';
    generated_js_inputs_s.down  <= '0';
    generated_js_inputs_s.left  <= '0';
    generated_js_inputs_s.right <= '0';
    generated_js_inputs_s.a     <= '0';
    generated_js_inputs_s.b     <= '0';
    generated_js_inputs_s.x     <= '0';
    generated_js_inputs_s.y     <= '0';
    generated_js_inputs_s.l     <= '0';
    generated_js_inputs_s.r     <= '0';
    generated_js_inputs_s.start <= '1';
    generated_js_inputs_s.sel   <= '0';

    selected_js_inputs_s <= debug_js_inputs_s when debug_enabled_i = '1'
                       else generated_js_inputs_s;

    snes_btn_ctrl0: entity work.snes_btn_ctrl
    port map (
        clk_i => clk_i,
        snes_js_btn_i => selected_js_inputs_s,
        snes_js_bus_i => snes_js_bus_i,
        snes_js_bus_o => snes_js_bus_o,
        btnreg_o => btnreg_o
    );
end;
