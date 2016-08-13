library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tasty is
    port (
        clk_i     : in std_logic;
        rst_i     : in std_logic;

        -- buttons
        btn_up_i    : in std_logic;
        btn_left_i  : in std_logic;
        btn_right_i : in std_logic;
        btn_down_i  : in std_logic;
        btn_a_i     : in std_logic;
        btn_b_i     : in std_logic;
        btn_x_i     : in std_logic;
        btn_y_i     : in std_logic;
        btn_start_i : in std_logic;

        -- joystick related i/o
        js_clock_i : in  std_logic;
        js_latch_i : in  std_logic;
        js_data_o  : out std_logic;

        -- debug
        btnreg_o : out std_logic_vector(15 downto 0)
    );
end entity tasty;

architecture behavioral of tasty is
    -- latches the state of the buttons
    signal btn_r : std_logic_vector(15 downto 0);

begin
    btnreg_o <= btn_r;
    js_data_o <= btn_r(0);

    clk_proc : process (js_latch_i, js_clock_i,
        btn_up_i, btn_left_i, btn_right_i, btn_down_i,
        btn_a_i, btn_b_i, btn_x_i, btn_y_i, btn_start_i)
    begin
        -- latch button state
        if js_latch_i = '1' then
            btn_r(0) <= btn_b_i;
            btn_r(1) <= btn_y_i;
            btn_r(2) <= '0';    -- select
            btn_r(3) <= btn_start_i;
            btn_r(4) <= btn_up_i;
            btn_r(5) <= btn_down_i;
            btn_r(6) <= btn_left_i;
            btn_r(7) <= btn_right_i;
            btn_r(8) <= btn_a_i;
            btn_r(9) <= btn_x_i;
            btn_r(10) <= '0'; -- l
            btn_r(11) <= '0'; -- r
            btn_r(15 downto 12) <= "1111"; -- unused bits
        -- shift out our values
        elsif rising_edge(js_clock_i) then
            for i in 0 to 14 loop
                btn_r(i) <= btn_r(i+1);
            end loop;
            btn_r(15) <= '0';
        end if;
    end process;
end;
