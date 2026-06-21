library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BRAM_4500x8 is
    Port (
        clk       : in  std_logic;
        we        : in  std_logic;
        w_addr    : in  std_logic_vector(12 downto 0);
        r_addr    : in  std_logic_vector(12 downto 0);
        data_in   : in  std_logic_vector(7 downto 0);
        data_out  : out std_logic_vector(7 downto 0)
    );
end BRAM_4500x8;

architecture Behavioral of BRAM_4500x8 is

    subtype WORD is std_logic_vector(7 downto 0);
    type memory_array is array (0 to 4499) of WORD;

    signal RAM : memory_array := (others => (others => '0'));
    
begin
    process(clk)

        variable w_addr_int : natural range 0 to 4499;
        variable r_addr_int : natural range 0 to 4499;
    begin
        if rising_edge(clk) then

            w_addr_int := to_integer(unsigned(w_addr));
            r_addr_int := to_integer(unsigned(r_addr));
            

            if we = '1' then
                RAM(w_addr_int) <= data_in;
            end if;

            data_out <= RAM(r_addr_int);
        end if;
    end process;
end Behavioral;
