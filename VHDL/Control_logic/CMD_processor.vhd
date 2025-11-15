library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CMD_processor is
    Port   (
            Next_cmd            : in STD_LOGIC_VECTOR(2 downto 0);
            ENA                 : in STD_LOGIC;
            CLK                 : in STD_LOGIC;
            Ready               : out STD_LOGIC;
            Position_input      : in STD_LOGIC_VECTOR(2 downto 0);
            RST                 : in STD_LOGIC;
            Clr                 : in STD_LOGIC;
            Motor_up            : out STD_LOGIC := '0';
            Motor_down          : out STD_LOGIC := '0';
            Button_reset        : out STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
            Stop_motor          : in STD_LOGIC
            );
end CMD_processor;

architecture Behavioral of CMD_processor is
    
    signal State                : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Next_state           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal temp_sig             : STD_LOGIC;

begin
    process(CLK,State,Next_cmd,Position_input,ENA,RST,Clr,Stop_motor) is
    begin
        if RST = '1' then
            State <= "000";
            Button_reset <= "1111111";
            Motor_up <= '0';
            Ready <= RST;
            if Position_input /= "001" then
                Motor_down <= '1';
                Next_state <= "000";
            else
                Next_state <= "110";
                Motor_down <= '0';
            end if;
        else
            if rising_edge(CLK) then
                State <= Next_state;
                temp_sig <= ENA;
                Ready <= temp_sig;
            end if;
            if ENA = '1' then
                case State is
                    when "000" =>       --lift is stationary on 0 floor
                        if  Next_cmd = "001" and Position_input = "001" then        --U0 outside button pressed
                            Next_state <= "000";
                            Motor_up  <= '0';
                            Motor_down <= '0';
                        elsif  Next_cmd = "010" and Position_input = "001" then     --U1 outside button pressed
                            Next_state <= "011";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        elsif  Next_cmd = "011" and Position_input = "001" then     --D1 outside button pressed
                            Next_state <= "011";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        elsif  Next_cmd = "100" and Position_input = "001" then     --D2 outside button pressed
                            Next_state <= "101";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        elsif  Next_cmd = "101" and Position_input = "001" then     --B0 inside button pressed
                            Next_state <= "000";
                            Motor_up  <= '0';
                            Motor_down <= '0'; 
                        elsif  Next_cmd = "110" and Position_input = "001" then     --B1 inside button pressed
                            Next_state <= "011";
                            Motor_up  <= '1';
                            Motor_down <= '0'; 
                        elsif  Next_cmd = "111" and Position_input = "001" then     --B2 inside button pressed
                            Next_state <= "101";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        end if;
--                        Button_reset <= "0010001";
    
                    when "001" =>       --lift is stationary on 1 floor
                        if  Next_cmd = "001" and Position_input = "010" then        --U0 outside button pressed
                            Next_state <= "110";
                            Motor_up  <= '0';
                            Motor_down <= '1';
                        elsif  Next_cmd = "010" and Position_input = "010" then     --U1 outside button pressed
                            Next_state <= "001";
                            Motor_up  <= '0';
                            Motor_down <= '0';                  
                        elsif  Next_cmd = "011" and Position_input = "010" then     --D1 outside button pressed
                            Next_state <= "001";
                            Motor_up  <= '0';
                            Motor_down <= '0';                 
                        elsif  Next_cmd = "100" and Position_input = "010" then     --D2 outside button pressed
                            Next_state <= "101";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        elsif  Next_cmd = "101" and Position_input = "010" then     --B0 inside button pressed 
                            Next_state <= "110";
                            Motor_up  <= '0';
                            Motor_down <= '1';
                        elsif  Next_cmd = "110" and Position_input = "010" then     --B1 inside button pressed 
                            Next_state <= "001";
                            Motor_up  <= '0';
                            Motor_down <= '0';
                        elsif  Next_cmd = "111" and Position_input = "010" then     --B2 inside button pressed 
                            Next_state <= "101";
                            Motor_up  <= '1';
                            Motor_down <= '0';
                        end if;
--                        Button_reset <= "0100110";
                        
                    when "010" =>       --lift is stationary on 2 floor
                        if  Next_cmd = "001" and Position_input = "100" then        --U0 outside button pressed
                            Next_state <= "110";
                            Motor_up  <= '0';
                            Motor_down <= '1';
                        elsif  Next_cmd = "010" and Position_input = "100" then     --U1 outside button pressed
                            Next_state <= "100";
                            Motor_up  <= '0';
                            Motor_down <= '1';                    
                        elsif  Next_cmd = "011" and Position_input = "100" then     --D1 outside button pressed
                            Next_state <= "100";
                            Motor_up  <= '0';
                            Motor_down <= '1';                  
                        elsif  Next_cmd = "100" and Position_input = "100" then     --D2 outside button pressed
                            Next_state <= "010";
                            Motor_up  <= '0';
                            Motor_down <= '0';
                        elsif  Next_cmd = "101" and Position_input = "100" then     --B0 inside button pressed 
                            Next_state <= "110";
                            Motor_up  <= '0';
                            Motor_down <= '1';
                        elsif  Next_cmd = "110" and Position_input = "100" then     --B1 inside button pressed 
                            Next_state <= "100";
                            Motor_up  <= '0';
                            Motor_down <= '1';
                        elsif  Next_cmd = "111" and Position_input = "100" then     --B2 inside button pressed 
                            Next_state <= "010";
                            Motor_up  <= '0';
                            Motor_down <= '0';
                        end if;
--                        Button_reset <= "1001000";
                        
                    when "011" =>       --lift is moving to 1 floor from down
                        if Position_input = "010" then
                            Next_state <= "001";
                            Motor_up  <= '0';
                            Motor_down <= '0';
--                           Button_reset <= "0100110";
                        end if;
                        
                    when "100" =>       --lift is moving to 1 floor from up
                        if Position_input = "010" then
                            Next_state <= "001";
                            Motor_up  <= '0';
                            Motor_down <= '0';
--                            Button_reset <= "0100110";
                        end if;
                        
                    when "101" =>       --lift is moving to 2 floor from down
                        if Position_input = "100" then
                            Next_state <= "010";
                            Motor_up  <= '0';
                            Motor_down <= '0';
--                            Button_reset <= "1001000";
                        end if;
                        
                    when "110" =>       --lift is moving to 0 floor from up
                        if Position_input = "001" then
                            Next_state <= "000";
                            Motor_up  <= '0';
                            Motor_down <= '0';
--                            Button_reset <= "0010001";
                        end if;
                    
                    when others =>
                        null;
    
                end case;
            else
                if Clr = '1' then
                    Button_reset <= "0000000";
                end if;
                if Stop_motor = '1' then 
                    Motor_up  <= '0';
                    Motor_down <= '0';
                    if Position_input = "001" then
                        Button_reset <= "0010001";
                    elsif Position_input = "010" then
                        Button_reset <= "0100110";
                    elsif Position_input = "100" then
                        Button_reset <= "1001000";
                    else
                        null;
                    end if;
                        
                end if;
            end if;
        end if;
    end process;         

end Behavioral; 
