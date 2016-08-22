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

    signal debug_mouse_inputs_s  : snes_mouse_btn_r;

    signal snes_js_bus_o_s      : snes_js_bus_o_r;
    signal snes_mouse_bus_o_s   : snes_js_bus_o_r;

    signal btn_clock_ind_s   : std_logic;
    signal btn_latch_ind_s   : std_logic;
    signal mouse_clock_ind_s : std_logic;
    signal mouse_latch_ind_s : std_logic;


    signal ctrl_pause_s : std_logic; -- controller is not done yet issuing current inputs
    signal generator_pause_s : std_logic; -- goes to generator
begin
    debug_js_inputs_s <= snes_js_btn_i;

    selected_js_inputs_s <= debug_js_inputs_s when debug_enabled_i = '1'
                       else generated_js_inputs_s;

    snes_js_bus_o <= snes_js_bus_o_s when switch_i(14) = '0'
                else snes_mouse_bus_o_s;

    clock_indicator_o <= btn_clock_ind_s when switch_i(14) = '0'
                    else mouse_clock_ind_s;
    latch_indicator_o <= btn_latch_ind_s when switch_i(14) = '0'
                    else mouse_latch_ind_s;


    btn_indicator_o <= selected_js_inputs_s;

    generator_pause_s <= '1' when debug_enabled_i = '1' or ctrl_pause_s = '1' else '0';

    debug_mouse_inputs_s.left  <= switch_i(0);
    debug_mouse_inputs_s.right <= switch_i(1);

    debug_mouse_inputs_s.x_direction <= switch_i(2);
    debug_mouse_inputs_s.y_direction <= switch_i(3);

    debug_mouse_inputs_s.x_motion <= "00" & switch_i( 8 downto 4);
    debug_mouse_inputs_s.y_motion <= "00" & switch_i(13 downto 9);

    snes_btn_ctrl0: entity work.snes_btn_ctrl
    port map (
        clk_i => clk_i,
        snes_js_btn_i => selected_js_inputs_s,
        snes_js_bus_i => snes_js_bus_i,
        snes_js_bus_o => snes_js_bus_o_s,
        clock_indicator_o => btn_clock_ind_s,
        latch_indicator_o => btn_latch_ind_s,
        pause_o => ctrl_pause_s
    );

    snes_mouse_ctrl0: entity work.snes_mouse_ctrl
    port map (
        clk_i             => clk_i,
        snes_mouse_btn_i  => debug_mouse_inputs_s,
        snes_js_bus_i     => snes_js_bus_i,
        snes_js_bus_o     => snes_mouse_bus_o_s,
        clock_indicator_o => mouse_clock_ind_s,
        latch_indicator_o => mouse_latch_ind_s,
        pause_o => open
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
