library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Reset_formatter is
    Port(
        Reset_button        : in STD_LOGIC;
        Reset_pulse         : out STD_LOGIC;
        CLK                 : in STD_LOGIC
        );
end Reset_formatter;

architecture Behavioral of Reset_formatter is
    
    signal reset_int            : STD_LOGIC;

    component Debouncer is
    Generic (
        CLOCK_FREQUENCY : NATURAL   -- in Herz
        );
    Port ( 
        CLK    : in STD_LOGIC;
        Btn_on : in STD_LOGIC;
        Output : out STD_LOGIC
        );
    end component;
    
    component Edge_detector is
    Port(
        CLK          : in  STD_LOGIC;
        Input        : in  STD_LOGIC;
        Output_pulse : out STD_LOGIC := '0'
        );
    end component;
    
begin

    u0: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        Btn_on => Reset_button,
        Output => reset_int
        );
    
    u1: Edge_detector
    Port map (
        CLK          => CLK,
        Input        => reset_int,
        Output_pulse => Reset_pulse
        );    

end Behavioral;
