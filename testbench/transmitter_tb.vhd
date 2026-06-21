library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmitter_tb is
end transmitter_tb;

architecture Behavioral of transmitter_tb is
    -- Component Declaration
    component transmitter
        Port ( 
            clk_50MHz : in STD_LOGIC;
            reset : in STD_LOGIC;
            start : in STD_LOGIC;
            done : out STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;
    
    -- Signal Declarations
    signal clk_50MHz : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal done : STD_LOGIC;
    signal output : STD_LOGIC;
    
    -- Constants
    constant CLK_PERIOD : time := 20 ns;  -- 50 MHz clock period
    
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: transmitter port map (
        clk_50MHz => clk_50MHz,
        reset => reset,
        start => start,
        done => done,
        output => output
    );

    -- Clock process
    clk_process: process
    begin
        clk_50MHz <= '0';
        wait for CLK_PERIOD/2;
        clk_50MHz <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize
        reset <= '1';
        start <= '0';
        wait for 100 ns;
        
        -- Release reset
        reset <= '0';
        wait for 100 ns;
        
        -- Start transmission
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        
        -- Wait for transmission to complete
        wait until done = '1';
        wait for 1 ms;
        
       
    end process;

end Behavioral;
