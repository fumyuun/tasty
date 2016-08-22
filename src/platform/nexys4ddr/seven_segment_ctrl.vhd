library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seven_segment_ctrl is
    port (
        clk_i : in std_logic;
        num_i : in std_logic_vector(31 downto 0);

        an_o  : out std_logic_vector(7 downto 0);
        c_o   : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of seven_segment_ctrl is

    signal active_digit_s     : std_logic_vector(3 downto 0);
    signal pattern_s          : std_logic_vector(7 downto 0);
    signal digit_s            : unsigned(3 downto 0);
    signal turn_s             : unsigned(2 downto 0); -- who's turn is it?
    signal turn_next_s        : unsigned(2 downto 0);
    signal cycle_count_s      : unsigned(15 downto 0); -- on overflow (every 65,535 cycles, increment turn)
    signal cycle_count_next_s : unsigned(15 downto 0);
begin

    an_o <= "11111110" when turn_s = 0 else
            "11111101" when turn_s = 1 else
            "11111011" when turn_s = 2 else
            "11110111" when turn_s = 3 else
            "11101111" when turn_s = 4 else
            "11011111" when turn_s = 5 else
            "10111111" when turn_s = 6 else
            "01111111" when turn_s = 7 else
            "11111111";

    c_o <= pattern_s;

    active_digit_s <= num_i(1 * 4 - 1 downto 0 * 4) when turn_s = 0 else
                      num_i(2 * 4 - 1 downto 1 * 4) when turn_s = 1 else
                      num_i(3 * 4 - 1 downto 2 * 4) when turn_s = 2 else
                      num_i(4 * 4 - 1 downto 3 * 4) when turn_s = 3 else
                      num_i(5 * 4 - 1 downto 4 * 4) when turn_s = 4 else
                      num_i(6 * 4 - 1 downto 5 * 4) when turn_s = 5 else
                      num_i(7 * 4 - 1 downto 6 * 4) when turn_s = 6 else
                      num_i(8 * 4 - 1 downto 7 * 4) when turn_s = 7 else
                      x"0";

    digit_s <= unsigned(active_digit_s);

    pattern_s <= "00000011" when digit_s = x"0" else
                 "10011111" when digit_s = x"1" else
                 "00100101" when digit_s = x"2" else
                 "00001101" when digit_s = x"3" else
                 "10011001" when digit_s = x"4" else
                 "01001001" when digit_s = x"5" else
                 "01000001" when digit_s = x"6" else
                 "00011111" when digit_s = x"7" else
                 "00000001" when digit_s = x"8" else
                 "00001001" when digit_s = x"9" else
                 "00010001" when digit_s = x"A" else
                 "11000001" when digit_s = x"B" else
                 "01100011" when digit_s = x"C" else
                 "10000101" when digit_s = x"D" else
                 "01100001" when digit_s = x"E" else
                 "01110001" when digit_s = x"F" else
                 "11111111";

    clock_proc : process (clk_i)
    begin
        if rising_edge(clk_i) then
            turn_s <= turn_next_s;
            cycle_count_s <= cycle_count_next_s;
        end if;
    end process;

    comb_proc : process (cycle_count_s)
    begin
        turn_next_s <= turn_s;
        cycle_count_next_s <= cycle_count_s + 1;
        if cycle_count_s = x"FFFF" then
            turn_next_s <= turn_s + 1;
            cycle_count_next_s <= x"0000";
        end if;
    end process;
end architecture;
