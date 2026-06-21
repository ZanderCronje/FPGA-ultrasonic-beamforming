library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity att_comp_tb is
end att_comp_tb;

architecture Behavioral of att_comp_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component att_comp
        Port ( 
            clk : in STD_LOGIC;
            start : in STD_LOGIC;
            done : out STD_LOGIC;
            counter : in STD_LOGIC_VECTOR(12 downto 0);
            input : in STD_LOGIC_VECTOR(7 downto 0);
            output : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Inputs
    signal clk : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal counter : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
    signal input : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    -- Outputs
    signal done : STD_LOGIC;
    signal output : STD_LOGIC_VECTOR(7 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

    -- File handling
    file input_file : text;

    -- Function to convert std_logic_vector to hex string
    function to_hex_string(slv : std_logic_vector) return string is
        variable hex : string(1 to slv'length/4) := (others => '0');
        variable nibble : std_logic_vector(3 downto 0);
    begin
        for i in hex'range loop
            nibble := slv((4*i)-1 downto 4*(i-1));
            case nibble is
                when "0000" => hex(i) := '0';
                when "0001" => hex(i) := '1';
                when "0010" => hex(i) := '2';
                when "0011" => hex(i) := '3';
                when "0100" => hex(i) := '4';
                when "0101" => hex(i) := '5';
                when "0110" => hex(i) := '6';
                when "0111" => hex(i) := '7';
                when "1000" => hex(i) := '8';
                when "1001" => hex(i) := '9';
                when "1010" => hex(i) := 'A';
                when "1011" => hex(i) := 'B';
                when "1100" => hex(i) := 'C';
                when "1101" => hex(i) := 'D';
                when "1110" => hex(i) := 'E';
                when "1111" => hex(i) := 'F';
                when others => hex(i) := 'X';
            end case;
        end loop;
        return hex;
    end function;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: att_comp port map (
        clk => clk,
        start => start,
        done => done,
        counter => counter,
        input => input,
        output => output
    );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        variable line_in : line;
        variable input_value : std_logic_vector(7 downto 0);
    begin
        -- Open the input file
        file_open(input_file, "output.txt", read_mode);

        -- Wait for global reset
        wait for 100 ns;

        -- Process all 4500 inputs
        for i in 1 to 4500 loop
            -- Read a line from the file
            readline(input_file, line_in);
            read(line_in, input_value);

            -- Set the input and counter
            input <= input_value;
            counter <= std_logic_vector(to_unsigned(i, 13));

            -- Start the operation
            start <= '1';
            wait for clk_period;
            start <= '0';

            -- Wait for done signal
            wait until done = '1';
            
            -- Optional: Add a small delay to observe the output
            wait for clk_period;

            -- Optional: Print the result
            report "Counter: " & integer'image(i) & 
                   ", Input: " & to_hex_string(input_value) & 
                   ", Output: " & to_hex_string(output);
        end loop;

        -- Close the file
        file_close(input_file);

        -- End the simulation
        wait for 100 ns;
        report "Simulation finished" severity note;
        wait;
    end process;

end Behavioral;