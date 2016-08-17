library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.memory_pkg.rom16x16_t;

entity rom16 is
    port (
        clk_i     : in std_logic;
        address_i : in std_logic_vector(15 downto 0);
        data_o    : out std_logic_vector(15 downto 0)
    );
end entity rom16;

architecture behavioral of rom16 is

    constant rom_lut : rom16x16_t := (
        100 => x"0001",
        200 => x"0002",
        300 => x"0004",
        400 => x"0008",
        500 => x"0001",
        600 => x"0002",
        800 => x"0003",
        900 => x"0004",
        1000 => x"0008",
        1100 => x"0001",
        1200 => x"0002",
        1300 => x"0003",
        others => X"0000"
    );

begin

    clock_proc: process(clk_i)
    begin
        if rising_edge(clk_i) then
            data_o <= rom_lut(to_integer(unsigned(address_i)));
        end if;
    end process;

end architecture;