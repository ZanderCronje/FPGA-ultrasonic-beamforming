library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ClockDivider_tb is
end ClockDivider_tb;

architecture Behavioral of ClockDivider_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component ClockDivider
    Port (
        clk_in  : in  STD_LOGIC;
        clk_out : out STD_LOGIC
    );
    end component;

    -- Testbench Signals
    signal clk_in_tb  : STD_LOGIC := '0';
    signal clk_out_tb : STD_LOGIC;

    constant clk_period : time := 20 ns; -- 50 MHz clock period

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ClockDivider Port map (
        clk_in  => clk_in_tb,
        clk_out => clk_out_tb
    );

    -- Clock Process
    clk_process :process
    begin
        clk_in_tb <= '0';
        wait for clk_period / 2;
        clk_in_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus Process
    stimulus: process
    begin
        -- Run simulation for 1 us
        wait for 1 us;
        -- End simulation
        wait;
    end process;

end Behavioral;
