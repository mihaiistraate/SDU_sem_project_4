library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CMD_generator is
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
end CMD_generator;

architecture Behavioral of CMD_generator is


    signal lut_out_signal       : STD_LOGIC_VECTOR(2 downto 0);
    signal demux_out_signal     : STD_LOGIC_VECTOR(7 downto 0);
    signal demux_input          : STD_LOGIC := '1';
    signal clr_LUT              : STD_LOGIC := '0';
    signal ready_int            : STD_LOGIC;
    signal temp_sig             : STD_LOGIC;
    signal enable_int           : STD_LOGIC;
    
    
    component lut7to3 is
        Port(
        input           : in  STD_LOGIC_VECTOR(6 downto 0);
        output          : out STD_LOGIC_VECTOR(2 downto 0);
        ENA_LUT         : in STD_LOGIC;
        clr             : in STD_LOGIC;
        ready           : out STD_LOGIC;
        clk             : in STD_LOGIC
        );
    end component;
    
    component JK_FF is
	   Port(
		  J        : in STD_LOGIC; 
		  K        : in STD_LOGIC; 
		  clk      : in STD_LOGIC; 
		  Q        : out STD_LOGIC
	   );
	end component;
    
    component demux_1_to_8 is
        Port(
            input      : in STD_LOGIC;
            sel        : in STD_LOGIC_VECTOR (2 downto 0);
            output     : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

begin

    u0: lut7to3 port map
    (input(0) => Edge_detected_Input(0),
    input(1) => Edge_detected_Input(1),
    input(2) => Edge_detected_Input(2),
    input(3) => Edge_detected_Input(3),
    input(4) => Edge_detected_Input(4),
    input(5) => Edge_detected_Input(5),
    input(6) => Edge_detected_Input(6),
    output => lut_out_signal,
    ENA_LUT => enable_int,
    clr => clr_LUT,
    ready => ready_int,
    clk => CLK);
       
    u1: demux_1_to_8
    Port map(
        input => demux_input,
        sel => lut_out_signal,
        output => demux_out_signal
    );
    
    u2: JK_FF
    Port map(
        J => demux_out_signal(0),
        K => JK_reset_in(0),
        Q => Latched_Output_U0,
        clk => CLK
    );
    
    u3: JK_FF 
    Port map(
        J => demux_out_signal(1),
        K => JK_reset_in(1),
        Q => Latched_Output_U1,
        clk => CLK
    );
    
    u4: JK_FF
    Port map(
        J => demux_out_signal(2),
        K => JK_reset_in(2),
        Q => Latched_Output_D1,
        clk => CLK
    );
    
    u5: JK_FF
    Port map(
        J => demux_out_signal(3),
        K => JK_reset_in(3),
        Q => Latched_Output_D2,
        clk => CLK
    );
    
    u6: JK_FF
    Port map(
        J => demux_out_signal(4),
        K => JK_reset_in(4),
        Q => Latched_Output_B0,
        clk => CLK
    );
    
    u7: JK_FF
    Port map(
        J => demux_out_signal(5),
        K => JK_reset_in(5),
        Q => Latched_Output_B1,
        clk => CLK
    );
    
    u8: JK_FF
    Port map(
        J => demux_out_signal(6),
        K => JK_reset_in(6),
        Q => Latched_Output_B2,
        clk => CLK
    );
    
    LUT_Out <= lut_out_signal;
    demux_input <= '1';
    
    process(ready_int,CLK)
    begin
        if rising_edge(CLK) then
            Store_ENA <= ready_int;
            temp_sig <= ready_int;
            clr_LUT <= temp_sig;
         end if;
    end process;
    enable_int <= (not Store_full) and ENA;

end Behavioral;
