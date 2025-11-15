library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity CMD_reader is
    Port   (
            ENA                 : in STD_LOGIC;
            CLK                 : in STD_LOGIC;
            Validity_in         : in STD_LOGIC;
            Store_empty         : in STD_LOGIC;
            Store_R_ENA         : out STD_LOGIC := '0';
            Ready               : out STD_LOGIC := '0'
            );
end CMD_reader;

architecture Behavioral of CMD_reader is
    signal ready_sig : STD_LOGIC := '0';
        
begin
    process(CLK,ENA,Validity_in) is
    begin
        if rising_edge(CLK) then
            if ready_sig = '0' then
                if Store_empty /= '1' then
                    if Validity_in = '0' then
                        Store_R_ENA <= '1'; -- goes as input to the command store and it means it is ready to read another value
                    else
                        Store_R_ENA <= '0';
                        if ENA = '1' then
                            ready_sig <= '1';
                        end if;
                    end if;
                else
                    Store_R_ENA <= '0';
                    if Validity_in = '1' then
                        if ENA = '1' then
                            ready_sig <= '1';
                        end if;
                    end if;        
                end if;
            else
                ready_sig <= '0';
            end if;       
        end if;
    end process;
    
    Ready <= ready_sig;
    
end Behavioral; 
   
