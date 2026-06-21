library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC_reader is
    Port ( 
        clk_10MHz       : in STD_LOGIC;
        start           : in STD_LOGIC;
        sdata           : in STD_LOGIC;
        cs              : out STD_LOGIC;
        data_out        : out STD_LOGIC_VECTOR(7 downto 0);
        done            : out STD_LOGIC
    );
end ADC_reader;

architecture Behavioral of ADC_reader is
    type state_type is (IDLE, SAMPLING, FINISHING);
    signal state, next_state : state_type;
    
    signal counter      : unsigned(7 downto 0);
    signal shift_reg    : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal start_prev   : std_logic := '0';
    
begin
process(clk_10MHz)
    begin
        if falling_edge(clk_10MHz) then
            state <= next_state;
            start_prev <= start;
            
            case state is
                when IDLE =>
                    counter <= (others => '0');
                    if start = '1' and start_prev = '0' then
                        next_state <= SAMPLING;
                    end if;
                
                when SAMPLING =>
                    counter <= counter + 1;
                    if counter >= 3 and counter < 12 then
                        shift_reg <= shift_reg(6 downto 0) & sdata;
                    end if;
                    if counter = 14 then 
                        next_state <= FINISHING;
                    end if;
                
                when FINISHING =>
                    data_out <= shift_reg;
                    next_state <= IDLE;
                    counter <= (others => '0');

            end case;
        end if;
    end process;

    process(state)
    begin
        cs <= '1';
        done <= '0';
        
        case state is
            when IDLE =>

            when SAMPLING =>
                cs <= '0';
            when FINISHING =>
                cs <= '0';
                done <= '1';

        end case;
    end process;


end Behavioral;