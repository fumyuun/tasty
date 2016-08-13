library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity;

architecture tb_arch of tb is
    signal clk_s : std_logic;
    signal rst_s : std_logic;

    signal btn_s : std_logic_vector(8 downto 0);

    signal js_clock_s : std_logic := '0';
    signal js_latch_s : std_logic := '0';
    signal js_data_s  : std_logic;

    signal clock_active_s : std_logic := '0';
begin
    clk_s <= '0';
    rst_s <= '1', '0' after 1 us;

    -- up & b
    btn_s <= "000100001";

    tasty: entity work.tasty
    port map (
        clk_i => clk_s,
        rst_i => rst_s,

        btn_up_i    => btn_s(0),
        btn_left_i  => btn_s(1),
        btn_right_i => btn_s(2),
        btn_down_i  => btn_s(3),
        btn_a_i     => btn_s(4),
        btn_b_i     => btn_s(5),
        btn_x_i     => btn_s(6),
        btn_y_i     => btn_s(7),
        btn_start_i => btn_s(8),

        js_clock_i => js_clock_s,
        js_latch_i => js_latch_s,
        js_data_o  => js_data_s
    );

    test_proc: process
    begin
        clock_active_s <= '0';

        wait for 10 us;
        js_latch_s <= '1';
        wait for 12 us;
        js_latch_s <= '0';
        wait for 6 us;
        clock_active_s <= '1';
        wait for 16*12 us;
        clock_active_s <= '0';

    end process;

    js_clock_s <= '0' when clock_active_s = '0' else not js_clock_s after 6 us;


end architecture tb_arch;