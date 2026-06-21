library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel is
    Port ( 
        clk_50          : in  STD_LOGIC;
        clk_10          : out STD_LOGIC;
        
        reset           : in  STD_LOGIC;    -- Active low                  
        start           : in  STD_LOGIC;    -- Active Low
        
        SIG_PIN         : out STD_LOGIC;
        
        ADC_CS          : out STD_LOGIC;
        ADC_pin1        : in  STD_LOGIC;
        ADC_pin2        : in  STD_LOGIC;
        ADC_pin3        : in  STD_LOGIC;
        ADC_pin4        : in  STD_LOGIC;
        ADC_pin5        : in  STD_LOGIC;
        ADC_pin6        : in  STD_LOGIC;
        ADC_pin7        : in  STD_LOGIC;
        ADC_pin8        : in  STD_LOGIC;
        
        TX_pin          : out STD_LOGIC;
        RX_pin          : in  STD_LOGIC;
		  
		  TEST_PIN			: out STD_LOGIC;
        
        TEST_LED        : out STD_LOGIC_VECTOR(7 downto 0)
		  
    );
end TopLevel;

architecture Behavioral of TopLevel is
	 component CLK_GEN is
		 Port ( 
			  CLK_IN  : in  STD_LOGIC;  
			  CLK_OUT : out STD_LOGIC  
		 );
	 end component;
    component Bi_Serial is
        Port ( 
              clk : in STD_LOGIC;
				  rst : in STD_LOGIC;
				  tx_data : in STD_LOGIC_VECTOR(7 downto 0);
				  tx_start : in STD_LOGIC;
				  tx_busy : out STD_LOGIC;
				  tx_done : out STD_LOGIC;
				  tx_line : out STD_LOGIC;
				  tx_flag : in STD_LOGIC;
				  rx_data : out STD_LOGIC_VECTOR(7 downto 0);
				  rx_done : out STD_LOGIC;
				  rx_line : in STD_LOGIC;
				  rx_flag : in STD_LOGIC
        );
    end component;
	 component Transmitter is
			  Port ( 
					clk_50MHz   : in  STD_LOGIC;
					reset       : in  STD_LOGIC; 
					start_bit   : in  STD_LOGIC;
					output_bit  : out STD_LOGIC;
					done_bit    : out STD_LOGIC
				  );
    end component;
	 component ADC_reader is
			 Port ( 
					clk_10MHz       : in STD_LOGIC;
					start           : in STD_LOGIC;
					sdata           : in STD_LOGIC;
					cs              : out STD_LOGIC;
					data_out        : out STD_LOGIC_VECTOR(7 downto 0);
					done            : out STD_LOGIC
			 );
	 end component;
	 component BRAM_4500x8 is
        Port (
            clk      : in  std_logic;
            we       : in  std_logic;
            w_addr   : in  std_logic_vector(12 downto 0);
            r_addr   : in  std_logic_vector(12 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
	 component BRAM_9200x8 is
        Port (
            clk      : in  std_logic;
            we       : in  std_logic;
            w_addr   : in  std_logic_vector(13 downto 0);
            r_addr   : in  std_logic_vector(13 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
	 component Counter is
        Port ( 
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            start : in  STD_LOGIC;
            done  : out STD_LOGIC
        );
    end component;
	 component att_comp is
		 Port ( 
			  clk : in STD_LOGIC;
			  start : in STD_LOGIC;
			  done : out STD_LOGIC;
			  counter : in STD_LOGIC_VECTOR(12 downto 0);
			  input : in STD_LOGIC_VECTOR(7 downto 0);
			  output : out STD_LOGIC_VECTOR(7 downto 0)
		 );
	 end component;
	 component Taper is
			 Generic (
				  MUL_VAL : STD_LOGIC_VECTOR(7 downto 0) := "11111111"
			 );
			 Port ( 
				  aclk    : in  STD_LOGIC;                     
				  start   : in  STD_LOGIC;                     
				  done    : out STD_LOGIC;                     
				  input   : in  STD_LOGIC_VECTOR(7 downto 0); 
				  output  : out STD_LOGIC_VECTOR(7 downto 0)
			 );
		end component;
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

   
    
    type state_type is (
			 STARTUP, 
			 IDLE, 
			 RECEIVE_G, 
			 RECEIVE_O, 
			 CHILL);
	 type trans_state is (
			 STARTUP, 
			 IDLE, 
			 TRANSMIT, 
			 START_ADC);
	 type ADC_state is (
			 STARTUP, 
			 IDLE, 
			 START_ADC, 
			 SAMPLE,
			 WRITE_WAIT, 
			 WRITE_BUFF,
			 CHECK_DATA,
			 ADC_WAIT,
			 CHILL);
	 type PROC_state is (
			 STARTUP, 
			 IDLE, 
			 GET_DATA,
			 WAIT_DATA,
			 WRITE_DATA1,
			 WRITE_DATA2,
			 WRITE_DATA3,
			 WRITE_DATA4,
			 WRITE_DATA5,
			 WRITE_DATA6,
			 WRITE_DATA7,
			 WRITE_DATA8,
			 WRITE_DATA9,
			 SEND_DATA,
			 CHECK_DATA,	 
			 COMPEN,
			 TAP,
			 CHILL);
	 type READ_state is (
			 STARTUP, 
			 IDLE, 
			 GET_DATA,
			 SHIFT_DATA,
			 SEGMENT,
			 SEND_DATA,
			 CHECK_DATA,	 
			 CHILL);
    signal current_UART_state, next_UART_state : state_type := STARTUP;
	 signal current_trans_state, next_trans_state : trans_state := STARTUP;
	 signal current_ADC_state, next_ADC_state : ADC_State := STARTUP;
	 signal current_PROC_state, next_PROC_state : PROC_state := STARTUP;
	 signal current_READ_state, next_READ_state : READ_state := STARTUP;
	 
	 signal clk_10_int		: std_logic;
	 
	 signal RST_proc			: std_logic		:= '0';
	 signal TRANS_proc		: std_logic		:= '0';
	 signal ADC_proc			: std_logic		:= '0';
	 Signal PROC_proc			: std_logic		:=	'0';
	 Signal READ_proc			: std_logic		:=	'0';
	 
	 
	 signal tx_data        : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    signal tx_start       : STD_LOGIC;
    signal tx_busy        : STD_LOGIC;
    signal rx_data        : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_done        : STD_LOGIC;
    signal UART_reset     : STD_LOGIC := '0';
    signal rx_flag        : STD_LOGIC := '0';  
    signal tx_flag        : STD_LOGIC := '0';
	 signal tx_done		  : STD_LOGIC;
	 
	 signal	TRANS_start		:	std_logic	:=	'0';
	 signal	TRANS_done		:	std_logic;
	 signal	TRANS_reset		:	std_logic	:= '0';
	 
	 signal	ADC_Start		:  std_logic	:= '0';
	 signal	ADC_CS_int		:	std_logic_vector(7 downto 0);
	 signal	ADC_out1			:	std_logic_vector(7 downto 0);
	 signal	ADC_out2			:	std_logic_vector(7 downto 0);
	 signal	ADC_out3			:	std_logic_vector(7 downto 0);
	 signal	ADC_out4			:	std_logic_vector(7 downto 0);
	 signal	ADC_out5			:	std_logic_vector(7 downto 0);
	 signal	ADC_out6			:	std_logic_vector(7 downto 0);
	 signal	ADC_out7			:	std_logic_vector(7 downto 0);
	 signal	ADC_out8			:	std_logic_vector(7 downto 0);
	 signal	ADC_done			:  std_logic_vector(7 downto 0);

	 signal	sample_counter	: Natural range 0 to 4499 := 0;
	 signal	MM_counter		: Natural range 0 to 8999 := 0;
	 signal  inc_count_flag	: std_logic	:= '0';
	 signal	rst_count_flag	: std_logic	:= '0';
	 signal  inc_RAM_flag	: std_logic	:= '0';
	 signal  inc_MM_flag		: std_logic	:= '0';
	 signal	rst_MM_flag		: std_logic	:= '0';
	 
	 signal	RAM_WE			: std_logic := '0';
	 signal 	RAM_w_addr     : std_logic_vector(12 downto 0);
	 signal 	RAM_r_addr    : std_logic_vector(12 downto 0);
	 signal	RAM_data1 		: std_logic_vector(7 downto 0);
	 signal	RAM_data2 		: std_logic_vector(7 downto 0);
	 signal	RAM_data3 		: std_logic_vector(7 downto 0);
	 signal	RAM_data4 		: std_logic_vector(7 downto 0);
	 signal	RAM_data5 		: std_logic_vector(7 downto 0);
	 signal	RAM_data6 		: std_logic_vector(7 downto 0);
	 signal	RAM_data7 		: std_logic_vector(7 downto 0);
	 signal	RAM_data8 		: std_logic_vector(7 downto 0);
	 
	 signal counter_rst	   : STD_LOGIC;
    signal counter_start	: STD_LOGIC;
    signal counter_done	   : STD_LOGIC;
	 signal counter_reg 		: std_logic_vector(12 downto 0);
	 
	 signal	Att_start		: std_logic	:= '0';
	 signal	Att_done			: std_logic_vector(7 downto 0);
	 signal	Att_output1		: std_logic_vector(7 downto 0);
	 signal	Att_output2		: std_logic_vector(7 downto 0);
	 signal	Att_output3		: std_logic_vector(7 downto 0);
	 signal	Att_output4		: std_logic_vector(7 downto 0);
	 signal	Att_output5		: std_logic_vector(7 downto 0);
	 signal	Att_output6		: std_logic_vector(7 downto 0);
	 signal	Att_output7		: std_logic_vector(7 downto 0);
	 signal	Att_output8		: std_logic_vector(7 downto 0);
	 
	 signal  TAP_start		: std_logic	:=	'0';
	 signal	TAP_done			: std_logic_vector(7 downto 0);
	 signal	TAP_input1		: std_logic_vector(7 downto 0);
	 signal	TAP_input2		: std_logic_vector(7 downto 0);
	 signal	TAP_input3		: std_logic_vector(7 downto 0);
	 signal	TAP_input4		: std_logic_vector(7 downto 0);
	 signal	TAP_input5		: std_logic_vector(7 downto 0);
	 signal	TAP_input6		: std_logic_vector(7 downto 0);
	 signal	TAP_input7		: std_logic_vector(7 downto 0);
	 signal	TAP_input8		: std_logic_vector(7 downto 0);
	 signal	TAP_output1		: std_logic_vector(7 downto 0);
	 signal	TAP_output2		: std_logic_vector(7 downto 0);
	 signal	TAP_output3		: std_logic_vector(7 downto 0);
	 signal	TAP_output4		: std_logic_vector(7 downto 0);
	 signal	TAP_output5		: std_logic_vector(7 downto 0);
	 signal	TAP_output6		: std_logic_vector(7 downto 0);
	 signal	TAP_output7		: std_logic_vector(7 downto 0);
	 signal	TAP_output8		: std_logic_vector(7 downto 0);

	 
	 signal	MIC_RAM_WE			: std_logic := '0';
	 signal 	MIC_RAM_w_addr    : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr1   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr2   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr3   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr4   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr5   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr6   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr7   : std_logic_vector(13 downto 0);
	 signal 	MIC_RAM_r_addr8   : std_logic_vector(13 downto 0);
	 signal	MIC_RAM_data1 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data2 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data3 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data4 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data5 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data6 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data7 		: std_logic_vector(7 downto 0);
	 signal	MIC_RAM_data8 		: std_logic_vector(7 downto 0);
	
	 signal	MIC_NUM				: natural range 0 to 8 := 0;
	 signal	inc_MICNUM			: std_logic	:= '0';
	 
	 
	 signal	DnS_start			:	std_logic	:= '0';
	 signal	DnS_reset			:	std_logic	:=	'0';
	 signal	Dns_Done				:	std_logic;
	 signal	DnS_counter			:	std_logic_vector(13 downto 0);
	 signal 	DnS_Delay1			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay2			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay3			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay4			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay5			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay6			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay7			:	signed(7 downto 0)	:= "00000000";
	 signal 	DnS_Delay8			:	signed(7 downto 0)	:= "00000000";
	 signal	DnS_output			:	std_logic_vector(7 downto 0);
	 signal	DnS_addr1			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr2			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr3			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr4			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr5			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr6			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr7			:	std_logic_vector(13 downto 0);
	 signal	DnS_addr8			:	std_logic_vector(13 downto 0);
	 signal	DnS_data1			:	std_logic_vector(7 downto 0);
	 signal	DnS_data2			:	std_logic_vector(7 downto 0);
	 signal	DnS_data3			:	std_logic_vector(7 downto 0);
	 signal	DnS_data4			:	std_logic_vector(7 downto 0);
	 signal	DnS_data5			:	std_logic_vector(7 downto 0);
	 signal	DnS_data6			:	std_logic_vector(7 downto 0);
	 signal	DnS_data7			:	std_logic_vector(7 downto 0);
	 signal	DnS_data8			:	std_logic_vector(7 downto 0);
	 
	 signal	Temp_SEG				: unsigned(10 downto 0) := "00000000000";
	 signal  rst_SEG				: std_logic	:= '0';
	 signal  inc_SEG				: std_logic	:= '0';

	 
	 
	 
	 
	 signal DEBUG					: std_logic_vector(7 downto 0);
  

    
begin

CLK10:CLK_GEN
    Port map( 
        CLK_IN  =>clk_50,  
        CLK_OUT =>clk_10_int  
    );
	 
Counter_inst : Counter
    port map (
        clk   => clk_50,
        reset => counter_rst,
        start => counter_start,
        done  => counter_done
    );
	 
UART: Bi_Serial 		
port map(	clk 			=> 	clk_50,
				rst 			=> 	UART_reset, 
				tx_data 		=> 	tx_data,
				tx_start		=>		tx_start,
				tx_busy		=>		tx_busy,
				tx_line		=>		TX_pin,
				rx_data		=>		rx_data,
				rx_done		=>		rx_done,
				rx_line		=>		RX_pin,
				tx_flag		=>		tx_flag,
				rx_flag		=>		rx_flag,
				tx_done 		=> 	tx_done
				);
				
TRANS: Transmitter 	port map(clk_50MHz=>clk_50,start_bit=>TRANS_start,reset=>TRANS_reset,output_bit=>SIG_PIN,done_bit=>TRANS_done);
ADC1: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin1,cs => ADC_CS_int(0),data_out => ADC_out1,done => ADC_done(0));
ADC2: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin2,cs => ADC_CS_int(1),data_out => ADC_out2,done => ADC_done(1));
ADC3: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin3,cs => ADC_CS_int(2),data_out => ADC_out3,done => ADC_done(2));
ADC4: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin4,cs => ADC_CS_int(3),data_out => ADC_out4,done => ADC_done(3));
ADC5: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin5,cs => ADC_CS_int(4),data_out => ADC_out5,done => ADC_done(4));
ADC6: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin6,cs => ADC_CS_int(5),data_out => ADC_out6,done => ADC_done(5));
ADC7: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin7,cs => ADC_CS_int(6),data_out => ADC_out7,done => ADC_done(6));
ADC8: ADC_reader		Port map (clk_10MHz => clk_10_int, start => ADC_Start, sdata => ADC_pin8,cs => ADC_CS_int(7),data_out => ADC_out8,done => ADC_done(7));

