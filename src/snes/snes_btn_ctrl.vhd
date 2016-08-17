--
-- This entity converts button states to the SNES communication protocol
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity snes_btn_ctrl is
    port (
        clk_i         : in std_logic;
        snes_js_btn_i : in snes_js_btn_r;

        snes_js_bus_i : in  snes_js_bus_i_r;
        snes_js_bus_o : out snes_js_bus_o_r;

        btnreg_o : out std_logic_vector(15 downto 0)
    );
end entity snes_btn_ctrl;

architecture behavioral of snes_btn_ctrl is
    -- latches the state of the buttons
    signal btn_r         : std_logic_vector(15 downto 0);
    signal btn_next_r    : std_logic_vector(15 downto 0);

    signal latch_r     : std_logic;
    signal ext_clock_r : std_logic;

    signal prev_latch_r : std_logic;
    signal prev_ext_clock_r : std_logic;

    signal latch_rising_s : std_logic;
    signal ext_clock_rising_s : std_logic;

    signal clk_counter_s : unsigned(31 downto 0);
    signal clk_counter_next_s : unsigned(31 downto 0);

    signal latch_counter_s : unsigned(31 downto 0);
    signal latch_counter_next_s : unsigned(31 downto 0);
begin

    clock_proc: process (clk_i)
    begin
        if rising_edge(clk_i) then
            prev_latch_r <= latch_r;
            prev_ext_clock_r <= ext_clock_r;
            ext_clock_r <= snes_js_bus_i.clock;
            latch_r <= snes_js_bus_i.latch;
            btn_r <= btn_next_r;
            clk_counter_s <= clk_counter_next_s;
            latch_counter_s <= latch_counter_next_s;
        end if;
    end process;

    latch_rising_s <= not(prev_latch_r) and latch_r;
    ext_clock_rising_s <= not(prev_ext_clock_r) and ext_clock_r;

    btnreg_o <= std_logic_vector(latch_counter_s(15 downto 0));

    snes_js_bus_o.data <= not(btn_r(0));

    comb_proc : process (ext_clock_rising_s, latch_r, btn_r, btn_next_r, clk_counter_s, latch_counter_s, latch_rising_s,
        snes_js_btn_i.up, snes_js_btn_i.left, snes_js_btn_i.right, snes_js_btn_i.down,
        snes_js_btn_i.a, snes_js_btn_i.b, snes_js_btn_i.x, snes_js_btn_i.y, snes_js_btn_i.start,
        snes_js_btn_i.sel, snes_js_btn_i.l, snes_js_btn_i.r)
    begin
        btn_next_r <= btn_r;
        latch_counter_next_s <= latch_counter_s;
        clk_counter_next_s <= clk_counter_s;


        -- latch button state
        if latch_rising_s = '1' then
            latch_counter_next_s <= latch_counter_s + 1;
        elsif latch_r = '1' then
            btn_next_r(0) <= snes_js_btn_i.b;
            btn_next_r(1) <= snes_js_btn_i.y;
            btn_next_r(2) <= snes_js_btn_i.sel;
            btn_next_r(3) <= snes_js_btn_i.start;
            btn_next_r(4) <= snes_js_btn_i.up;
            btn_next_r(5) <= snes_js_btn_i.down;
            btn_next_r(6) <= snes_js_btn_i.left;
            btn_next_r(7) <= snes_js_btn_i.right;
            btn_next_r(8) <= snes_js_btn_i.a;
            btn_next_r(9) <= snes_js_btn_i.x;
            btn_next_r(10) <= snes_js_btn_i.l;
            btn_next_r(11) <= snes_js_btn_i.r;
            btn_next_r(15 downto 12) <= "0000"; -- unused bits
        -- shift out our values
        elsif ext_clock_rising_s = '1' then
            for i in 0 to 14 loop
                btn_next_r(i) <= btn_r(i+1);
            end loop;
            btn_next_r(15) <= '0';

            clk_counter_next_s <= clk_counter_s + 1;
        end if;
    end process;
end;
