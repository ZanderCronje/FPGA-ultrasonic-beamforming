library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity att_comp is
    Port ( 
        clk     : in STD_LOGIC;
        start   : in STD_LOGIC;
        done    : out STD_LOGIC;
        counter : in STD_LOGIC_VECTOR(12 downto 0);
        input   : in STD_LOGIC_VECTOR(7 downto 0);
        output  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end att_comp;

architecture Behavioral of att_comp is
    type state_type is (IDLE, PROCESSING, sWAIT, sOUTPUT, FINISHED);
	 signal state : state_type := IDLE;
	 
	 
	 
	 signal temp_input 	: 	unsigned(7 downto 0) := (others => '0');
	 signal temp_counter :	natural	range 0 to 4500 := 0;
	 
    
    signal result : UNSIGNED(7 downto 0) := (others => '0');
    signal mult_result : UNSIGNED(15 downto 0) := (others => '0');
	 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            done <= '0';
            case state is
                when IDLE =>
                    if start = '1' then
								temp_input 		<= unsigned(input);
								temp_counter	<= to_integer(unsigned(counter));
                        state <= PROCESSING;
                    end if;

                when PROCESSING =>
							case temp_counter is
									when 0 to 2000 =>
										 result <= "00000001";  
										 state <= sWAIT;
									when 2001 to 2125 =>
										 result <= "00000010";  
										 state <= sWAIT;
									when 2126 to 2300 =>
										 result <= "00000011";  
										 state <= sWAIT;
									when 2301 to 2600 =>
										 result <= "00000100";  
										 state <= sWAIT;
									when 2601 to 3000 =>
										 result <= "00000101";  
										 state <= sWAIT;
									when 3001 to 3500 =>
										 result <= "00000110";  
										 state <= sWAIT;
									when 3501 to 3900 =>
										 result <= "00000111"; 
										 state <= sWAIT;
									when 3901 to 4200 =>
										 result <= "00001000"; 
										 state <= sWAIT;
									when 4201 to 4375 =>
										 result <= "00001000";  
										 state <= sWAIT;
									when 4376 to 4500 =>
										 result <= "00001000";  
										 state <= sWAIT;

								 when others =>
									  result <= "00000000";
									  state <= IDLE;
							end case;

                when sWAIT =>		mult_result <= temp_input * result;
											state <= sOUTPUT;


                when sOUTPUT =>	if (mult_result < 255) then
												output <= std_logic_vector(mult_result(7 downto 0));
											else
												 output <= "11111111";
											end if;
											done <= '1';
											state <= FINISHED;

                when FINISHED =>	
											state <= IDLE;


                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end Behavioral;

