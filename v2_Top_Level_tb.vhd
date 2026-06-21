library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity v2_Top_Level_tb is
end v2_Top_Level_tb;

architecture Behavioral of v2_Top_Level_tb is
    -- Component declaration for the Unit Under Test (UUT)
    component v2_Top_Level
        Port ( 
            clk         : in  STD_LOGIC;
            start       : in  STD_LOGIC;
            ADCpin1     : in  STD_LOGIC;
            ADCpin2     : in  STD_LOGIC;
            ADCpin3     : in  STD_LOGIC;
            ADCpin4     : in  STD_LOGIC;
            ADCpin5     : in  STD_LOGIC;
            ADCpin6     : in  STD_LOGIC;
            ADCpin7     : in  STD_LOGIC;
            ADCpin8     : in  STD_LOGIC;
            BUFF1       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF2       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF3       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF4       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF5       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF6       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF7       : out STD_LOGIC_VECTOR(7 downto 0);
            BUFF8       : out STD_LOGIC_VECTOR(7 downto 0);
            adc_status  : out STD_LOGIC_VECTOR(7 downto 0);
            CLK_10      : out STD_LOGIC;
            buffer_full : out STD_LOGIC_VECTOR(7 downto 0);
            Trans_pin   : out STD_LOGIC;
            Buff_out    : out STD_LOGIC_VECTOR(7 downto 0);
            data_out    : out STD_LOGIC_VECTOR(7 downto 0);
            write_bit   : out STD_LOGIC
        );
    end component;

    -- Inputs
    signal clk      : STD_LOGIC := '0';
    signal start    : STD_LOGIC := '0';
    signal ADCpin1, ADCpin2, ADCpin3, ADCpin4, ADCpin5, ADCpin6, ADCpin7, ADCpin8 : STD_LOGIC := '0';

    -- Outputs
    signal BUFF1, BUFF2, BUFF3, BUFF4, BUFF5, BUFF6, BUFF7, BUFF8 : STD_LOGIC_VECTOR(7 downto 0);
    signal adc_status   : STD_LOGIC_VECTOR(7 downto 0);
    signal CLK_10       : STD_LOGIC;
    signal buffer_full  : STD_LOGIC_VECTOR(7 downto 0);
    signal Trans_pin    : STD_LOGIC;
    signal Buff_out     : STD_LOGIC_VECTOR(7 downto 0);
    signal data_out     : STD_LOGIC_VECTOR(7 downto 0);
    signal write_bit    : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 20 ns;  -- 50 MHz clock
    constant clk10_period : time := 100 ns;  -- 10 MHz clock

    -- Signals for controlling the testbench
    signal cs_active : STD_LOGIC := '0';
    signal clk10_count : integer := 0;
    signal set_pins : STD_LOGIC := '0';

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: v2_Top_Level port map (
        clk => clk, start => start,
        ADCpin1 => ADCpin1, ADCpin2 => ADCpin2, ADCpin3 => ADCpin3, ADCpin4 => ADCpin4,
        ADCpin5 => ADCpin5, ADCpin6 => ADCpin6, ADCpin7 => ADCpin7, ADCpin8 => ADCpin8,
        BUFF1 => BUFF1, BUFF2 => BUFF2, BUFF3 => BUFF3, BUFF4 => BUFF4,
        BUFF5 => BUFF5, BUFF6 => BUFF6, BUFF7 => BUFF7, BUFF8 => BUFF8,
        adc_status => adc_status, CLK_10 => CLK_10, buffer_full => buffer_full,
        Trans_pin => Trans_pin, Buff_out => Buff_out, data_out => data_out, write_bit => write_bit
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
        file file1, file2, file3, file4, file5, file6, file7, file8 : text;
        variable line1, line2, line3, line4, line5, line6, line7, line8 : line;
        variable value1, value2, value3, value4, value5, value6, value7, value8 : std_logic_vector(7 downto 0);
    begin
        -- Open the files
        file_open(file1, "adc_output_mic_1.txt", read_mode);
        file_open(file2, "adc_output_mic_2.txt", read_mode);
        file_open(file3, "adc_output_mic_3.txt", read_mode);
        file_open(file4, "adc_output_mic_4.txt", read_mode);
        file_open(file5, "adc_output_mic_5.txt", read_mode);
        file_open(file6, "adc_output_mic_6.txt", read_mode);
        file_open(file7, "adc_output_mic_7.txt", read_mode);
        file_open(file8, "adc_output_mic_8.txt", read_mode);

		              -- Set start bit
            start <= '1';
            wait for clk_period;
            start <= '0';
            wait for 10 us;
		  
		  
        while not endfile(file1) and not endfile(file2) and not endfile(file3) and not endfile(file4)
              and not endfile(file5) and not endfile(file6) and not endfile(file7) and not endfile(file8) loop
            
            -- Read values from files
            readline(file1, line1); read(line1, value1);
            readline(file2, line2); read(line2, value2);
            readline(file3, line3); read(line3, value3);
            readline(file4, line4); read(line4, value4);
            readline(file5, line5); read(line5, value5);
            readline(file6, line6); read(line6, value6);
            readline(file7, line7); read(line7, value7);
            readline(file8, line8); read(line8, value8);


            wait until adc_status = "00000000";
				wait for clk10_period*3;
            -- Set ADC pins
            for i in 0 to 7 loop
                wait for clk10_period;
                ADCpin1 <= value1(7-i);
                ADCpin2 <= value2(7-i);
                ADCpin3 <= value3(7-i);
                ADCpin4 <= value4(7-i);
                ADCpin5 <= value5(7-i);
                ADCpin6 <= value6(7-i);
                ADCpin7 <= value7(7-i);
                ADCpin8 <= value8(7-i);
					 
            end loop;
				--wait until adc_status = "11111111";


        end loop;

        -- Close the files
        file_close(file1);
        file_close(file2);
        file_close(file3);
        file_close(file4);
        file_close(file5);
        file_close(file6);
        file_close(file7);
        file_close(file8);

        -- End simulation
        wait;
    end process;

end Behavioral;