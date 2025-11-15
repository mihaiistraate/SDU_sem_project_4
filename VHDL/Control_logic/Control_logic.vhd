library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Control_logic is
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
end Control_logic;

architecture Behavioral of Control_logic is
    
    signal ready_int            : STD_LOGIC;
    signal processor_ready      : STD_LOGIC;
    signal clr_processor        : STD_LOGIC := '0';
    signal ENA_int              : STD_LOGIC;
    signal Store_R_ENA_int      : STD_LOGIC;

    component CMD_reader is
    Port   (
--            Next_cmd            : in STD_LOGIC_VECTOR(2 downto 0);
--            Next_cmd_out        : out STD_LOGIC_VECTOR(2 downto 0);
            ENA                 : in STD_LOGIC;
            CLK                 : in STD_LOGIC;
            Validity_in         : in STD_LOGIC;
            Store_empty         : in STD_LOGIC;
            Store_R_ENA         : out STD_LOGIC;
            Ready               : out STD_LOGIC
            );
    end component;
    
    component CMD_processor is
    Port   (
            Next_cmd            : in STD_LOGIC_VECTOR(2 downto 0);
            ENA                 : in STD_LOGIC;
            CLK                 : in STD_LOGIC;
            Ready               : out STD_LOGIC;
            Position_input      : in STD_LOGIC_VECTOR(2 downto 0);
            RST                 : in STD_LOGIC;
            Clr                 : in STD_LOGIC;
            Motor_up            : out STD_LOGIC;
            Motor_down          : out STD_LOGIC;
            Button_reset        : out STD_LOGIC_VECTOR(6 downto 0);
            Stop_motor          : in STD_LOGIC
            );
    end component;
    
    component JK_FF is
	Port   (
		    J        : in STD_LOGIC; 
		    K        : in STD_LOGIC; 
		    clk      : in STD_LOGIC; 
		    Q        : out STD_LOGIC 
	       ); 
	end component;   
    
begin

    u0: CMD_reader port map
    (ENA => ENA_int,
    CLK => CLK,
    Validity_in => Validity_in,
    Store_empty => Store_empty,
    Store_R_ENA => Store_R_ENA_int,
    Ready => ready_int);
    
    u1: CMD_processor port map
    (Next_cmd => Next_cmd,
    ENA => ready_int,
    CLK => CLK,
    Ready => processor_ready,
    Position_input => Position_input,
    RST => RST,
    Clr => clr_processor,
    Motor_up => Motor_up,
    Motor_down => Motor_down,
    Button_reset => Button_reset,
    Stop_motor => ENA); 
    
    u2: JK_FF port map
    (J => ENA,
    K => ready_int,
    clk => CLK,
    Q => ENA_int);
    
    Store_R_ENA <= Store_R_ENA_int;
    clr_processor <= processor_ready;
    
    test_out(0) <= ENA_int;
    test_out(1) <= ready_int;
    test_out(2) <= Validity_in;
    test_out(3) <= Store_empty;
    test_out(4) <= Store_R_ENA_int;
    test_out(5) <= '0';
    test_out(6) <= '0';
    
    
    


end Behavioral;