ADC_RAM1: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out1, data_out => RAM_data1);
ADC_RAM2: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out2, data_out => RAM_data2);
ADC_RAM3: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out3, data_out => RAM_data3);
ADC_RAM4: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out4, data_out => RAM_data4);
ADC_RAM5: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out5, data_out => RAM_data5);
ADC_RAM6: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out6, data_out => RAM_data6);
ADC_RAM7: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out7, data_out => RAM_data7);
ADC_RAM8: BRAM_4500x8	Port map (clk => clk_50, we  => RAM_WE, w_addr => RAM_w_addr, r_addr => RAM_r_addr, data_in => ADC_out8, data_out => RAM_data8);

MIC_RAM1: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr1, data_in => TAP_output1, data_out => DnS_data1);
MIC_RAM2: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr2, data_in => TAP_output2, data_out => DnS_data2);
MIC_RAM3: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr3, data_in => TAP_output3, data_out => DnS_data3);
MIC_RAM4: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr4, data_in => TAP_output4, data_out => DnS_data4);
MIC_RAM5: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr5, data_in => TAP_output5, data_out => DnS_data5);
MIC_RAM6: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr6, data_in => TAP_output6, data_out => DnS_data6);
MIC_RAM7: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr7, data_in => TAP_output7, data_out => DnS_data7);
MIC_RAM8: BRAM_9200x8	Port map (clk => clk_50, we  => MIC_RAM_WE, w_addr => MIC_RAM_w_addr, r_addr => DnS_addr8, data_in => TAP_output8, data_out => DnS_data8);

