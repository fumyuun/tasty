library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ps2_ctrl is
    port (
        clk_i   : in std_logic;
        ps2_clk_io  :  inout std_logic;
        ps2_data_io : inout std_logic;

        mouse_connected_o : out std_logic
    );
end entity;

architecture behavioral of ps2_ctrl is
    -- register that holds if we detected a mouse
    signal mouse_connected_r : std_logic := '0';

    -- used to take control of the bus
    signal transmitting_s : std_logic := '0';
    -- when taking control, these are our outputs
    signal ps2_clk_o_s  : std_logic;
    signal ps2_data_o_s : std_logic;

    -- otherwise, these are our inputs
    signal ps2_clk_i_s  : std_logic;
    signal ps2_data_i_s : std_logic;

    -- detect a rising edge
    signal ps2_clk_i_prev_r : std_logic;
    signal ps2_clk_i_r      : std_logic;
    signal ps2_clk_rising_s : std_logic;

    signal data_i_s        : std_logic_vector(7 downto 0);
    signal data_i_valid_s  : std_logic;
    signal data_i_done_s   : std_logic;
    signal receiving_bit_s : natural range 0 to 11;

    signal data_i_next_s        : std_logic_vector(7 downto 0);
    signal data_i_valid_next_s  : std_logic;
    signal data_i_done_next_s   : std_logic;
    signal receiving_bit_next_s : natural range 0 to 11;
begin
    ps2_clk_io  <= 'Z' when transmitting_s = '0' else ps2_clk_o_s;
    ps2_data_io <= 'Z' when transmitting_s = '0' else ps2_data_o_s;

    ps2_clk_i_s  <= ps2_clk_io  when transmitting_s = '0' else '0';
    ps2_data_i_s <= ps2_data_io when transmitting_s = '0' else '0';

    mouse_connected_o <= mouse_connected_r;

    ps2_clk_rising_s <= '1' when transmitting_s = '0' and ps2_clk_i_prev_r = '0' and ps2_clk_i_r = '1' else '0';

    clk_proc : process (clk_i)
    begin
        if rising_edge(clk_i) then
            ps2_clk_i_prev_r <= ps2_clk_i_r;
            ps2_clk_i_r      <= ps2_clk_i_s;

            receiving_bit_s <= receiving_bit_next_s;
            data_i_s        <= data_i_next_s;
            data_i_valid_s  <= data_i_valid_next_s;
            data_i_done_s   <= data_i_done_next_s;
        end if;
    end process;

    read_bit_comb_proc : process (ps2_clk_rising_s, receiving_bit_s, data_i_s, data_i_valid_s)
    begin
        receiving_bit_next_s <= receiving_bit_s;
        data_i_next_s        <= data_i_s;
        data_i_valid_next_s  <= data_i_valid_s;
        data_i_done_next_s   <= data_i_done_s;

        if ps2_clk_rising_s = '1' then
            if receiving_bit_s = 0 then
                -- first bit should be start bit 0
                if ps2_data_i_s = '0' then
                    data_i_done_next_s <= '0';
                    data_i_valid_next_s <= '0';
                    receiving_bit_next_s <= receiving_bit_s + 1;
                else
                    data_i_done_next_s <= '1';
                    data_i_valid_next_s <= '0';
                    receiving_bit_next_s <= 0;
                end if;

            elsif receiving_bit_s < 8 then
                data_i_done_next_s  <= '0';
                data_i_valid_next_s <= '0';
                data_i_next_s(receiving_bit_s - 1) <= ps2_data_i_s;
                receiving_bit_next_s <= receiving_bit_s + 1;

            elsif receiving_bit_s = 9 then
                -- odd parity bit, ignore for now
                data_i_done_next_s  <= '0';
                data_i_valid_next_s <= '0';
                receiving_bit_next_s <= receiving_bit_s + 1;

            elsif receiving_bit_s = 10 then
                -- stop bit 1
                if ps2_data_i_s = '1' then
                    data_i_done_next_s   <= '1';
                    data_i_valid_next_s  <= '1';
                    receiving_bit_next_s <= 0;
                else
                    data_i_done_next_s <= '1';
                    data_i_valid_next_s <= '0';
                    receiving_bit_next_s <= 0;
                end if;
            end if;
        end if;
    end process;

    read_byte_comb_proc : process (data_i_done_s, data_i_valid_s, data_i_s)
    begin
        if data_i_done_s = '1' and data_i_valid_s = '1' and data_i_s = x"AA" then
            mouse_connected_r <= '1';
        else
            mouse_connected_r <= '0';
        end if;
    end process;

end architecture;
