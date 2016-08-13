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
        btnreg_o : out std_logic_vector(15 downto 0)
    );
end entity tasty_snes;

architecture behavioral of tasty_snes is
    -- latches the state of the buttons
    signal btn_r : std_logic_vector(15 downto 0);

begin
    btnreg_o <= btn_r;
    snes_js_bus_o.data <= btn_r(0);

    clk_proc : process (snes_js_bus_i.latch, snes_js_bus_i.clock,
        snes_js_btn_i.up, snes_js_btn_i.left, snes_js_btn_i.right, snes_js_btn_i.down,
        snes_js_btn_i.a, snes_js_btn_i.b, snes_js_btn_i.x, snes_js_btn_i.y, snes_js_btn_i.start)
    begin
        -- latch button state
        if snes_js_bus_i.latch = '1' then
            btn_r(0) <= snes_js_btn_i.b;
            btn_r(1) <= snes_js_btn_i.y;
            btn_r(2) <= '0';    -- select
            btn_r(3) <= snes_js_btn_i.start;
            btn_r(4) <= snes_js_btn_i.up;
            btn_r(5) <= snes_js_btn_i.down;
            btn_r(6) <= snes_js_btn_i.left;
            btn_r(7) <= snes_js_btn_i.right;
            btn_r(8) <= snes_js_btn_i.a;
            btn_r(9) <= snes_js_btn_i.x;
            btn_r(10) <= '0'; -- l
            btn_r(11) <= '0'; -- r
            btn_r(15 downto 12) <= "1111"; -- unused bits
        -- shift out our values
        elsif rising_edge(snes_js_bus_i.clock) then
            for i in 0 to 14 loop
                btn_r(i) <= btn_r(i+1);
            end loop;
            btn_r(15) <= '0';
        end if;
    end process;
end;
