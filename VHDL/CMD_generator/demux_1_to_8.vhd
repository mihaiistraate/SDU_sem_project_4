library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_1_to_8 is
    Port(
        input   : in STD_LOGIC;
        sel     : in STD_LOGIC_VECTOR (2 downto 0);
        output  : out STD_LOGIC_VECTOR (7 downto 0)
        );
end demux_1_to_8;

architecture Behavioral of demux_1_to_8 is

begin
    process (sel, input)
    begin
        output <= "00000000";
        case sel is
            when "000" => output(7) <= input;
            when "001" => output(0) <= input;
            when "010" => output(1) <= input;
            when "011" => output(2) <= input;
            when "100" => output(3) <= input;
            when "101" => output(4) <= input;
            when "110" => output(5) <= input;
            when "111" => output(6) <= input;
            when others => output <= "00000000";
        end case;
    end process;
end Behavioral;