ATT1: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(0),counter => RAM_r_addr,input =>	RAM_data1,output =>	TAP_input1);
ATT2: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(1),counter => RAM_r_addr,input =>	RAM_data2,output =>	TAP_input2);
ATT3: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(2),counter => RAM_r_addr,input =>	RAM_data3,output =>	TAP_input3);
ATT4: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(3),counter => RAM_r_addr,input =>	RAM_data4,output =>	TAP_input4);
ATT5: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(4),counter => RAM_r_addr,input =>	RAM_data5,output =>	TAP_input5);
ATT6: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(5),counter => RAM_r_addr,input =>	RAM_data6,output =>	TAP_input6);
ATT7: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(6),counter => RAM_r_addr,input =>	RAM_data7,output =>	TAP_input7);
ATT8: att_comp  	Port map ( clk => clk_50,start => Att_start,done => Att_done(7),counter => RAM_r_addr,input =>	RAM_data8,output =>	TAP_input8);		 
		 
TAP1: Taper
    generic map ( MUL_VAL => "10010100")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(0), input   => TAP_input1, output  => TAP_output1);
TAP2: Taper
    generic map ( MUL_VAL => "10101000")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(1), input   => TAP_input2, output  => TAP_output2);
TAP3: Taper
    generic map ( MUL_VAL => "11100000")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(2), input   => TAP_input3, output  => TAP_output3);
