library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.snes_lib.all;

entity js_generator is
    port (
        clk_i   : in std_logic;
        rst_i   : in std_logic;
        pause_i : in std_logic;
        pc_o    : out std_logic_vector(15 downto 0);
        dropped_o : out std_logic_vector(15 downto 0);
        js_o    : out snes_js_btn_r
    );
end entity js_generator;

architecture behavioral of js_generator is
    signal address_s  : std_logic_vector(15 downto 0) := x"0000";
    signal address_next_s : std_logic_vector(15 downto 0);
    signal data_s : std_logic_vector(15 downto 0);

    signal cycle_count_s : unsigned(31 downto 0);
    signal cycle_count_next_s : unsigned(31 downto 0);

    signal dropped_count_s      : unsigned(15 downto 0);
    signal dropped_count_next_s : unsigned(15 downto 0);

    signal received_r : std_logic;
    signal received_next_r : std_logic;
begin
    rom16_0: entity work.rom16
    port map (
        clk_i  => clk_i,
        address_i  => address_s,
        data_o => data_s
    );

    pc_o <= address_s;

    dropped_o <= std_logic_vector(dropped_count_s(15 downto 0));

    clock_proc: process (clk_i, rst_i)
    begin
        if rst_i = '1' then
            received_r <= '0';
            address_s <= x"0000";
            cycle_count_s <= x"00000000";
            dropped_count_s <= x"0000";
        elsif rising_edge(clk_i) then
            address_s <= address_next_s;
            received_r <= received_next_r;
            cycle_count_s <= cycle_count_next_s;
            dropped_count_s <= dropped_count_next_s;
        end if;
    end process;

    comb_proc: process(pause_i, address_s, cycle_count_s, received_r)
    begin
        address_next_s <= address_s;
        received_next_r <= received_r;
        cycle_count_next_s <= cycle_count_s;
        dropped_count_next_s <= dropped_count_s;

        --if cycle_count_s > x"196E6B" then -- 60Hz
        if cycle_count_s > x"1E8480" + x"1E8" then -- 50Hz + some small buffer
            -- timeout frame
            address_next_s <= std_logic_vector(unsigned(address_s) + 1);
            received_next_r <= '0';
            cycle_count_next_s <= x"00000000";
            dropped_count_next_s <= dropped_count_s + 1;

        elsif pause_i = '0' and received_r = '1' then
            address_next_s <= std_logic_vector(unsigned(address_s) + 1);
            received_next_r <= '0';
            cycle_count_next_s <= x"00000000";
        elsif pause_i = '1' and received_r = '0' then
            received_next_r <= '1';
            cycle_count_next_s <= cycle_count_s + 1;
        else
            cycle_count_next_s <= cycle_count_s + 1;
        end if;
    end process;

    js_o.b     <= data_s(0);
    js_o.y     <= data_s(1);
    js_o.sel   <= data_s(2);
    js_o.start <= data_s(3);
    js_o.up    <= data_s(4);
    js_o.down  <= data_s(5);
    js_o.left  <= data_s(6);
    js_o.right <= data_s(7);
    js_o.a     <= data_s(8);
    js_o.x     <= data_s(9);
    js_o.l     <= data_s(10);
    js_o.r     <= data_s(11);

end architecture;
