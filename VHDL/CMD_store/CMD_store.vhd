library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use STD.textio.all;                     -- basic I/O
--use IEEE.std_logic_textio.all;          -- I/O for logic types


entity CMD_store is
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
end CMD_store;

architecture Behavioral of CMD_store is
    
    signal mux_sel         : STD_LOGIC_VECTOR(2 downto 0);
    signal mux_input       : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

--    shared variable my_line : line;

    component Register_FIFO is
        Generic (
            FIFO_SIZE  : NATURAL;  -- Number of entries in the FIFO, max 32; above 32 use memory based FIFO
            FIFO_WIDTH : NATURAL   -- Data length in FIFO
        );
        Port (
            Clk         : in STD_LOGIC;        -- Clock signal
            Reset       : in STD_LOGIC;        -- Reset signal
            Data_in     : in STD_LOGIC_VECTOR((FIFO_WIDTH-1) downto 0); -- Data input
            Write_en    : in STD_LOGIC;        -- Write enable
            Read_en     : in STD_LOGIC;        -- Read enable
            Data_out    : out STD_LOGIC_VECTOR((FIFO_WIDTH-1) downto 0); -- Data output
            Full        : out STD_LOGIC;       -- Full flag
            Empty       : out STD_LOGIC        -- Empty flag
        );
    end component;
    
    component MUX_8_to_1 is
        Port (
            Input  : in STD_LOGIC_VECTOR(7 downto 0);
            Sel    : in STD_LOGIC_VECTOR (2 downto 0);
            Output : out STD_LOGIC
            );
    end component;
    
begin
    u0: Register_FIFO 
        Generic map (
            FIFO_SIZE  => 32,
            FIFO_WIDTH => 3
            )
        Port map (
            Clk      => Clk,
            Reset    => Reset,
            Data_in  => CMD_input,
            Write_en => Write_enable,
            Read_en  => Read_enable,
            Data_out => mux_sel,
            Empty    => Empty,
            Full     => Store_full
            );
    
    u1: MUX_8_to_1
        Port map (
            Input  => mux_input,
            Sel    => mux_sel,
            Output => Validity_out
            );

    mux_input(0) <= LED_states(0);
    mux_input(1) <= LED_states(1);
    mux_input(2) <= LED_states(2);
    mux_input(3) <= LED_states(3);
    mux_input(4) <= LED_states(4);
    mux_input(5) <= LED_states(5);
    mux_input(6) <= LED_states(6);
    
    mux_input(7) <= '0';
    
    CMD_output <= mux_sel;
--    CMD_output <= "000";
    

end Behavioral;
