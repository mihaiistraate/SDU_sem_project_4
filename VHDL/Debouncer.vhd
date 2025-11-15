library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Generic (
        CLOCK_FREQUENCY : NATURAL := 55000000  -- in Herz
        );
    Port ( 
        CLK    : in STD_LOGIC;
        Btn_on : in STD_LOGIC;
        Output : out STD_LOGIC := '0'
        );
end Debouncer;

architecture Behavioral of Debouncer is

signal ff : STD_LOGIC_VECTOR(1 downto 0);
signal counter_reset : STD_LOGIC;

begin

counter_reset <= ff(0) xor ff(1);

process (clk)
    variable Counter : NATURAL RANGE 0 to CLOCK_FREQUENCY/100;  -- 10ms stable time
begin
    if rising_edge(CLK) then
        ff(0) <= Btn_on;
        ff(1) <= ff(0);
        if counter_reset = '1' then
            Counter := 0;
        elsif Counter < CLOCK_FREQUENCY/100 then
            Counter := Counter + 1;
        else
            Output <= ff(1);
        end if;
    end if;
end process;

end Behavioral;
