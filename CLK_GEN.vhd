library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLK_GEN is
    Port ( 
        CLK_IN  : in  STD_LOGIC;  
        CLK_OUT : out STD_LOGIC  
    );
end CLK_GEN;

architecture Behavioral of CLK_GEN is

    constant COUNT_MAX : integer := 4; 
    constant HIGH_TIME : integer := 2; 
    
    signal count : integer range 0 to COUNT_MAX;
    
begin
    process(CLK_IN)
    begin
        if rising_edge(CLK_IN) then
            if count = COUNT_MAX then
                count <= 0;
            else
                count <= count + 1;
            end if;
            if count <= HIGH_TIME then
                CLK_OUT <= '1';
            else
                CLK_OUT <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;