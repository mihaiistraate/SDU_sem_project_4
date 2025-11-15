library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX_8_to_1 is
    Port (
        Input  : in STD_LOGIC_VECTOR(7 downto 0);
        Sel    : in STD_LOGIC_VECTOR (2 downto 0);
        Output : out STD_LOGIC
        );
end MUX_8_to_1;

architecture Behavioral of MUX_8_to_1 is

begin
    process (Input, Sel)
    begin
        Output <= '0';
        case Sel is
            when "000" => Output <= Input(7);
            when "001" => Output <= Input(0);
            when "010" => Output <= Input(1);
            when "011" => Output <= Input(2);
            when "100" => Output <= Input(3);
            when "101" => Output <= Input(4);
            when "110" => Output <= Input(5);
            when "111" => Output <= Input(6);
            when others => Output <= '0';
        end case;
    end process;
end Behavioral;
