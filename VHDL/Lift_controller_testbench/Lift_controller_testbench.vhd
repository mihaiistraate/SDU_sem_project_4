library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lift_controller_testbench is
end Lift_controller_testbench;

architecture behavior of Lift_controller_testbench is

    -- Component under test
    component Lift_controller
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
            test_out : out STD_LOGIC_VECTOR(6 downto 0);
            Motor_down : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal U0         : STD_LOGIC := '0';     
    signal U1         : STD_LOGIC := '0';     
    signal D1         : STD_LOGIC := '0';     
    signal D2         : STD_LOGIC := '0';     
    signal B0         : STD_LOGIC := '0';     
    signal B1         : STD_LOGIC := '0';     
    signal B2         : STD_LOGIC := '0';     
    signal S0A        : STD_LOGIC := '0';     
    signal S0B        : STD_LOGIC := '0';     
    signal S1A        : STD_LOGIC := '0';     
    signal S1B        : STD_LOGIC := '0';     
    signal S2A        : STD_LOGIC := '0';     
    signal S2B        : STD_LOGIC := '0';     
    signal Reset      : STD_LOGIC := '0';     
    signal clk        : STD_LOGIC; 
    signal LED_U0     : STD_LOGIC;
    signal LED_U1     : STD_LOGIC;
    signal LED_D1     : STD_LOGIC;
    signal LED_D2     : STD_LOGIC;
    signal LED_B0     : STD_LOGIC;
    signal LED_B1     : STD_LOGIC;
    signal LED_B2     : STD_LOGIC;
    signal Motor_up   : STD_LOGIC := '0';
    signal Motor_down : STD_LOGIC := '0'; 
    signal test_out : STD_LOGIC_VECTOR(6 downto 0);
    
    -- Clock period
    constant clk_period : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Lift_controller
        Port map (
            U0         => U0        ,
            U1         => U1        ,
            D1         => D1        ,
            D2         => D2        ,
            B0         => B0        ,
            B1         => B1        ,
            B2         => B2        ,
            S0A        => S0A       ,
            S0B        => S0B       ,
            S1A        => S1A       ,
            S1B        => S1B       ,
            S2A        => S2A       ,
            S2B        => S2B       ,
            Reset      => Reset     ,
            clk        => clk       ,
            LED_U0     => LED_U0    ,
            LED_U1     => LED_U1    ,
            LED_D1     => LED_D1    ,
            LED_D2     => LED_D2    ,
            LED_B0     => LED_B0    ,
            LED_B1     => LED_B1    ,
            LED_B2     => LED_B2    ,
            Motor_up   => Motor_up  ,
            test_out => test_out,
            Motor_down => Motor_down
            );

    -- Clock Process
    clk_process :process
    begin
         clk <= '0';
         wait for clk_period/2;  --for 10 ns signal is '0'.
         clk <= '1';
         wait for clk_period/2;  --for next 10 ns signal is '1'.
    end process;

    -- Stimulus process
    stim_proc: process
    begin
            
        --Putting inputs 
        wait for 10 ns;   
        S1A <= '1';
        S1B <= '1';
        wait for 50 ns;
        Reset <= '1';
        wait for 110 ns;
        Reset <= '0';
        S1A <= '0';
        S1B <= '0';
        wait for 200 ns;
        S0A <= '1';
        S0B <= '1';
        wait for 80 ns;
        wait for 50 ns;
        B1 <= '1';
        wait for 100 ns;
        B2 <= '1';
        wait for 40 ns;
        B1 <= '0';
        wait for 60 ns;
        B2 <= '0';
        wait for 100 ns;
        S0A <= '0';
        S0B <= '0';
        wait for 600 ns;
        S1A <= '1';
        S1B <= '1';
        wait for 300 ns;
        S1A <= '0';
        S1B <= '0';
        wait for 300 ns;
        S2A <= '1';
        S2B <= '1';
       
        
        
        
        wait;
    end process;

end behavior;
