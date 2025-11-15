library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity Edge_detector is
    Port (
        CLK                 : in  STD_LOGIC;
        Input               : in  STD_LOGIC;
        Output_pulse        : out STD_LOGIC := '0');
end Edge_detector;

architecture Behavioral of edge_detector is

    signal r0_input         : STD_LOGIC;
    signal r1_input         : STD_LOGIC;
    
begin
    
    process(CLK)
    begin
      if rising_edge(CLK) then
        r0_input           <= input;
        r1_input           <= r0_input;
      end if;
    end process;
    
    output_pulse            <= (not r1_input) and r0_input;

end Behavioral;
