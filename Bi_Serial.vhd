library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bi_Serial is
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;

        tx_data : in STD_LOGIC_VECTOR(7 downto 0);
        tx_start : in STD_LOGIC;
        tx_busy : out STD_LOGIC;
        tx_done : out STD_LOGIC;
        tx_line : out STD_LOGIC;
        tx_flag : in STD_LOGIC;

        rx_data : out STD_LOGIC_VECTOR(7 downto 0);
        rx_done : out STD_LOGIC;
        rx_line : in STD_LOGIC;
        rx_flag : in STD_LOGIC
    );
end Bi_Serial;

architecture Behavioral of Bi_Serial is
    constant CLKS_PER_BIT : integer := 54; 

    type tx_state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal tx_state : tx_state_type := IDLE;
    signal tx_clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal tx_bit_index : integer range 0 to 7 := 0;
    signal tx_data_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    type rx_state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal rx_state : rx_state_type := IDLE;
    signal rx_clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal rx_bit_index : integer range 0 to 7 := 0;
    signal rx_data_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

    TX_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tx_state <= IDLE;
                tx_line <= '1';
                tx_busy <= '0';
                tx_done <= '0';
            elsif tx_flag = '1' then
                case tx_state is
                    when IDLE =>
                        tx_line <= '1';
                        tx_busy <= '0';
                        tx_done <= '0';
                        tx_clk_count <= 0;
                        tx_bit_index <= 0;
                        
                        if tx_start = '1' then
                            tx_data_reg <= tx_data;
                            tx_state <= START_BIT;
                            tx_busy <= '1';
                        end if;
                        
                    when START_BIT =>
                        tx_line <= '0';
                        
                        if tx_clk_count < CLKS_PER_BIT-1 then
                            tx_clk_count <= tx_clk_count + 1;
                        else
                            tx_clk_count <= 0;
                            tx_state <= DATA_BITS;
                        end if;
                        
                    when DATA_BITS =>
                        tx_line <= tx_data_reg(tx_bit_index);
                        
                        if tx_clk_count < CLKS_PER_BIT-1 then
                            tx_clk_count <= tx_clk_count + 1;
                        else
                            tx_clk_count <= 0;
                            
                            if tx_bit_index < 7 then
                                tx_bit_index <= tx_bit_index + 1;
                            else
                                tx_bit_index <= 0;
                                tx_state <= STOP_BIT;
                            end if;
                        end if;
                        
                    when STOP_BIT =>
                        tx_line <= '1';
                        
                        if tx_clk_count < CLKS_PER_BIT-1 then
                            tx_clk_count <= tx_clk_count + 1;
                        else
                            tx_clk_count <= 0;
                            tx_state <= IDLE;
                            tx_done <= '1'; 
                        end if;
                end case;
            else
                tx_state <= IDLE;
                tx_line <= '1';
                tx_busy <= '0';
                tx_done <= '0';  
            end if;
        end if;
    end process;


    RX_PROCESS : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rx_state <= IDLE;
                rx_done <= '0';
                rx_data <= (others => '0');
            elsif rx_flag = '1' then
                case rx_state is
                    when IDLE =>
                        rx_done <= '0';
                        rx_clk_count <= 0;
                        rx_bit_index <= 0;
                        
                        if rx_line = '0' then 
                            rx_state <= START_BIT;
                        end if;
                        
                    when START_BIT =>
                        if rx_clk_count = (CLKS_PER_BIT-1)/2 then
                            if rx_line = '0' then
                                rx_clk_count <= 0;
                                rx_state <= DATA_BITS;
                            else
                                rx_state <= IDLE;
                            end if;
                        else
                            rx_clk_count <= rx_clk_count + 1;
                        end if;
                        
                    when DATA_BITS =>
                        if rx_clk_count < CLKS_PER_BIT-1 then
                            rx_clk_count <= rx_clk_count + 1;
                        else
                            rx_clk_count <= 0;
                            rx_data_reg(rx_bit_index) <= rx_line;
                            
                            if rx_bit_index < 7 then
                                rx_bit_index <= rx_bit_index + 1;
                            else
                                rx_bit_index <= 0;
                                rx_state <= STOP_BIT;
                            end if;
                        end if;
                        
                    when STOP_BIT =>
                        if rx_clk_count < CLKS_PER_BIT-1 then
                            rx_clk_count <= rx_clk_count + 1;
                        else
                            rx_data <= rx_data_reg;
                            rx_done <= '1';
                            rx_state <= IDLE;
                        end if;
                end case;
            else
                rx_state <= IDLE;
                rx_done <= '0';
            end if;
        end if;
    end process;

end Behavioral;