TAP4: Taper
    generic map ( MUL_VAL => "11111111")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(3), input   => TAP_input4, output  => TAP_output4);
TAP5: Taper
    generic map ( MUL_VAL => "11111111")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(4), input   => TAP_input5, output  => TAP_output5);
TAP6: Taper
    generic map ( MUL_VAL => "11100000")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(5), input   => TAP_input6, output  => TAP_output6);
TAP7: Taper
    generic map ( MUL_VAL => "10101000")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(6), input   => TAP_input7, output  => TAP_output7);
TAP8: Taper
    generic map ( MUL_VAL => "10010100")
    port map ( aclk    => clk_50, start   => TAP_start, done    => TAP_done(7), input   => TAP_input8, output  => TAP_output8);	
	 
DnS1 : DelayAndSumFilter
	port map (
		 clk          => clk_50,           
		 reset        => DnS_reset,
		 start        => DnS_start,
		 addr_counter => DnS_counter,
		 
		 DELAY1       => DnS_Delay1,
		 DELAY2       => DnS_Delay2,
		 DELAY3       => DnS_Delay3,
		 DELAY4       => DnS_Delay4,
		 DELAY5       => DnS_Delay5,
		 DELAY6       => DnS_Delay6,
		 DELAY7       => DnS_Delay7,
		 DELAY8       => DnS_Delay8,
		 
		 MIC_DATA_0   => DnS_data1,
		 MIC_DATA_1   => DnS_data2,
		 MIC_DATA_2   => DnS_data3,
		 MIC_DATA_3   => DnS_data4,
		 MIC_DATA_4   => DnS_data5,
		 MIC_DATA_5   => DnS_data6,
		 MIC_DATA_6   => DnS_data7,
		 MIC_DATA_7   => DnS_data8,
		 
		 MIC_ADDR_0   => DnS_addr1,
		 MIC_ADDR_1   => DnS_addr2,
		 MIC_ADDR_2   => DnS_addr3,
		 MIC_ADDR_3   => DnS_addr4,
		 MIC_ADDR_4   => DnS_addr5,
		 MIC_ADDR_5   => DnS_addr6,
		 MIC_ADDR_6   => DnS_addr7,
		 MIC_ADDR_7   => DnS_addr8,
		 
		 OUTPUT       => DnS_output,
		 sum_done     => DnS_Done
	);	 

 
 
    STATE_HANDLER: process(CLK_50, reset, RST_proc)
    begin
        if (reset = '0' ) then
            current_UART_state 	<= STARTUP;
				current_trans_state 	<= STARTUP;
				current_ADC_state		<=	STARTUP;
				current_PROC_state	<=	STARTUP;
				current_READ_state	<=	STARTUP;

        elsif rising_edge(CLK_50) then
				if (RST_proc = '1') then
					current_UART_state 	<= STARTUP;
					current_trans_state 	<= STARTUP;
					current_ADC_state		<=	STARTUP;
					current_PROC_state	<=	STARTUP;
					current_READ_state	<=	STARTUP;
				else
					current_UART_state 	<= next_UART_state;
					current_trans_state 	<= next_trans_state;
					current_ADC_state		<=	next_ADC_state;
					current_PROC_state	<=	next_PROC_state;
					current_READ_state	<=	next_READ_state;
				end if;

        end if;
    end process STATE_HANDLER;
    
    START_DETECTOR: process(current_UART_state, rx_done, rx_data)
    begin
		  if (Rst_proc = '1') then
				next_UART_state <= STARTUP;
		  end if;
		  
		  UART_reset			<= '0';
        next_UART_state 	<= current_UART_state;
		  rx_flag	  			<= '1';
		  TRANS_proc			<=	'0';
        case current_UART_state is
            when STARTUP => 
									 UART_reset			<= '1';
									 next_UART_state <= IDLE;
                
            when IDLE =>	next_UART_state <= RECEIVE_G;
									 
            
            when RECEIVE_G =>
									 if rx_done = '1' then
										  if rx_data = "01000111" then  -- 'G'
												next_UART_state <= RECEIVE_O;
										  end if;
									 end if;
									 
            
            when RECEIVE_O =>if rx_done = '1' then
										  if rx_data = "01001111" then  -- 'O'
												next_UART_state <= CHILL;
										  else
												next_UART_state <= RECEIVE_G;
										  end if;
									 end if;
									 
            
            when CHILL =>
									
									TRANS_proc			<=	'1';
									rx_flag	  			<= '0';
            when others => 
                next_UART_state <= IDLE;
        end case;
    end process START_DETECTOR;
	 
	 TANSMISSION: process(TRANS_proc, current_trans_state, Trans_Done, start)
		begin

			 Trans_Start 		<= '0';
			 TRANS_reset		<=	'0';
			 next_trans_state <= current_trans_state;
			 ADC_proc			<=		'0'; 
			 tx_flag			<= 	'0';
			 case current_trans_state is
				  when STARTUP 	=>		TRANS_reset		<=	'1';
												next_trans_state <= IDLE;

				  when IDLE 		=>
												if TRANS_proc = '1' then
													Trans_Start <= '1';
													next_trans_state <= TRANSMIT;
												end if;

				  when TRANSMIT 	=>
												if Trans_Done = '1' then
													next_trans_state <= START_ADC;
												else
													Trans_Start <= '0';
												end if;

				  when START_ADC 	=>	   
												ADC_proc			<=		'1';
												tx_flag			<= 	'1';
												next_trans_state <= START_ADC;

				  when others 		=>
												next_trans_state <= IDLE;
			 end case;
		end process TANSMISSION;
		



