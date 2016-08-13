library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package snes_lib is
    -- bus definitions between tasy and the real hardware
    -- input signals
    type snes_js_bus_i_r is
    record
        clock : std_logic;
        latch : std_logic;
    end record;

    -- output signals
    type snes_js_bus_o_r is
    record
        data  : std_logic;
    end record;

    -- controller representation
    type snes_js_btn_r is
    record
        up      : std_logic;
        left    : std_logic;
        right   : std_logic;
        down    : std_logic;
        a       : std_logic;
        b       : std_logic;
        x       : std_logic;
        y       : std_logic;
        l       : std_logic;
        r       : std_logic;
        start   : std_logic;
        sel     : std_logic;
    end record;

end package snes_lib;
