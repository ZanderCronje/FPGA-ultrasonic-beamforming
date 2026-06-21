library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DelayAndSumFilter_tb is
end DelayAndSumFilter_tb;

architecture Behavioral of DelayAndSumFilter_tb is
    -- Component Declaration
    component DelayAndSumFilter is
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
    end component;

    -- Clock period definition
    constant clk_period : time := 10 ns;

    -- Signals for the UUT
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal start       : std_logic := '0';
    signal addr_counter: std_logic_vector(13 downto 0) := (others => '0');
    
    -- Delay signals
    signal DELAY1      : signed(7 downto 0) := (others => '0');
    signal DELAY2      : signed(7 downto 0) := (others => '0');
    signal DELAY3      : signed(7 downto 0) := (others => '0');
    signal DELAY4      : signed(7 downto 0) := (others => '0');
    signal DELAY5      : signed(7 downto 0) := (others => '0');
    signal DELAY6      : signed(7 downto 0) := (others => '0');
    signal DELAY7      : signed(7 downto 0) := (others => '0');
    signal DELAY8      : signed(7 downto 0) := (others => '0');
    
    -- Data signals
    signal MIC_DATA_0  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_1  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_2  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_3  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_4  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_5  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_6  : std_logic_vector(7 downto 0) := (others => '0');
    signal MIC_DATA_7  : std_logic_vector(7 downto 0) := (others => '0');
    
    -- Address signals
    signal MIC_ADDR_0  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_1  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_2  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_3  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_4  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_5  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_6  : std_logic_vector(13 downto 0);
    signal MIC_ADDR_7  : std_logic_vector(13 downto 0);
    
    -- Output signals
    signal OUTPUT      : std_logic_vector(7 downto 0);
    signal sum_done    : std_logic;
    
    -- Memory type and signal
    type memory_type is array (0 to 9200) of std_logic_vector(7 downto 0);
    signal memory : memory_type := (others => (others => '0'));

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: DelayAndSumFilter 
    port map (
        clk          => clk,
        reset        => reset,
        start        => start,
        addr_counter => addr_counter,
        DELAY1       => DELAY1,
        DELAY2       => DELAY2,
        DELAY3       => DELAY3,
        DELAY4       => DELAY4,
        DELAY5       => DELAY5,
        DELAY6       => DELAY6,
        DELAY7       => DELAY7,
        DELAY8       => DELAY8,
        MIC_DATA_0   => MIC_DATA_0,
        MIC_DATA_1   => MIC_DATA_1,
        MIC_DATA_2   => MIC_DATA_2,
        MIC_DATA_3   => MIC_DATA_3,
        MIC_DATA_4   => MIC_DATA_4,
        MIC_DATA_5   => MIC_DATA_5,
        MIC_DATA_6   => MIC_DATA_6,
        MIC_DATA_7   => MIC_DATA_7,
        MIC_ADDR_0   => MIC_ADDR_0,
        MIC_ADDR_1   => MIC_ADDR_1,
        MIC_ADDR_2   => MIC_ADDR_2,
        MIC_ADDR_3   => MIC_ADDR_3,
        MIC_ADDR_4   => MIC_ADDR_4,
        MIC_ADDR_5   => MIC_ADDR_5,
        MIC_ADDR_6   => MIC_ADDR_6,
        MIC_ADDR_7   => MIC_ADDR_7,
        OUTPUT       => OUTPUT,
        sum_done     => sum_done
    );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Memory initialization process
    memory_init: process
    begin
        -- Memory is already initialized to zeros
        
        -- Set 100-9000 to all ones
        for i in 100 to 9000 loop
            memory(i) <= (others => '1');
        end loop;
        
        wait;
    end process;

    -- Memory read process
    memory_read: process(MIC_ADDR_0, MIC_ADDR_1, MIC_ADDR_2, MIC_ADDR_3,
                        MIC_ADDR_4, MIC_ADDR_5, MIC_ADDR_6, MIC_ADDR_7)
    begin
        if (to_integer(unsigned(MIC_ADDR_0)) <= 9200) then
            MIC_DATA_0 <= memory(to_integer(unsigned(MIC_ADDR_0)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_1)) <= 9200) then
            MIC_DATA_1 <= memory(to_integer(unsigned(MIC_ADDR_1)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_2)) <= 9200) then
            MIC_DATA_2 <= memory(to_integer(unsigned(MIC_ADDR_2)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_3)) <= 9200) then
            MIC_DATA_3 <= memory(to_integer(unsigned(MIC_ADDR_3)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_4)) <= 9200) then
            MIC_DATA_4 <= memory(to_integer(unsigned(MIC_ADDR_4)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_5)) <= 9200) then
            MIC_DATA_5 <= memory(to_integer(unsigned(MIC_ADDR_5)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_6)) <= 9200) then
            MIC_DATA_6 <= memory(to_integer(unsigned(MIC_ADDR_6)));
        end if;
        if (to_integer(unsigned(MIC_ADDR_7)) <= 9200) then
            MIC_DATA_7 <= memory(to_integer(unsigned(MIC_ADDR_7)));
        end if;
    end process;

    stim_proc: process
    begin
        -- Set delays
        DELAY1 <= to_signed(-12, 8);
        DELAY2 <= to_signed(-8, 8);
        DELAY3 <= to_signed(-5, 8);
        DELAY4 <= to_signed(-2, 8);
        DELAY5 <= to_signed(2, 8);
        DELAY6 <= to_signed(5, 8);
        DELAY7 <= to_signed(8, 8);
        DELAY8 <= to_signed(12, 8);
        
        -- Wait for memory initialization
        wait for 2 ns;
        
        -- Reset pulse
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait for clk_period*2;
        
        -- Counter loop from 100 to 9100
        for i in 100 to 9100 loop
            addr_counter <= std_logic_vector(to_unsigned(i, 14));
            -- Pulse start for one clock cycle
            wait until rising_edge(clk);
            start <= '1';
            wait until rising_edge(clk);
            start <= '0';
            -- Wait for sum_done before next iteration
            wait until sum_done = '1';
            wait for clk_period;
        end loop;
        
        -- Add some delay at the end
        wait for clk_period*10;
        
        -- End simulation
        assert false report "Simulation Completed" severity failure;
        wait;
    end process;

end Behavioral;