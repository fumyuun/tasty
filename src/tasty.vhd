library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity tasty_snes is
    port (
        clk_i         : in std_logic;
        rst_i         : in std_logic;

        snes_js_btn_i : in snes_js_btn_r;

        snes_js_bus_i : in  snes_js_bus_i_r;
        snes_js_bus_o : out snes_js_bus_o_r;

        -- debug
        debug_enabled_i :  in std_logic; -- enable the buttons on the board
        switch_i        :  in std_logic_vector(15 downto 0);
        clock_indicator_o : out std_logic;
        latch_indicator_o : out std_logic;
        btn_indicator_o   : out snes_js_btn_r;
        pc_o              : out std_logic_vector(15 downto 0)
    );
end entity tasty_snes;

architecture behavioral of tasty_snes is
    signal debug_js_inputs_s     : snes_js_btn_r;
    signal generated_js_inputs_s : snes_js_btn_r;
    signal selected_js_inputs_s  : snes_js_btn_r;

    signal ctrl_pause_s : std_logic; -- controller is not done yet issuing current inputs
    signal generator_pause_s : std_logic; -- goes to generator
begin
    debug_js_inputs_s <= snes_js_btn_i;

    selected_js_inputs_s <= debug_js_inputs_s when debug_enabled_i = '1'
                       else generated_js_inputs_s;

    btn_indicator_o <= selected_js_inputs_s;

    generator_pause_s <= '1' when debug_enabled_i = '1' or ctrl_pause_s = '1' else '0';

    snes_btn_ctrl0: entity work.snes_btn_ctrl
    port map (
        clk_i => clk_i,
        snes_js_btn_i => selected_js_inputs_s,
        snes_js_bus_i => snes_js_bus_i,
        snes_js_bus_o => snes_js_bus_o,
        clock_indicator_o => clock_indicator_o,
        latch_indicator_o => latch_indicator_o,
        pause_o => ctrl_pause_s
    );

    js_generator0: entity work.js_generator
    port map (
        clk_i => clk_i,
        rst_i => rst_i,
        pause_i => generator_pause_s,
        js_o => generated_js_inputs_s,
        pc_o => pc_o
    );
end;
