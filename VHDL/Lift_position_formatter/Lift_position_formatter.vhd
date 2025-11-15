library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lift_position_formatter is
    Port (
        S0A_input             : in STD_LOGIC;
        S0B_input             : in STD_LOGIC;
        S1A_input             : in STD_LOGIC;
        S1B_input             : in STD_LOGIC;
        S2A_input             : in STD_LOGIC;
        S2B_input             : in STD_LOGIC;
        CLK                   : in STD_LOGIC;
        Debounced_output      : out STD_LOGIC_VECTOR(2 downto 0);
        Pulse_out             : out STD_LOGIC
    );
end Lift_position_formatter;

architecture Behavioral of Lift_position_formatter is

signal Debounced_S0A            : STD_LOGIC;
signal Debounced_S0B            : STD_LOGIC;
signal Debounced_S1A            : STD_LOGIC;
signal Debounced_S1B            : STD_LOGIC;
signal Debounced_S2A            : STD_LOGIC;
signal Debounced_S2B            : STD_LOGIC;
signal Debounced_output_signal  : STD_LOGIC_VECTOR(2 downto 0);
signal Edge_detected_S0AB       : STD_LOGIC;
signal Edge_detected_S1AB       : STD_LOGIC;
signal Edge_detected_S2AB       : STD_LOGIC;

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

component edge_detector is
    Port (
        CLK                       : in  STD_LOGIC;
        input                     : in  STD_LOGIC;
        output_pulse              : out STD_LOGIC
        );
end component;

begin

--Debouncers
u0: Debouncer 
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S0A_input,
        output => Debounced_S0A
        );
                       
u1: Debouncer 
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S0B_input,
        output => Debounced_S0B
        );
                       
u2: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S1A_input,
        output => Debounced_S1A
        );
                       
u3: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S1B_input,
        output => Debounced_S1B
        );
                       
u4: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S2A_input,
        output => Debounced_S2A
        );
                       
u5: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => S2B_input,
        output => Debounced_S2B
        );

--Edge detectors
u6: edge_detector
    Port map (
        CLK => CLK,
        input => Debounced_output_signal(0),
        output_pulse => Edge_detected_S0AB
        );
                           
u7: edge_detector
    Port map (
        CLK => CLK,
        input => Debounced_output_signal(1),
        output_pulse => Edge_detected_S1AB
        );
                           
u8: edge_detector
    Port map (
        CLK => CLK,
        input => Debounced_output_signal(2),
        output_pulse => Edge_detected_S2AB
        );
                           
Debounced_output_signal(0) <= (Debounced_S0A and Debounced_S0B);
Debounced_output_signal(1) <= (Debounced_S1A and Debounced_S1B);
Debounced_output_signal(2) <= (Debounced_S2A and Debounced_S2B);
                           
Debounced_output <= Debounced_output_signal;                         
                           
Pulse_out <= (Edge_detected_S0AB or Edge_detected_S1AB or Edge_detected_S2AB);


end Behavioral;
