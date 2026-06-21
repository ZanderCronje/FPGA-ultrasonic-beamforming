library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity ADC_Reader_tb is
end ADC_Reader_tb;

architecture Behavioral of ADC_Reader_tb is
    component ADC_Reader
        Port ( 
            clk_10MHz   : in STD_LOGIC;
            start       : in STD_LOGIC;
            sdata       : in STD_LOGIC;
            cs          : out STD_LOGIC;
            data_out    : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    signal clk_10MHz    : STD_LOGIC := '0';
    signal start        : STD_LOGIC := '0';
    signal sdata        : STD_LOGIC := '0';
    signal cs           : STD_LOGIC;
    signal data_out     : STD_LOGIC_VECTOR(7 downto 0);
    
    constant clk_period : time := 100 ns; -- 10 MHz clock
    
    -- File handling
    file input_file: text;
    
    -- Function to convert std_logic_vector to string
    function to_string(slv: std_logic_vector) return string is
        variable result: string(1 to slv'length);
    begin
        for i in slv'range loop
            case slv(i) is
                when '0' => result(i+1) := '0';
                when '1' => result(i+1) := '1';
                when others => result(i+1) := 'X';
            end case;
        end loop;
        return result;
    end function;
    
begin
    uut: ADC_Reader port map (
        clk_10MHz => clk_10MHz,
        start => start,
        sdata => sdata,
        cs => cs,
        data_out => data_out
    );
    
    -- Clock process
    clk_process: process
    begin
        clk_10MHz <= '0';
        wait for clk_period/2;
        clk_10MHz <= '1';
        wait for clk_period/2;
    end process;
    
    -- Stimulus process
    stim_proc: process
        variable file_line : line;
        variable input_byte : std_logic_vector(7 downto 0);
        variable byte_count : integer := 0;
    begin
        file_open(input_file, "input_data.txt", read_mode);
        
        while not endfile(input_file) loop
            readline(input_file, file_line);
            read(file_line, input_byte);
            
            -- Start a new conversion
            start <= '1';
            wait until falling_edge(cs);
            start <= '0';
            
            -- Wait for 3 clock cycles (as per your entity design)
            for i in 1 to 3 loop
                wait until falling_edge(clk_10MHz);
            end loop;
            
            -- Send the data bits
            for i in 7 downto 0 loop
                sdata <= input_byte(i);
                wait until falling_edge(clk_10MHz);
            end loop;
            
            -- Wait for CS to go high again
            wait until rising_edge(cs);
            
            -- Check the output
            assert data_out = input_byte
                report "Mismatch: Expected " & to_string(input_byte) & ", got " & to_string(data_out)
                severity error;
            
            byte_count := byte_count + 1;
            wait for clk_period * 3; -- Wait a bit before starting the next conversion
        end loop;
        
        file_close(input_file);
        report "Simulation finished. Processed " & integer'image(byte_count) & " bytes.";
        wait;
    end process;

end Behavioral;