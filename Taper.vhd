library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Taper is
    Generic (
        MUL_VAL : STD_LOGIC_VECTOR(7 downto 0) := "11111111" 
    );
    Port ( 
        aclk    : in  STD_LOGIC;                     
        start   : in  STD_LOGIC;                     
        done    : out STD_LOGIC;                     
        input   : in  STD_LOGIC_VECTOR(7 downto 0); 
        output  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Taper;

architecture Behavioral of Taper is
    type state_type is (IDLE, MULTIPLY, COMPLETE);
    signal state : state_type := IDLE;
    signal result_temp : unsigned(15 downto 0);
    
begin
    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when IDLE =>
                    done <= '0';
                    if start = '1' then
                        state <= MULTIPLY;
                    end if;
                    
                when MULTIPLY =>
                    result_temp <= unsigned(input) * unsigned(MUL_VAL);
                    state <= COMPLETE;
                    
                when COMPLETE =>
                    output <= std_logic_vector(result_temp(15 downto 8));
                    done <= '1';
                    state <= IDLE;
                    
            end case;
        end if;
    end process;
    
end Behavioral;