ADC: process(current_ADC_state, ADC_done,ADC_proc,counter_done,sample_counter)
begin
	 counter_rst	<= '0';	
    next_ADC_state   <= current_ADC_state;
    inc_count_flag   <= '0'; 
	 ADC_Start			<=	'0';
	 RAM_WE				<=	'0';
	 PROC_proc 			<= '0';
	 counter_start		<=	'0';


    case current_ADC_state is
        when STARTUP =>    
									next_ADC_state <= IDLE;
										
        
        when IDLE =>
									if ADC_proc = '1' then
										 next_ADC_state <= START_ADC;
									end if;

        when START_ADC =>  
									next_ADC_state <= SAMPLE;

									
        when SAMPLE =>	ADC_Start	<=	'1';
								counter_rst	<= '1';
								if (ADC_done = "11111111") then
									RAM_w_addr	<=	std_logic_vector(to_unsigned(sample_counter,13));
									ADC_Start	<=	'0';	
									next_ADC_state <= WRITE_BUFF;
								end if; 

        when WRITE_BUFF =>	RAM_WE		<=	'1';
									if (sample_counter < 4499) then
										 next_ADC_state <= ADC_Wait;
										 inc_count_flag <= '1';	 
									else
										 inc_count_flag <= '1';
										 next_ADC_state <= CHILL;
									end if;

		  when ADC_Wait=>	   counter_start <= '1';
									if (counter_done = '1') then
										
										next_ADC_state <= START_ADC;
									end if;

        when CHILL =>    	PROC_proc 	<= '1';


        
        when others => 
            next_ADC_state <= IDLE;
    end case;
