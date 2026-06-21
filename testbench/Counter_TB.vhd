library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Counter_TB is
-- Testbench doesn't have ports
end Counter_TB;

architecture Behavioral of Counter_TB is
    -- Component declaration for the Unit Under Test (UUT)
    component Counter is
        generic (
            MAX_COUNT : positive := 36000
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            enable      : in  std_logic;
            increment   : in  std_logic;
            count       : out unsigned(15 downto 0);
            max_reached : out std_logic
        );
    end component Counter;

    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    constant MAX_COUNT_TEST : positive := 100; -- Smaller value for faster simulation

    -- Signals for connecting to the UUT
    signal clk_tb         : std_logic := '0';
    signal reset_tb       : std_logic := '0';
    signal enable_tb      : std_logic := '0';
    signal increment_tb   : std_logic := '0';
    signal count_tb       : unsigned(15 downto 0);
    signal max_reached_tb : std_logic;

    -- Procedure for checking results
    procedure check_count(expected: in integer) is
    begin
        assert to_integer(count_tb) = expected
            report "Count mismatch. Expected " & integer'image(expected) & 
                   " but got " & integer'image(to_integer(count_tb))
            severity error;
    end procedure;

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: Counter
        generic map (
            MAX_COUNT => MAX_COUNT_TEST
        )
        port map (
            clk         => clk_tb,
            reset       => reset_tb,
            enable      => enable_tb,
            increment   => increment_tb,
            count       => count_tb,
            max_reached => max_reached_tb
        );

    -- Clock process
    clk_process: process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Initialize
        reset_tb <= '1';
        enable_tb <= '0';
        increment_tb <= '0';
        wait for CLK_PERIOD*2;
        
        -- Release reset
        reset_tb <= '0';
        wait for CLK_PERIOD;
        
        -- Test 1: Basic counting
        enable_tb <= '1';
        increment_tb <= '1';
        for i in 1 to 10 loop
            wait for CLK_PERIOD;
            check_count(i);
        end loop;
        
        -- Test 2: Disable counting
        enable_tb <= '0';
        wait for CLK_PERIOD*5;
        check_count(10); -- Should not have incremented
        
        -- Test 3: Re-enable counting
        enable_tb <= '1';
        wait for CLK_PERIOD*5;
        check_count(15);
        
        -- Test 4: Reset while counting
        wait for CLK_PERIOD*5;
        reset_tb <= '1';
        wait for CLK_PERIOD;
        reset_tb <= '0';
        check_count(0);
        
        -- Test 5: Count to max
        for i in 1 to MAX_COUNT_TEST loop
            wait for CLK_PERIOD;
        end loop;
        assert max_reached_tb = '1'
            report "Max reached flag not set at maximum count"
            severity error;
        
        -- Test 6: Try to count beyond max
        wait for CLK_PERIOD*10;
        check_count(MAX_COUNT_TEST - 1); -- Should stay at max count
        
        -- End simulation
        report "Simulation finished successfully";
        wait;
    end process;

end Behavioral;
