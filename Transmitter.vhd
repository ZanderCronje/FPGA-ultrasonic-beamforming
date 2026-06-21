library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Transmitter is
    Port ( 
        clk_50MHz   : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        start_bit   : in  STD_LOGIC;
        output_bit  : out STD_LOGIC;
        done_bit    : out STD_LOGIC
    );
end Transmitter;

architecture Behavioral of Transmitter is
    constant CLK_DIVIDER : integer := 625; 
    signal counter : integer range 0 to CLK_DIVIDER-1 := 0;
    signal pulse_count : integer range 0 to 4 := 0;
    signal output_40kHz : STD_LOGIC := '0';
    
    type state_type is (IDLE, TRANSMITTING, WAIT_FOR_HIGH);
    signal current_state : state_type := IDLE;
begin
    process(clk_50MHz, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            counter <= 0;
            pulse_count <= 0;
            output_40kHz <= '0';
            output_bit <= '0';
            done_bit <= '0';
        elsif rising_edge(clk_50MHz) then
            case current_state is
                when IDLE =>
                    done_bit <= '0';
                    output_bit <= '0';  
                    if start_bit = '1' then
                        current_state <= TRANSMITTING;
                        pulse_count <= 0;
                        counter <= 0;
                        output_40kHz <= '0';
                    end if;
                when TRANSMITTING =>
                    if counter = CLK_DIVIDER-1 then
                        counter <= 0;
                        output_40kHz <= not output_40kHz;
                        if output_40kHz = '1' then
                            pulse_count <= pulse_count + 1;
                            if pulse_count = 1 then
                                current_state <= WAIT_FOR_HIGH;
                                output_bit <= '0'; 
                            end if;
                        end if;
                    else
                        counter <= counter + 1;
                    end if;
                    output_bit <= output_40kHz;
                when WAIT_FOR_HIGH =>
                    done_bit <= '1';
                    output_bit <= '0'; 
                    if start_bit = '1' then
                        current_state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;