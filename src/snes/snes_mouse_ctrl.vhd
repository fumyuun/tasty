--
-- This entity converts a mouse state to the SNES communication protocol
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity snes_mouse_ctrl is
    port (
        clk_i            : in std_logic;
        pause_o          : out std_logic;
        snes_mouse_btn_i : in snes_mouse_btn_r;

        snes_js_bus_i : in  snes_js_bus_i_r;
        snes_js_bus_o : out snes_js_bus_o_r;

        clock_indicator_o : out std_logic;
        latch_indicator_o : out std_logic
    );
end entity snes_mouse_ctrl;

architecture behavioral of snes_mouse_ctrl is
    -- latches the state of the buttons
    signal btn_r         : std_logic_vector(31 downto 0);
    signal btn_next_r    : std_logic_vector(31 downto 0);

    signal latch_r     : std_logic;
    signal ext_clock_r : std_logic;

    signal prev_latch_r : std_logic;
    signal prev_ext_clock_r : std_logic;

    signal latch_rising_s : std_logic;
    signal ext_clock_rising_s : std_logic;

    signal clk_counter_s : unsigned(15 downto 0);
    signal clk_counter_next_s : unsigned(15 downto 0);

    signal latch_counter_s : unsigned(15 downto 0);
    signal latch_counter_next_s : unsigned(15 downto 0);

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

    clock_indicator_o <= clk_counter_s(3);
    latch_indicator_o <= latch_counter_s(6);

    pause_o <= '0' when clk_counter_s > 31 else '1';

    snes_js_bus_o.data <= not(btn_r(0));

    comb_proc : process (ext_clock_rising_s, latch_r, btn_r, btn_next_r, clk_counter_s, latch_counter_s, latch_rising_s,
        snes_mouse_btn_i.left, snes_mouse_btn_i.right, snes_mouse_btn_i.y_direction, snes_mouse_btn_i.x_direction,
        snes_mouse_btn_i.y_motion, snes_mouse_btn_i.x_motion)
    begin
        btn_next_r <= btn_r;
        latch_counter_next_s <= latch_counter_s;
        clk_counter_next_s <= clk_counter_s;


        -- latch button state
        if latch_rising_s = '1' then
            latch_counter_next_s <= latch_counter_s + 1;
        elsif latch_r = '1' then
            btn_next_r(7 downto 0)      <= x"00"; -- unused
            btn_next_r(8)               <= snes_mouse_btn_i.left;
            btn_next_r(9)               <= snes_mouse_btn_i.right;
            btn_next_r(11 downto 10)    <= "00"; -- sensitivity
            btn_next_r(14 downto 12)    <= "000"; -- unused
            btn_next_r(15)              <= '1'; -- report mouse

            btn_next_r(16) <= snes_mouse_btn_i.y_direction;

            btn_next_r(17) <= snes_mouse_btn_i.y_motion(6);
            btn_next_r(18) <= snes_mouse_btn_i.y_motion(5);
            btn_next_r(19) <= snes_mouse_btn_i.y_motion(4);
            btn_next_r(20) <= snes_mouse_btn_i.y_motion(3);
            btn_next_r(21) <= snes_mouse_btn_i.y_motion(2);
            btn_next_r(22) <= snes_mouse_btn_i.y_motion(1);
            btn_next_r(23) <= snes_mouse_btn_i.y_motion(0);

            btn_next_r(24) <= snes_mouse_btn_i.x_direction;

            btn_next_r(25) <= snes_mouse_btn_i.x_motion(6);
            btn_next_r(26) <= snes_mouse_btn_i.x_motion(5);
            btn_next_r(27) <= snes_mouse_btn_i.x_motion(4);
            btn_next_r(28) <= snes_mouse_btn_i.x_motion(3);
            btn_next_r(29) <= snes_mouse_btn_i.x_motion(2);
            btn_next_r(30) <= snes_mouse_btn_i.x_motion(1);
            btn_next_r(31) <= snes_mouse_btn_i.x_motion(0);

            clk_counter_next_s <= x"0000";
        -- shift out our values
        elsif ext_clock_rising_s = '1' then
            for i in 0 to 30 loop
                btn_next_r(i) <= btn_r(i+1);
            end loop;
            btn_next_r(31) <= '0';

            clk_counter_next_s <= clk_counter_s + 1;
        end if;
    end process;
end;
