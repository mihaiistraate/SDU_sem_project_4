library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_FIFO is
    Generic (
        FIFO_SIZE  : NATURAL := 32;  -- Number of entries in the FIFO, max 32; above 32 use memory based FIFO
        FIFO_WIDTH : NATURAL := 3   -- Data length in FIFO
    );
    Port (
        Clk         : in STD_LOGIC;        -- Clock signal
        Reset       : in STD_LOGIC;        -- Reset signal
        Data_in     : in STD_LOGIC_VECTOR((FIFO_WIDTH-1) downto 0); -- Data input
        Write_en    : in STD_LOGIC;        -- Write enable
        Read_en     : in STD_LOGIC;        -- Read enable
        Data_out    : out STD_LOGIC_VECTOR((FIFO_WIDTH-1) downto 0) := (others => '0'); -- Data output
        Full        : out STD_LOGIC := '0';      -- Full flag
        Empty       : out STD_LOGIC := '0'      -- Empty flag
    );
end Register_FIFO;

architecture Behavioral of Register_FIFO is
    type FIFO_array is array (0 to (FIFO_SIZE-1)) of STD_LOGIC_VECTOR((FIFO_WIDTH-1) downto 0);
    signal fifo_storage   : FIFO_array;
    signal read_pointer   : NATURAL := 0;
    signal write_pointer  : NATURAL := 0;
    signal count          : INTEGER := 0;
begin
    process(Clk, Reset, Write_en, Read_en, Data_in)
    begin
        if Reset = '1' then
            read_pointer <= 0;
            write_pointer <= 0;
            count <= 0;
        elsif rising_edge(Clk) then
            if Write_en = '1' and count < FIFO_SIZE then
                fifo_storage(write_pointer) <= Data_in;
                write_pointer <= (write_pointer + 1) mod FIFO_SIZE;
                count <= count + 1;
            end if;

            if Read_en = '1' and count > 0 then
                Data_out <= fifo_storage(read_pointer);
                read_pointer <= (read_pointer + 1) mod FIFO_SIZE;
                count <= count - 1;
            end if;
        end if;
    end process;

    Full <= '1' when count = FIFO_SIZE else '0';
    Empty <= '1' when count = 0 else '0';
end Behavioral;
