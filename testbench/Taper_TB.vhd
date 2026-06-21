library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity Taper_TB is
end Taper_TB;

architecture Behavioral of Taper_TB is
    -- Component Declaration
    component Taper
        Port ( 
            aclk    : in  STD_LOGIC;
            start   : in  STD_LOGIC;
            done    : out STD_LOGIC;
            input   : in  STD_LOGIC_VECTOR(7 downto 0);
            output  : out STD_LOGIC_VECTOR(7 downto 0);
            mul_val : in  STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
    -- Signals
    signal aclk    : STD_LOGIC := '0';
    signal start   : STD_LOGIC := '0';
    signal done    : STD_LOGIC;
    signal input   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal output  : STD_LOGIC_VECTOR(7 downto 0);
    signal mul_val : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
    -- Test control
    signal sim_done : boolean := false;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: Taper port map (
        aclk    => aclk,
        start   => start,
        done    => done,
        input   => input,
        output  => output,
        mul_val => mul_val
    );

    -- Clock process
    clk_process: process
    begin
        while not sim_done loop
            aclk <= '0';
            wait for CLK_PERIOD/2;
            aclk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
        -- Function to convert float to fixed-point representation
        function float_to_fixed(f : real) return std_logic_vector is
            variable result : integer;
        begin
            result := integer(f * 255.0);
            return std_logic_vector(to_unsigned(result, 8));
        end function;
        
        -- Procedure to test one input value
        procedure test_value(
            constant test_input : in integer;
            constant mult_val  : in real;
            constant test_num  : in integer) is
        begin
            -- Set input value
            input <= std_logic_vector(to_unsigned(test_input, 8));
            
            -- Start the multiplication
            wait for CLK_PERIOD;
            start <= '1';
            wait for CLK_PERIOD;
            start <= '0';
            
            -- Wait for done signal
            wait until done = '1';
            
            -- Print results
            report "Test " & integer'image(test_num) & 
                  " - Input: " & integer'image(test_input) & 
                  " Mult: " & real'image(mult_val) & 
                  " Output: " & integer'image(to_integer(unsigned(output)));
                  
            -- Add some delay between tests
            wait for CLK_PERIOD * 2;
        end procedure;
        
    begin
        -- Initialize
        wait for CLK_PERIOD * 2;
        
        -- Test with multiplication value 0.58
        mul_val <= float_to_fixed(0.58);
        report "Starting tests with multiplication value 0.58";
        for i in 0 to 255 loop
            test_value(i, 0.58, i);
        end loop;
        wait for CLK_PERIOD * 10;
        
        -- Test with multiplication value 0.66
        mul_val <= float_to_fixed(0.66);
        report "Starting tests with multiplication value 0.66";
        for i in 0 to 255 loop
            test_value(i, 0.66, i + 256);
        end loop;
        wait for CLK_PERIOD * 10;
        
        -- Test with multiplication value 0.88
        mul_val <= float_to_fixed(0.88);
        report "Starting tests with multiplication value 0.88";
        for i in 0 to 255 loop
            test_value(i, 0.88, i + 512);
        end loop;
        
        -- End simulation
        wait for CLK_PERIOD * 10;
        report "Simulation completed successfully";
        sim_done <= true;
        wait;
    end process;

end Behavioral;