end process ADC;



COUNTERP:process (CLK_50)
begin
    if rising_edge(CLK_50)  then
        if reset = '0' or RST_proc = '1' then
            sample_counter <= 0;
        else
            if rst_count_flag = '1'  then
                sample_counter <= 0;
            elsif inc_count_flag = '1' or inc_RAM_flag = '1' then
                sample_counter <= sample_counter + 1;
            end if;
        end if;
    end if;
end process COUNTERP;


PROC_P: process(current_PROC_state, PROC_proc, Att_done, TAP_done)
begin
    next_PROC_state   <= current_PROC_state;
    READ_proc         <= '0';
    inc_RAM_flag      <= '0'; 
    rst_count_flag    <= '0';
    MIC_RAM_WE        <= '0';
    Att_start         <= '0';
    TAP_start         <= '0';
    
    case current_PROC_state is
        when STARTUP =>    
            next_PROC_state <= IDLE;
            
        when IDLE =>    
            if (PROC_proc = '1') then
                next_PROC_state <= GET_DATA;
                rst_count_flag <= '1';
            end if;  
            
        when GET_DATA =>   
            RAM_r_addr <= std_logic_vector(to_unsigned(sample_counter,13));
            next_PROC_state <= COMPEN;
            
        when COMPEN =>    
            Att_start <= '1';
            if (Att_done = "11111111") then
                Att_start <= '0';
                next_PROC_state <= TAP;
            end if;
            
        when TAP =>    
            TAP_start <= '1';
            if (TAP_done = "11111111") then
                TAP_start <= '0';
                next_PROC_state <= WRITE_DATA1;
            end if;
            

        when WRITE_DATA1 =>  
											MIC_RAM_w_addr <= std_logic_vector(to_unsigned((sample_counter *2) +100, 14));
											next_PROC_state <= WRITE_DATA2;										
            
        when WRITE_DATA2 =>  	 MIC_RAM_WE        <= '1';
										 next_PROC_state <= WRITE_DATA3;   
									
		  when WRITE_DATA3 =>  
											RAM_r_addr <= std_logic_vector(to_unsigned(sample_counter,13));
											next_PROC_state <= WRITE_DATA4;
		  		
		  when WRITE_DATA4 =>  
											MIC_RAM_w_addr <= std_logic_vector(to_unsigned((sample_counter *2) +101, 14));
											next_PROC_state <= WRITE_DATA5;										
            
        when WRITE_DATA5 =>  	 MIC_RAM_WE        <= '1';
										 next_PROC_state <= CHECK_DATA; 
            
        when CHECK_DATA => 
				MIC_RAM_WE <= '0';
            if (sample_counter < 4499) then
                next_PROC_state <= GET_DATA;
                inc_RAM_flag <= '1';
            else
                next_PROC_state <= CHILL; 
            end if;
            
        when CHILL =>        
            READ_proc <= '1';
            
        when others => 
            next_PROC_state <= IDLE;
    end case;
