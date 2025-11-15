library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity JK_FF is
	Port(
		J        : in STD_LOGIC; 
		K        : in STD_LOGIC; 
		clk      : in STD_LOGIC; 
		Q        : out STD_LOGIC 
	);
end JK_FF;

architecture Behavioral of JK_FF is

begin
    process(clk, J, K)
        variable qn : std_logic := '0' ;
    begin
        if rising_edge(clk) then
            if(J='0' and K='0')then
                qn := qn;
            elsif(J='0' and K='1')then
                qn := '0';
            elsif(J='1' and K='0')then
                qn := '1';
            elsif(J='1' and K='1')then
                qn := not qn;
            else
                null;
            end if;
        else
            null;
        end if;
        Q <= qn;
end process;

end Behavioral;
