library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity User_button_formatter is
    Port (
        U0_input             : in STD_LOGIC;
        U1_input             : in STD_LOGIC;
        D1_input             : in STD_LOGIC;
        D2_input             : in STD_LOGIC;
        B0_input             : in STD_LOGIC;
        B1_input             : in STD_LOGIC;
        B2_input             : in STD_LOGIC;
        CLK                  : in STD_LOGIC;
        Edge_detected_output : out STD_LOGIC_VECTOR(6 downto 0);
        Pulse_out            : out STD_LOGIC
    );
end User_button_formatter;

architecture Behavioral of User_button_formatter is

signal Debounced_U0 : STD_LOGIC;
signal Debounced_U1 : STD_LOGIC;
signal Debounced_D1 : STD_LOGIC;
signal Debounced_D2 : STD_LOGIC;
signal Debounced_B0 : STD_LOGIC;
signal Debounced_B1 : STD_LOGIC;
signal Debounced_B2 : STD_LOGIC;
signal Edge_detected_output_signal : STD_LOGIC_VECTOR(6 downto 0);

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
        btn_on => U0_input,
        output => Debounced_U0
        );
                       
u1: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => U1_input,
        output => Debounced_U1
        );
                       
u2: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => D1_input,
        output => Debounced_D1
        );
                       
u3: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => D2_input,
        output => Debounced_D2
        );
                       
u4: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => B0_input,
        output => Debounced_B0
        );
                       
u5: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => B1_input,
        output => Debounced_B1
        );
                       
u6: Debouncer
    Generic map (
        CLOCK_FREQUENCY => 55000000
        )
    Port map (
        CLK    => CLK,
        btn_on => B2_input,
        output => Debounced_B2
        );

--Edge detectors
u7: edge_detector port map(CLK => CLK,
                           input => Debounced_U0,
                           output_pulse => Edge_detected_output_signal(0));
                           
u8: edge_detector port map(CLK => CLK,
                           input => Debounced_U1,
                           output_pulse => Edge_detected_output_signal(1));
                           
u9: edge_detector port map(CLK => CLK,
                           input => Debounced_D1,
                           output_pulse => Edge_detected_output_signal(2));
                           
u10: edge_detector port map(CLK => CLK,
                           input => Debounced_D2,
                           output_pulse => Edge_detected_output_signal(3));
                           
u11: edge_detector port map(CLK => CLK,
                           input => Debounced_B0,
                           output_pulse => Edge_detected_output_signal(4));
                           
u12: edge_detector port map(CLK => CLK,
                           input => Debounced_B1,
                           output_pulse => Edge_detected_output_signal(5));
                           
u13: edge_detector port map(CLK => CLK,
                           input => Debounced_B2,
                           output_pulse => Edge_detected_output_signal(6));
                           
Edge_detected_output <= Edge_detected_output_signal;                           
                           
Pulse_out <= (Edge_detected_output_signal(0) or Edge_detected_output_signal(1) or Edge_detected_output_signal(2)
              or Edge_detected_output_signal(3) or Edge_detected_output_signal(4) or Edge_detected_output_signal(5) or Edge_detected_output_signal(6));


end Behavioral;
