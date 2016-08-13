library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_nexys4ddr is
    port (
        clk_i : in std_logic;

        -- push buttons
        btnu_i : in std_logic;
        btnl_i : in std_logic;
        btnr_i : in std_logic;
        btnd_i : in std_logic;
        btnc_i : in std_logic;

        -- pmods
        --pmod_a_io : in std_logic_vector(10 downto 0);
        pmod_b_io : in std_logic_vector(10 downto 0);

        led_o    : out std_logic_vector(15 downto 0);
        switch_i : in std_logic_vector(15 downto 0)
    );
end entity top_nexys4ddr;

architecture behavioral of top_nexys4ddr is
begin
    tasty: entity work.tasty
        port map (
            clk_i => clk_i,

            rst_i => '0',

            btn_up_i    => btnu_i,
            btn_left_i  => btnl_i,
            btn_right_i => btnr_i,
            btn_down_i  => btnd_i,
            btn_a_i     => pmod_b_io(2),
            btn_b_i     => pmod_b_io(4),
            btn_x_i     => pmod_b_io(1),
            btn_y_i     => pmod_b_io(3),
            btn_start_i => btnc_i,

            -- joystick related i/o
            js_clock_i => switch_i(0),
            js_latch_i => switch_i(1),
            --js_data_o  => led_o(0)
            js_data_o => open,
            btnreg_o => led_o
        );
end;