end process PROC_P;


READ_P: process(current_READ_state, READ_proc,DnS_Done,tx_done)
begin
next_READ_state <= current_READ_state;
RST_proc 	<= '0';
inc_MM_flag <= '0';
inc_MICNUM  <= '0';
DnS_Start	<=	'0';
tx_start		<= '0';
rst_MM_flag	<= '0';

rst_SEG		<= '0';
inc_SEG		<= '0';
    case current_READ_state is
        when STARTUP =>    next_READ_state <= IDLE;
									rst_MM_flag			<= '1';
									rst_SEG				<= '1';

        when IDLE 	=>  if (READ_proc = '1') then
									next_READ_state <= GET_DATA;
								 end if;	
								 

        when GET_DATA =>	case MIC_NUM is
										when 0 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(43, 8);  
															DnS_Delay2 <= to_signed(31, 8);   
															DnS_Delay3 <= to_signed(18, 8);   
															DnS_Delay4 <= to_signed(6, 8);    
															DnS_Delay5 <= to_signed(-6, 8);   
															DnS_Delay6 <= to_signed(-18, 8);  
															DnS_Delay7 <= to_signed(-31, 8);  
															DnS_Delay8 <= to_signed(-43, 8);  
															next_READ_state <= SHIFT_DATA;
										when 1 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(33, 8);  
															DnS_Delay2 <= to_signed(23, 8);   
															DnS_Delay3 <= to_signed(14, 8);   
															DnS_Delay4 <= to_signed(5, 8);    
															DnS_Delay5 <= to_signed(-5, 8);   
															DnS_Delay6 <= to_signed(-14, 8); 
															DnS_Delay7 <= to_signed(-23, 8); 
															DnS_Delay8 <= to_signed(-33, 8); 
															next_READ_state <= SHIFT_DATA;
										when 2 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(22, 8);  
															DnS_Delay2 <= to_signed(15, 8);   
															DnS_Delay3 <= to_signed(9, 8);  
															DnS_Delay4 <= to_signed(3, 8);   
															DnS_Delay5 <= to_signed(-3, 8);   
															DnS_Delay6 <= to_signed(-9, 8);  
															DnS_Delay7 <= to_signed(-15, 8);  
															DnS_Delay8 <= to_signed(-22, 8);  
															next_READ_state <= SHIFT_DATA;
										when 3 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(11, 8); 
															DnS_Delay2 <= to_signed(8, 8);  
															DnS_Delay3 <= to_signed(5, 8); 
															DnS_Delay4 <= to_signed(2, 8); 
															DnS_Delay5 <= to_signed(-2, 8); 
															DnS_Delay6 <= to_signed(-5, 8); 
															DnS_Delay7 <= to_signed(-8, 8);  
															DnS_Delay8 <= to_signed(-11, 8); 
															next_READ_state <= SHIFT_DATA;
										when 4 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(0, 8);   
															DnS_Delay2 <= to_signed(0, 8);   
															DnS_Delay3 <= to_signed(0, 8);   
															DnS_Delay4 <= to_signed(0, 8);   
															DnS_Delay5 <= to_signed(0, 8);   
															DnS_Delay6 <= to_signed(0, 8);  
															DnS_Delay7 <= to_signed(0, 8); 
															DnS_Delay8 <= to_signed(0, 8); 
															next_READ_state <= SHIFT_DATA;
										when 5 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(-11, 8);  
															DnS_Delay2 <= to_signed(-8, 8);  
															DnS_Delay3 <= to_signed(-5, 8);  
															DnS_Delay4 <= to_signed(-2, 8); 
															DnS_Delay5 <= to_signed(2, 8);   
															DnS_Delay6 <= to_signed(5, 8);  
															DnS_Delay7 <= to_signed(8, 8);  
															DnS_Delay8 <= to_signed(11, 8);
															next_READ_state <= SHIFT_DATA;
										when 6 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(-22, 8);   
															DnS_Delay2 <= to_signed(-15, 8);  
															DnS_Delay3 <= to_signed(-6, 8);   
															DnS_Delay4 <= to_signed(-3, 8);   
															DnS_Delay5 <= to_signed(3, 8);   
															DnS_Delay6 <= to_signed(9, 8);  
															DnS_Delay7 <= to_signed(15, 8); 
															DnS_Delay8 <= to_signed(22, 8);  
															next_READ_state <= SHIFT_DATA;
										when 7 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(-33, 8);  
															DnS_Delay2 <= to_signed(-23, 8);   
															DnS_Delay3 <= to_signed(-14, 8);  
															DnS_Delay4 <= to_signed(-5, 8);    
															DnS_Delay5 <= to_signed(5, 8);   
															DnS_Delay6 <= to_signed(14, 8); 
															DnS_Delay7 <= to_signed(23, 8);
															DnS_Delay8 <= to_signed(33, 8);  
															next_READ_state <= SHIFT_DATA;
										when 8 =>		DnS_counter		<= std_logic_vector(to_unsigned((MM_counter+100), 14));
															DnS_Delay1 <= to_signed(-43, 8);  
															DnS_Delay2 <= to_signed(-31, 8);  
															DnS_Delay3 <= to_signed(-18, 8);  
															DnS_Delay4 <= to_signed(-6, 8); 
															DnS_Delay5 <= to_signed(6, 8);   
															DnS_Delay6 <= to_signed(18, 8);  
															DnS_Delay7 <= to_signed(31, 8);  
															DnS_Delay8 <= to_signed(43, 8);  
															next_READ_state <= SHIFT_DATA;
										when others => next_READ_state <= CHILL;
									end case;
									
									
									
		  when SHIFT_DATA =>	DnS_start <= '1';
									if (DnS_done = '1') then
										inc_SEG		<= '1';
										next_READ_state <= SEGMENT;
									end if;
									
		  when SEGMENT		=> if ((MM_counter + 1) mod 16 = 0) then
										tx_data <= std_logic_vector(Temp_SEG(9 downto 2));
										next_READ_state <= SEND_DATA;
									else
										next_READ_state <= CHECK_DATA;
									end if;
									
		  when SEND_DATA =>	tx_start		<= '1';
									if(tx_done = '1') then
										rst_SEG	<= '1';
										next_READ_state <= CHECK_DATA;
									end if;
									
		  

        when CHECK_DATA => if (MM_counter < 8991) then
										inc_MM_flag <= '1';
										next_READ_state <= GET_DATA;
									else
										if (MIC_NUM < 8) then
											next_READ_state 	<= GET_DATA;
											inc_MICNUM			<= '1';
											rst_MM_flag			<= '1';
										else
											next_READ_state 	<= CHILL;
										end if;
										
									end if;
									
        when CHILL => 
							 RST_proc 		<= '1';
							
	

        when others => 
            next_READ_state <= IDLE;
    end case;
