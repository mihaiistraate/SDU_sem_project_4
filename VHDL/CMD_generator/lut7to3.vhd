library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lut7to3 is
    Port (
        input      : in  STD_LOGIC_VECTOR(6 downto 0);
        output     : out STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
        ENA_LUT    : in STD_LOGIC;
        clr        : in STD_LOGIC;
        ready      : out STD_LOGIC;
        clk        : in STD_LOGIC
        );
end lut7to3;

architecture Behavioral of lut7to3 is
begin
--    process(input,ENA_LUT)
    process(ENA_LUT,clr,clk)
    begin
        if falling_edge(clk) then
             if ENA_LUT = '1' then
                if input(0) = '1' then output <= "001";
                elsif input(1) = '1' then output <= "010";
                elsif input(2) = '1' then output <= "011";
                elsif input(3) = '1' then output <= "100";
                elsif input(4) = '1' then output <= "101";
                elsif input(5) = '1' then output <= "110";
                elsif input(6) = '1' then output <= "111";
                else output <= "000";
                end if;
             else
                if clr = '1' then
                    output <= "000";
                end if;
             end if;
             ready <= ENA_LUT;
        end if;        
    end process;
end Behavioral;
