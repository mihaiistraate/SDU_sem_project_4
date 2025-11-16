library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lift_controller is
    Port (
        U0         : in STD_LOGIC;
        U1         : in STD_LOGIC;
        D1         : in STD_LOGIC;
        D2         : in STD_LOGIC;
        B0         : in STD_LOGIC;
        B1         : in STD_LOGIC;
        B2         : in STD_LOGIC;
        S0A        : in STD_LOGIC;
        S0B        : in STD_LOGIC;
        S1A        : in STD_LOGIC;
        S1B        : in STD_LOGIC;
        S2A        : in STD_LOGIC;
        S2B        : in STD_LOGIC;
        Reset      : in STD_LOGIC;
        clk        : in STD_LOGIC;
        LED_U0     : out STD_LOGIC;
        LED_U1     : out STD_LOGIC;
        LED_D1     : out STD_LOGIC;
        LED_D2     : out STD_LOGIC;
        LED_B0     : out STD_LOGIC;
        LED_B1     : out STD_LOGIC;
        LED_B2     : out STD_LOGIC;
        Motor_up   : out STD_LOGIC;
        test_out   : out STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
        Motor_down : out STD_LOGIC
    );
end Lift_controller;

architecture Behavioral of Lift_controller is


    signal reset_sig           : STD_LOGIC;
    signal lift_position       : STD_LOGIC_VECTOR(2 downto 0);
    signal lift_position_pulse : STD_LOGIC;
    signal user_buttons        : STD_LOGIC_VECTOR(6 downto 0);
    signal user_buttons_pulse  : STD_LOGIC;
    signal jk_reset_sig        : STD_LOGIC_VECTOR(6 downto 0);
    signal cmd_sig             : STD_LOGIC_VECTOR(2 downto 0);
    signal store_ena_sig       : STD_LOGIC;
    signal store_full_sig      : STD_LOGIC;
    signal read_ena_sig        : STD_LOGIC;
    signal next_cmd_sig        : STD_LOGIC_VECTOR(2 downto 0);
    signal store_empty_sig     : STD_LOGIC;
    signal led_states_sig      : STD_LOGIC_VECTOR(6 downto 0);
    signal validity_sig        : STD_LOGIC;
    signal test_out_sig        : STD_LOGIC_VECTOR(6 downto 0);
    
    
    component Reset_formatter is
        Port(
            Reset_button        : in STD_LOGIC;
            Reset_pulse         : out STD_LOGIC;
            CLK                 : in STD_LOGIC
            );
    end component;

    component Lift_position_formatter is
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
    end component;

    component User_button_formatter is
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
    end component;

    component CMD_generator is
        Port (
            Edge_detected_input  : in  STD_LOGIC_VECTOR(6 downto 0);
            ENA                  : in  STD_LOGIC;
            JK_reset_in          : in  STD_LOGIC_VECTOR(6 downto 0);
            CLK                  : in STD_LOGIC;
            Latched_Output_U0    : out STD_LOGIC;
            Latched_Output_U1    : out STD_LOGIC;
            Latched_Output_D1    : out STD_LOGIC;
            Latched_Output_D2    : out STD_LOGIC;
            Latched_Output_B0    : out STD_LOGIC;
            Latched_Output_B1    : out STD_LOGIC;
            Latched_Output_B2    : out STD_LOGIC;
            LUT_out              : out STD_LOGIC_VECTOR(2 downto 0);
            Store_ENA            : out STD_LOGIC;
            Store_full           : in STD_LOGIC
        );
    end component;

    component CMD_store is
        Port (
            CMD_input    : in STD_LOGIC_VECTOR(2 downto 0);
            Write_enable : in STD_LOGIC;
            Reset        : in STD_LOGIC;
            Clk          : in STD_LOGIC;
            Read_enable  : in STD_LOGIC;
            CMD_output   : out STD_LOGIC_VECTOR(2 downto 0);
            Empty        : out STD_LOGIC;
            LED_states   : in STD_LOGIC_VECTOR(6 downto 0);
            Validity_out : out STD_LOGIC;
            Store_full   : out STD_LOGIC
            );
    end component;

    component Control_logic is
        Port (
            Next_cmd            : in STD_LOGIC_VECTOR(2 downto 0);
            Position_input      : in STD_LOGIC_VECTOR(2 downto 0);
            ENA                 : in STD_LOGIC;
            CLK                 : in STD_LOGIC;
            Validity_in         : in STD_LOGIC;
            RST                 : in STD_LOGIC;
            Store_empty         : in STD_LOGIC;
            Motor_up            : out STD_LOGIC;
            Motor_down          : out STD_LOGIC;
            Button_reset        : out STD_LOGIC_VECTOR(6 downto 0);
            test_out            : out STD_LOGIC_VECTOR(6 downto 0);
            Store_R_ENA         : out STD_LOGIC
            );
    end component;
    
    begin
    
    unit0: Reset_formatter
        Port map(
            Reset_button        => Reset,
            Reset_pulse         => reset_sig,
            CLK                 => clk
            );
    
    unit1: Lift_position_formatter
        Port map (
            S0A_input           => S0A,              
            S0B_input           => S0B,
            S1A_input           => S1A,
            S1B_input           => S1B,
            S2A_input           => S2A,
            S2B_input           => S2B,
            CLK                 => clk,
            Debounced_output    => lift_position,
            Pulse_out           => lift_position_pulse
            );
   
    unit2: User_button_formatter
        Port map (
            U0_input            => U0,            
            U1_input            => U1,
            D1_input            => D1,
            D2_input            => D2,
            B0_input            => B0,
            B1_input            => B1,
            B2_input            => B2,
            CLK                 => clk,
            Edge_detected_output => user_buttons,
            Pulse_out           => user_buttons_pulse
            );
            
    unit3: CMD_generator
        Port map (
            Edge_detected_input => user_buttons, 
            ENA                 => user_buttons_pulse,
            JK_reset_in         => jk_reset_sig,
            CLK                 => clk,
            Latched_Output_U0   => led_states_sig(0),
            Latched_Output_U1   => led_states_sig(1),
            Latched_Output_D1   => led_states_sig(2),
            Latched_Output_D2   => led_states_sig(3),
            Latched_Output_B0   => led_states_sig(4),
            Latched_Output_B1   => led_states_sig(5),
            Latched_Output_B2   => led_states_sig(6),
            LUT_out             => cmd_sig,       
            Store_ENA           => store_ena_sig,
            Store_full          => store_full_sig
            );
            
    unit4: CMD_store
        Port map (
            CMD_input    => cmd_sig,       
            Write_enable => store_ena_sig,
            Reset        => reset_sig,
            Clk          => clk,
            Read_enable  => read_ena_sig,
            CMD_output   => next_cmd_sig,
            Empty        => store_empty_sig,
            LED_states   => led_states_sig,
            Validity_out => validity_sig,
            Store_full   => store_full_sig
            );
            
    unit5: Control_logic
        Port map (
            Next_cmd       => next_cmd_sig,    
            Position_input => lift_position,
            ENA            => lift_position_pulse,
            CLK            => clk,
            Validity_in    => validity_sig,
            RST            => reset_sig,
            Store_empty    => store_empty_sig,
            Motor_up       => Motor_up,
            Motor_down     => Motor_down,
            Button_reset   => jk_reset_sig,
            test_out       => test_out_sig,
            Store_R_ENA    => read_ena_sig
            );
            
    LED_U0 <= led_states_sig(0);
    LED_U1 <= led_states_sig(1);
    LED_D1 <= led_states_sig(2);
    LED_D2 <= led_states_sig(3);
    LED_B0 <= led_states_sig(4);
    LED_B1 <= led_states_sig(5);
    LED_B2 <= led_states_sig(6);
    
    test_out(0) <= jk_reset_sig(0);
    test_out(1) <= jk_reset_sig(1);
    test_out(2) <= jk_reset_sig(2);
    test_out(3) <= jk_reset_sig(3);
    test_out(4) <= jk_reset_sig(4);
    test_out(5) <= jk_reset_sig(5);
    test_out(6) <= lift_position_pulse;
    
    

end Behavioral;