end process READ_P;

Read_counterP: process (CLK_50)
begin
    if rising_edge(CLK_50) then
        if reset = '0' or RST_proc = '1' then
            MM_counter <= 0;
            MIC_NUM <= 0;
            Temp_SEG <= to_unsigned(0,11);
        else
            if rst_MM_flag = '1'  then
                MM_counter <= 0;
            elsif inc_MM_flag = '1' then
                MM_counter <= MM_counter + 1;
            end if;
            
            if (inc_MICNUM = '1') then
                MIC_NUM <= MIC_NUM + 1;
                MM_counter <= 0;
            end if;
				
				if (rst_SEG = '1') then
                Temp_SEG	<= to_unsigned(0,11);
            end if;
				
				if (inc_SEG = '1') then
                Temp_SEG <= Temp_SEG + resize(unsigned(DnS_output), 11);
            end if;
				
				
        end if;
    end if;
end process Read_counterP;
	
	TEST_LED(0) <= TRANS_proc;
	TEST_LED(1) <= ADC_proc;
	TEST_LED(2) <= PROC_proc;
	TEST_LED(3) <= READ_proc;
	TEST_LED(4) <= RST_proc;
	


    clk_10 <= clk_10_int;
	 ADC_CS <= ADC_CS_int(0);

    
end Behavioral;
