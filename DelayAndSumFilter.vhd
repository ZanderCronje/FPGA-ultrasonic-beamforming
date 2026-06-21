library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DelayAndSumFilter is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        start       : in  STD_LOGIC;
        addr_counter: in  STD_LOGIC_VECTOR(13 downto 0);
        
        DELAY1      : in  SIGNED(7 downto 0);
        DELAY2      : in  SIGNED(7 downto 0);
        DELAY3      : in  SIGNED(7 downto 0);
        DELAY4      : in  SIGNED(7 downto 0);
        DELAY5      : in  SIGNED(7 downto 0);
        DELAY6      : in  SIGNED(7 downto 0);
        DELAY7      : in  SIGNED(7 downto 0);
        DELAY8      : in  SIGNED(7 downto 0);
        
        MIC_DATA_0  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_1  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_2  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_3  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_4  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_5  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_6  : in  STD_LOGIC_VECTOR(7 downto 0);
        MIC_DATA_7  : in  STD_LOGIC_VECTOR(7 downto 0);
        
        MIC_ADDR_0  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_1  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_2  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_3  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_4  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_5  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_6  : out STD_LOGIC_VECTOR(13 downto 0);
        MIC_ADDR_7  : out STD_LOGIC_VECTOR(13 downto 0);
        
        OUTPUT      : out STD_LOGIC_VECTOR(7 downto 0);
        sum_done    : out STD_LOGIC
    );
end DelayAndSumFilter;

architecture Behavioral of DelayAndSumFilter is

    type state_type is (
        IDLE,
        APPLY_DELAY,
        SUM_DATA,
        NORMALIZE,
        OUTPUT_DATA
    );
    signal current_state, next_state : state_type;
    signal Result : UNSIGNED(10 downto 0);
    signal temp_sum : UNSIGNED(10 downto 0);

begin

    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= IDLE;
                Result <= (others => '0');
            else
                current_state <= next_state;
                if current_state = SUM_DATA then
                    Result <= temp_sum;
                elsif current_state = NORMALIZE then
                    Result <= "000" & Result(10 downto 3); 
                end if;
            end if;
        end if;
    end process;


    process(current_state, start, addr_counter, MIC_DATA_0, MIC_DATA_1, MIC_DATA_2, MIC_DATA_3,
            MIC_DATA_4, MIC_DATA_5, MIC_DATA_6, MIC_DATA_7, DELAY1, DELAY2, DELAY3, 
            DELAY4, DELAY5, DELAY6, DELAY7, DELAY8, Result)
    begin
        sum_done <= '0';
        temp_sum <= (others => '0');
        
        case current_state is
            when IDLE =>
                if start = '1' then
                    next_state <= APPLY_DELAY;
                else
                    next_state <= IDLE;
                end if;
                
            when APPLY_DELAY =>

                MIC_ADDR_0 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY1, 14));
                MIC_ADDR_1 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY2, 14));
                MIC_ADDR_2 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY3, 14));
                MIC_ADDR_3 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY4, 14));
                MIC_ADDR_4 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY5, 14));
                MIC_ADDR_5 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY6, 14));
                MIC_ADDR_6 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY7, 14));
                MIC_ADDR_7 <= STD_LOGIC_VECTOR(resize(signed(addr_counter) - DELAY8, 14));
                next_state <= SUM_DATA;
                
            when SUM_DATA =>

                temp_sum <= unsigned("000" & MIC_DATA_0) + 
                           unsigned("000" & MIC_DATA_1) +
                           unsigned("000" & MIC_DATA_2) + 
                           unsigned("000" & MIC_DATA_3) +
                           unsigned("000" & MIC_DATA_4) + 
                           unsigned("000" & MIC_DATA_5) +
                           unsigned("000" & MIC_DATA_6) + 
                           unsigned("000" & MIC_DATA_7);
                next_state <= NORMALIZE;
                
            when NORMALIZE =>
                next_state <= OUTPUT_DATA;
                
            when OUTPUT_DATA =>
                OUTPUT <= std_logic_vector(Result(7 downto 0));
                sum_done <= '1';
                next_state <= IDLE;
                
        end case;
    end process;

end Behavioral;