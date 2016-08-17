library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package memory_pkg is
    subtype address8_t  is integer range 0 to 2**8 - 1;
    subtype address16_t is natural range 0 to 2**16 - 1;
    subtype v16_t is std_logic_vector(15 downto 0);

    type rom8x16_t  is array(address8_t)  of v16_t;
    type rom16x16_t is array(address16_t) of v16_t;
end package memory_pkg;
