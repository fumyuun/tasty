--
-- This entity passes through a snes joystick to a snes unmodified
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity snes_js_ctrl is
    port (
        clk_i         : in std_logic;
        pause_o       : out std_logic;

        snes_i : in  snes_js_bus_i_r;
        snes_o : out snes_js_bus_o_r;

        js_i   : in  snes_js_bus_o_r;
        js_o   : out snes_js_bus_i_r
    );
end entity snes_js_ctrl;

architecture behavioral of snes_js_ctrl is
begin
    js_o <= snes_i;
    snes_o <= js_i;

end;
