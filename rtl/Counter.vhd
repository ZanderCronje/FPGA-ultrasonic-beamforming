library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    Port ( 
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        start : in  STD_LOGIC;
        done  : out STD_LOGIC
    );
end Counter;

architecture Behavioral of Counter is
    signal count : unsigned(6 downto 0) := (others => '0');
    signal counting : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
            counting <= '0';
            done <= '0';
        elsif falling_edge(clk) then
            if counting = '0' then
                if start = '1' then
                    counting <= '1';
                    count <= (others => '0');
                    done <= '0';
                end if;
            else
                if count = 10 then
                    counting <= '0';
                    done <= '1';
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
